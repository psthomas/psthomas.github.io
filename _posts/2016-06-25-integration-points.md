---
layout: post
title: Integration by Points
excerpt: "Using the python library Pillow to build a dataset by counting the pixels of an image"
#modified: 2016-02-24
tags: [project, Python, Pillow, requests, temperature, climate]
comments: true
share: false

---

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/Chicago.png"><img src="{{ site.baseurl }}/images/Chicago.png"></a>
	<figcaption>The temperature bands for Chicago, which ranks pretty low in my final analysis.</figcaption>
</figure>

I was recently trying to determine which city has the most comfortable climate.  I came across the website [WeatherSpark](https://weatherspark.com), which provides a lot of great information on annual temperature, relative humidity, cloud cover, and precipitation all summed up in some pretty nice graphics.  I was trying to find the source of their data, but couldn't find it on NOAA’s [website](http://www.weather.gov/).  

But then I realized that the graphics themselves are a source of data -- I just needed to count the pixels associated with each temperature band in the graphic to build a halfway decent dataset.  Below, I use a Python imaging library called [Pillow](https://python-pillow.org/) and images I scraped from WeatherSpark to find the US City with the most comfortable temperature throughout the year.  The final code is [here](https://gist.github.com/psthomas/a52b760fc6c1c1155c539da6ceb591ce).

## Getting the Images

This is an example image showing the fraction of time spent within certain temperature bands throughout the year.  By counting the pixels associated with each color, I can find the percentage of time spent within each band annually.

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/temperature_bands.png"><img src="{{ site.baseurl }}/images/temperature_bands.png"></a>
</figure>

The temperature images aren’t at predictable URLs, so I wrote this function to visit each city URL and find the URL for the temperature bands image.  The cities that I used were the top 50 in the [US by population](https://en.wikipedia.org/wiki/List_of_United_States_cities_by_population), with Honolulu and Anchorage thrown in for geographic diversity.

{% highlight python %}

def get_image_urls(city_list):
	'''Takes a list of lists containing cities and urls, modifies original list to add urls for images'''

	for i in range(len(city_list)):
		city = city_list[i]
		r = requests.get(city[1])
		time.sleep(0.1) # Good web citizen

		if r.status_code == 200:
			soup = BeautifulSoup(r.text, 'html.parser')
			# Uses CSS selectors:
			url =  str(soup.select('img[basesrc$=/fraction_of_time_spent_in_various_temperature_bands]')[0].attrs.get('src'))

			if url:
				city_list[i].append("https:"+ url)
			else:
				city_list[i].append("")
				print "Failed to parse image url: " + city[0]
		else:
			print "Failed to access city url: " + city[0] 
			city_list[i].append("")

{% endhighlight %}


Next, I use the requests library to download the images at each of the urls I scraped, and store them in the `images` directory:

{% highlight python %}

def get_images(city_list):
	'''Retrieves images using links from city_list'''

	base_url = "https://weatherspark.com"
	path = os.getcwd() + '/images'

	for city in city_list:
		r = requests.get(city[2],stream=True)
		filepath = path + '/' + city[0].replace(" ","_") + ".png"

		time.sleep(0.1) # Give that server a break, man

		if r.status_code == 200:
		    with open(filepath, 'wb') as f:
		        r.raw.decode_content = True
		        shutil.copyfileobj(r.raw, f) 
		        print "Downloaded image for "+ city[0]
		else:
			print "Failed to get" + city[0] + r.status_code 

	#Store intermediate cities list in store.txt  
	with open('store.txt', 'wb') as f:
		json.dump(city_list,f)

{% endhighlight %}

Note that the code stores an intermediate list of cities and image urls at this point in `store.txt`.  If you rerun the code with `store.txt` in the top directory, it skips the first two scraping steps and goes right to the processing steps that follow.  

## Processing the Images

After downloading the images, it’s time to process them.  This is where the Python imaging library [Pillow](https://python-pillow.org/) comes in [1].  Pillow is a regularly updated fork of an earlier imaging library called PIL.  Pillow has a number of great functions for processing and filtering images, including conversions, cropping and resizing.  In this case, I use the `getcolors()` method, which returns a list of tuples containing pixel counts grouped by RGB values (e.g. `[((140, 218, 92), 1826), ((76, 144, 80), 3384))]` ).  Here’s the image processing function:

{% highlight python %}

def process_images(city_list):
	'''Iterates through /images and counts, scores pixels'''
	path = os.getcwd() + '/images'

	for image in os.listdir(path):
		if image.endswith(".png"):
			fullpath = path + "/" + image

			im_rgb = Image.open(fullpath).convert("RGB") #Convert from RGBA
			width, height = im_rgb.size
			pixels = width*height

			colors = im_rgb.getcolors(pixels)  
			result = process_colors(colors)

			for i in range(len(city_list)):
				if city_list[i][0] == image.split(".")[0].replace("_"," "):
					city_list[i].append(result)
{% endhighlight %}

One problem with this approach is that pixel RGB values can vary slightly, meaning you could end up with with two separate counts that should really be combined.  For example, `((140, 218, 92), 1826), ((140, 217, 89), 4660)` both code for a very similar light green color, with the blue value only varying by three (92 vs. 89).  

To account for this, I compare the RGB values from each tuple with the correct temperature colors I selected with the [Colorpick Eyedropper](https://chrome.google.com/webstore/detail/colorpick-eyedropper/ohcpnigalekghcmgcdcenkpelffpdolg?hl=en) in advance.  If the all of the RGB values are within 10 units of the predefined colors, the counts are added to that color count.  This is the crucial part of the grouping function: `max(abs(j[0]-tup[0]), abs(j[1]-tup[1]), abs(j[2]-tup[2])) < 10:`.  This is called the Infinity-norm technique, but there are a number of other methods for grouping similar colors together -- see this [stackoverflow discussion](http://stackoverflow.com/questions/4171397/finding-nearest-rgb-colour/4171566) for more details.    

{% highlight python %}

temp_colors = {
    (186,145,234):"Frigid", (106,178,198):"Freezing", (75,143,78):"Cold",
    (138,217,89):"Cool", (250,201,61):"Comfortable", (207,96,66):"Warm",
    (190,79,76):"Hot", (158,72,64):"Sweltering"
    }   

def process_colors(color_list):
	'''Takes a list of pixel count, RGBA values from Pillow, returns summed counts for temp colors'''

	#Reduce size of colors list to those with count > 100
	reduced_colors = filter(lambda tup: tup[0] > 100, color_list) 
	out = {}

	for i in reduced_colors:
		for j in temp_colors.keys():
			tup = i[1]
			#Infinity-norm distance technique between colors
			if max(abs(j[0]-tup[0]), abs(j[1]-tup[1]), abs(j[2]-tup[2])) < 10:  
				if not out.has_key(temp_colors[j]):
					out[temp_colors[j]] = 0

				out[temp_colors[j]] += i[0]

	total_pixels = reduce(lambda x,y: x + y[1], out.items(), 0)

	#Discounts for different temperatures
	discounts = {'Cool':0.70, 'Comfortable':1.0, 'Warm':0.80, "Sweltering":-1.0,
	"Frigid":-1.0, "Freezing":-0.5, "Cold":0.2, "Hot":-0.2}

	score = 0.0 
	for i in out.keys():
		pct = float(out[i])/total_pixels
		out[i] = [out[i], pct]  
		score += pct*discounts[i]
	out['score'] = score   

	return out
  
{% endhighlight %}

The result of the above function is a dictionary like this one, with temperature bands as keys, and pixel counts and percentages as values:

{% highlight python %}
{'Freezing': [11328, 0.12349824477247455], 
'Comfortable': [14540, 0.15851557900704272],
'Hot': [5676, 0.06187994679807252],
'Warm': [13098, 0.1427948455181737],
'Sweltering': [457, 0.004982229684059045],
'Frigid': [1659, 0.0180864749362231],
'Cold': [23692, 0.2582909971000589],
'Cool': [21276, 0.2319516821838955],
'score': 46.655593249}
{% endhighlight %}



## Scoring the Cities

The final part of the above function scores the location based on the fraction of the time spent in different temperature bands.  The scoring is somewhat subjective, although I did find an [interesting survey](http://www.tandfonline.com/doi/abs/10.1080/1479053X.2010.502386) showing that people generally find city temperatures below 62F too cold, 68-78F ideal, and anything above 86F too hot.  I gave Comfortable a weight of 1.0, while Cool and Warm get weights of 0.70 and 0.80 respectively.  I penalize time spent in bad temperature bands, with Sweltering and Frigid both getting weights of -1.0.  The rest of the weights are in the `discounts` dictionary above. 

The final ranking of cities is below.  Honolulu comes out on top, with 92 percent of the time spent in either Comfortable or Warm zones. The top of the rankings are filled out by cities in the West, Southwest and South.  Milwaukee (my hometown), Minneapolis and Anchorage rank the lowest. 

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/Honolulu.png"><img src="{{ site.baseurl }}/images/Honolulu.png"></a>
	<figcaption>The temperature bands for Honolulu, the highest ranking location.</figcaption>
</figure>

Of course, there are factors other than temperature like cloud cover, humidity, and precipitation that can make or break a climate.  I’d imagine many of southern cities like Houston, New Orleans, or Jacksonville would fall in the rankings if the temperatures were [corrected for humidity](https://en.wikipedia.org/wiki/Heat_index).  But I might have to delve into the actual data to come up with a more comprehensive ranking, and the whole point of this post was to avoid doing so by counting pixels.   

## Conclusion

So it is possible to build a passable dataset by counting the pixels of some images!  This approach would work for “integrating” other similar plots as long as the axes are uniform between images, and the total area of the plot corresponds with something meaningful.  Cool beans.

City|frigid|freeze|cold|cool|comfy|warm|hot|swelt.|score
| ----- | ------------- | ------------- | ------------- | ----- | ------------- | ------------- | ------------- | ------------- |
Honolulu|0.0(%)|0.0|0.0|1.9|31.4|61.2|5.6|0.0|80.5
San Diego|0.0|0.0|3.1|58.9|33.3|4.7|0.0|0.0|78.9
Los Angeles|0.0|0.0|5.4|58.5|26.1|8.7|1.2|0.0|74.9
Long Beach|0.0|0.0|6.8|55.8|27.7|8.5|1.2|0.0|74.7
Miami|0.0|0.0|0.7|8.0|25.0|57.1|9.3|0.0|74.5
Jacksonville|0.0|1.0|11.5|26.6|26.5|27.6|6.9|0.0|67.6
New Orleans|0.0|0.4|10.9|24.8|22.7|33.3|7.8|0.0|67.2
San Jose|0.0|0.0|15.7|60.7|15.1|7.1|1.4|0.0|66.1
Oakland|0.0|0.0|16.3|73.5|8.9|1.3|0.0|0.0|64.6
San Francisco|0.0|0.0|18.4|72.6|7.9|1.2|0.0|0.0|63.3
Houston|0.0|1.1|11.4|24.0|23.6|27.1|12.8|0.0|61.3
San Antonio|0.0|1.1|13.3|22.8|21.4|29.6|11.8|0.0|60.8
Atlanta|0.0|3.5|22.1|27.5|23.7|18.8|4.4|0.0|59.8
Austin|0.0|2.0|15.4|21.5|23.6|24.5|12.6|0.4|57.4
Virginia Beach|0.0|4.3|26.5|27.6|21.0|17.7|2.9|0.0|57.0
Charlotte|0.0|4.5|24.8|27.6|22.8|16.2|4.1|0.0|56.9
Sacramento|0.0|0.6|24.8|46.1|12.8|9.7|5.7|0.3|56.1
Arlington|0.0|2.2|17.7|24.4|20.2|22.7|12.1|0.6|54.8
Raleigh|0.0|5.8|25.9|26.4|22.3|15.3|4.2|0.0|54.5
Memphis|0.0|4.4|22.6|24.5|18.4|22.1|8.0|0.0|53.9
Dallas|0.0|2.4|17.5|24.2|18.0|23.4|13.9|0.6|52.5
Fort Worth|0.0|2.9|19.0|23.8|18.3|22.5|12.8|0.7|52.0
Nashville|0.4|6.8|25.3|25.1|20.5|17.2|4.7|0.0|52.0
El Paso|0.0|3.0|20.3|26.5|17.7|19.8|12.1|0.6|51.6
Tucson|0.0|0.3|16.1|27.4|16.5|21.4|15.8|2.4|50.3
Washington|0.1|6.9|30.4|24.7|17.6|16.5|3.7|0.0|49.9
Baltimore|0.0|7.0|29.7|23.9|17.2|17.6|4.6|0.0|49.5
Portland|0.0|2.5|42.3|41.7|8.7|3.7|1.0|0.0|47.9
Louisville|1.0|9.5|27.1|24.0|18.3|16.3|3.9|0.0|47.0
Tulsa|0.7|7.2|24.8|23.1|16.7|18.8|8.4|0.4|46.5
Seattle|0.0|2.0|47.3|42.2|5.7|2.5|0.2|0.0|45.7
Albuquerque|0.1|8.8|31.1|25.9|16.3|12.8|5.0|0.0|45.4
Philadelphia|0.5|10.9|30.9|24.7|17.3|12.9|2.8|0.0|44.5
New York|0.8|11.5|34.2|28.7|16.8|7.2|0.8|0.0|42.7
Las Vegas|0.0|0.4|19.6|27.5|12.7|16.8|19.2|3.8|41.5
Oklahoma City|0.6|9.6|25.0|22.7|14.3|17.0|9.2|1.6|40.0
Columbus|1.9|14.3|28.5|24.6|17.3|11.1|2.2|0.0|39.7
Kansas City|2.8|13.6|25.8|23.8|16.3|14.1|3.6|0.0|39.1
Wichita|1.8|12.3|25.8|23.2|15.9|14.3|6.2|0.5|39.0
Indianapolis|2.4|14.8|26.9|23.7|17.2|12.5|2.5|0.0|38.9
Phoenix|0.0|0.0|7.9|27.4|14.4|18.6|24.5|7.1|38.0
Boston|1.3|14.0|34.1|27.3|15.3|6.7|1.4|0.0|38.0
Detroit|2.3|17.6|29.9|22.7|15.4|10.2|1.9|0.0|34.0
Chicago|3.8|17.8|28.7|23.0|14.7|10.0|2.0|0.0|31.5
Omaha|5.5|17.7|24.9|22.1|16.0|11.0|2.8|0.0|30.4
Colorado Springs|2.6|19.3|30.9|29.6|9.4|6.5|1.7|0.0|28.9
Denver|2.5|18.9|31.3|26.3|11.0|6.7|3.3|0.0|28.4
Milwaukee|4.2|19.6|31.0|23.4|14.3|6.5|1.0|0.0|27.8
Minneapolis|9.4|21.0|23.5|21.8|14.4|8.3|1.7|0.0|20.8
Anchorage|9.6|30.0|31.2|27.5|1.7|0.0|0.0|0.0|2.7


### Notes

[1] Installing Pillow can be kind of hard.  There are non-Python dependencies like `libtiff`, `libjpeg`, `webp`, and `little-cms2`.  The [documentation](http://pillow.readthedocs.io/en/3.2.x/installation.html) recommends using homebrew to install these dependencies: `$ brew install libtiff libjpeg webp little-cms2`, then `$ pip install Pillow`.  I use the [Conda](http://conda.pydata.org/) package manager, which is capable of installing non-Python dependencies.  I ran `$ conda install -c anaconda pillow=3.2.0` [[Info here](https://anaconda.org/anaconda/pillow)], which installed Pillow along with the other requirements just fine.  