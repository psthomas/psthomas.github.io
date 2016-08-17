---
layout: post
title: Getting Data From the IGM Experts Panel
excerpt: "I scrape a dataset of all the IGM Panel responses from their website using Python"
#modified: 2016-02-22
tags: [projects, IGM Forum, scraping, data analysis, Python, Pandas]
comments: true
share: false

---

There are a number of policy areas where decision making is based on the collective judgement of experts.  Given the importance, it makes sense to study the collective decision making process to ensure it leads to the best possible results.  One interesting expert opinion aggregator in the area of economics is the Chicago Booth [IGM Experts Panel](http://www.igmchicago.org/igm-economic-experts-panel), which I collect data from in this post.  Although the panel might not be [representative of the entire profession](http://www.bloomberg.com/view/articles/2016-03-30/economists-are-warming-to-government-intervention), it’s still a useful sanity check for outsiders without in-depth knowledge of economics.    

<figure>
	<a href="{{ site.baseurl }}/images/igm_example.png"><img src="{{ site.baseurl }}/images/igm_example.png"></a>
	<figcaption>An example IGM Panel survey on the minimum wage.  Source: <a href="http://www.igmchicago.org/igm-economic-experts-panel/poll-results?SurveyID=SV_e9vyBJWi3mNpwzj" title="Minimum Wage Sample">IGM Forum</a>.</figcaption>
</figure> 

The voting process for the panel works like this: the members agree on the wording of a statement, then provide a vote (from `strongly disagree` to `strongly agree`), and a confidence level for their vote (`1-10`).  The end result is aggregated and published on their website.  

There have been a few papers based on this data [[1](http://faculty.chicagobooth.edu/luigi.zingales/papers/research/economic-experts-vs-average-americans.pdf), [2](http://econweb.ucsd.edu/~gdahl/papers/views-among-economists.pdf)], but the most recent one was published in 2012.  I thought it would be interesting to look at the more recent data which isn’t published in a usable format anywhere, so I used Python, Pandas and BeautifulSoup to scrape the data from their website.  The final Python script is available [here](https://gist.github.com/psthomas/b7af76997fd939c7dd325f5ca3348815).  

## Finding a Pattern in the URLs

The URL for each vote is hard to predict, as each one has a survey id that’s a somewhat random string like this: `SV_429IHJQVpBV1cnb`.  Luckily, the URLs for the economist bio pages do follow an easy pattern, with the `id` value ranging from `1 to 51`.  So I wrote a for loop to step through each of their bio pages, getting the voting data from each one:

{% highlight python %}

def cycle_pages(base_url, id_list, out_name):

	columns = ['name', 'institution', 'url', 'homepage', 'qtitle','subquestion','qtext',
			   'vote', 'confidence', 'comments', 'median_vote', 'median_conf']

	master_df = pd.DataFrame(columns=columns)

	for i in id_list: #range(1,52)
		url = base_url + str(i)
		
		try:
			row_list = get_data(url)
			temp_df = pd.DataFrame(row_list)
			master_df = pd.concat([master_df, temp_df])
		except Exception as e:
			print 'Exception for url: ' + url + '\n' + str(e)
			print traceback.format_exc()
		else:
			print 'Processed url: ' + url

		time.sleep(0.1) # Give the server a break

	#Output all
	master_df.to_csv(out_name + '.csv', encoding='utf-8', index=False, columns=columns)

# Run Script
id_list = range(1,52)
out_name = 'output_all'
base_url = 'http://www.igmchicago.org/igm-economic-experts-panel/participant-bio-2?id='

cycle_pages(base_url, id_list, out_name)

{% endhighlight %}


So the above code just steps through each bio page, and calls the `get_data` function on each URL.  


## Scraping the Data

Each bio page has the vote history of each user, so I just need to access the URL, then parse the HTML for the content I need.  I use the `requests` module to access each page, then `BeautifulSoup` to parse the HTML.  The structure of the HTML is a little tricky, as the subquestions aren’t nicely nested within the question title tag.  To add to the complexity, there are between one and three subquestions for each title, so the HTML parser needs to adapt based on the circumstances.  Here is an example of the HTML structure for an individual question:

{% highlight html %}

<h2> Question Title </h2>
<h3> Question A: Question Text </h3>
<table> Data </table>
<h3> Question B: Question Text </h3>
<table> Data </table>

{% endhighlight %}

To solve this problem, I use BeautifulSoup’s `.next_sibling` feature along with a `while` loop to step through the question text and voting data until it hits the next `<h2>` question title header:

{% highlight python %}

while current.next_sibling.next_sibling.name == 'h3':

	h3 = current.next_sibling.next_sibling
	table = h3.next_sibling.next_sibling
	qtext = h3.get_text(strip=True).replace('\n', ' ')

	data = table.find_all('td')
	vote = data[0].get_text(strip=True)	
	confidence = int(data[1].get_text(strip=True)) if data[1].get_text(strip=True) else None  
	comments = data[2].get_text(strip=True).replace('\n', ' ')
	median_vote = data[3].get_text(strip=True)
	median_conf = int(data[4].get_text(strip=True)) if data[4].get_text(strip=True) else None


	row_list.append(row)
	current = table

{% endhighlight %}

## The Results

After taking care of a few edge cases where economists were added late and the table was structured differently, the script works!  The final version of the script is posted [here](https://gist.github.com/psthomas/b7af76997fd939c7dd325f5ca3348815).  The final table of all data is available [here](https://dl.dropboxusercontent.com/u/44331453/output_all.csv).  Some of the data in the preceding table is repetitive, so I also split the files up into [questions](https://dl.dropboxusercontent.com/u/44331453/igm_questions.csv) and [responses](https://dl.dropboxusercontent.com/u/44331453/igm_responses.csv) tables, with the combination of columns `qtitle` and `subquestion` as the primary key between the two.  

Here are some basic summary statistics of the data.  First, a summary of the numerical information:

{% highlight python %}

df_all = pd.read_csv('output_all.csv')

# Numerical summary
print df_all.describe()

        confidence  median_conf
count  7024.000000  8402.000000
mean      5.892938     6.098905
std       2.449649     1.154777
min       1.000000     4.000000
25%       4.000000     5.000000
50%       6.000000     6.000000
75%       8.000000     7.000000
max      10.000000     9.000000

{% endhighlight %}

And then a summary of the textual information:

{% highlight python %}

# String summary
print df_all.describe(include = ['O'])

              name institution         url    homepage      qtitle  \
count         8402        8402        8402        8402        8402   
unique          51           7          51          51         134   
top     José Sc...     Chicago  http://...  http://...  Europea...   
freq           199        1466         199         199         162   

       subquestion       qtext   vote    comments median_vote  
count         8402        8402   8402        2921        8402  
unique           3         199      9        2816           5  
top     Question A  Federal...  Agree  -see ba...       Agree  
freq          5686          51   2902          92        3877

{% endhighlight %}

## Future Questions

One thing that I’m interested in is whether confidence declines with the scale of a claim -- are economists less certain when they `strongly agree` or `strongly disagree`?  An initial look at this suggests the opposite (although what we really want to look at is something like "distance from the median vote", not just the vote):  

{% highlight python %}

# Initial grouping
print df_all[df_all['vote'].isin(r_list)].groupby('vote') \
				   .agg({'confidence': 
						{'mean': 'mean', 
						'std': 'std', 
						'count': 'count'}})

                  confidence                
                         std count      mean
vote                                        
Agree               2.044886  2902  5.560992
Disagree            2.006320   992  5.530242
Strongly Agree      1.764728  1347  8.152190
Strongly Disagree   1.886012   314  7.843949
Uncertain           2.405343  1469  4.304969 

{% endhighlight %}

This also might highlight a problem with the survey -- it’s a little weird to say that your are "confidently uncertain" about an issue, even if saying that you are "confident that the literature is uncertain about this issue" is a perfectly reasonable thing to say.   

There are a number of other cool ways to look at this data, so I’ll probably write about it in the future.  Feel free to use it and let me know what you find!