---
layout: post
title: "Creating a Climate Change Visualization using D3.js"
excerpt: "I re-create the polar climate change visualization that went viral using d3.js."
#modified: 2016-02-22
tags: [visualization, d3.js, D3.js, Plots, html, css, javascript]
comments: true
share: false

---

<style>

svg {
    font-size: 10px;
    font-family: 'Open Sans', sans-serif;
    font-weight: 400;
    fill: #8C8C8C;
    text-align: center;
    background: #191919; /*#fcfcfa; #a9a9a9  #090909*/
    border: 2px solid;
    border-radius: 35px;
}

.title {
    font-size: 20px;  /*28px*/
    fill: #C4C4C4; /*#4F4F4F;*/
    font-weight: 300;
    text-anchor: start;
}

.subtitle {
    font-size: 14px;
    fill: #AAAAAA;
    font-weight: 300;
    text-anchor: start;
}

.credit {
    font-size: 12px;
    fill: #AAAAAA;
    font-weight: 300;
    text-anchor: start;
}

.axis path,
.axis tick,
.axis line {
    fill: none;
    stroke: none;
    /*shape-rendering: crispEdges;*/
    shape-rendering: geometricPrecision;
    /*shape-rendering: auto;*/
}

.axis text {
    font-size: 12px;
    fill: #AAAAAA;
    font-weight: 400;
}

.legendTitle {
    font-size: 14px;
    fill: #AAAAAA;  /*#4F4F4F;*/
    font-weight: 300;
}

.january {
    font-size: 14px;
    text-anchor: start;
    font-weight: 300;
    fill: #AAAAAA;
}

.yearText {
    font-size: 18px;
    text-anchor: start;
    font-weight: 300;
    fill: #AAAAAA;
}

.yearLine {
    stroke: #AAAAAA;
}

.axisText {
    fill: #C4C4C4;
    font-size: 11px;
    font-weight: 300;
    text-anchor: middle;
}

.axisCircles {
    fill: none;
    stroke: #E8E8E8;
    stroke-width: 1.25px;  /* 1px */
    /*shape-rendering: geometricPrecision;*/
    /*shape-rendering: crispEdges;*/
    shape-rendering: auto;
}
.line {
    fill: none;
    /*stroke: red;*/  /*lightgreen;*/
    stroke-width: 2.3px;  /*1.5px; 1.25px 2.5px 2.75*/
    /*shape-rendering: crispEdges;*/
    shape-rendering: geometricPrecision;
}
.path {
    /*stroke: steelblue;*/
    fill: none;
    stroke-width: 3px;
}

.play {
    font: 500 35px sans-serif;  /* 40px */
    fill: #e5e5e5; 
    cursor: pointer;
}
.play:hover {
    fill: #ccc;
}

</style>

<!-- D3.js https-->
<script src="//cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js" charset="utf-8"></script>

<!-- Google Font http-->
<link href='//fonts.googleapis.com/css?family=Open+Sans:300,400' rel='stylesheet' type='text/css'>

[Ed Hawkins](http://www.met.reading.ac.uk/~ed/home/index.php) from the University of Reading created a pretty neat [climate change visualization](http://www.climate-lab-book.ac.uk/spirals/) that went viral a few months ago. It was seen by millions of people, and was eventually feautured in the opening ceremony of the olympics. 

I think the visualization was so effective because it shows a clear, undeniable trend in a format that is pretty simple to interpret.  The color palette is also pretty effective, with the orange and red communicating "danger" as the temperature seems to spiral out of control.  

The original was created in MATLAB, and distributed as a GIF, with a new image overlaid for each year.  I thought it would be interesting to re-create this visualization using [d3.js](https://d3js.org/), which is a JavaScript data visualization library.  Using d3.js allows you to build a visualization that loads faster, and is more interactive and customizable than a GIF.  Try it out by clicking the play button below:


<div id="weatherRadial"></div>

<br/>

The value for each month is calculated as the difference from the global mean for the period 1850 to 2016.  This graphic makes it pretty clear that temperatures are universally and progressively increasing over that time period.  

Here are a few notable features of the data they point out in their [blog post](http://www.climate-lab-book.ac.uk/2016/spiralling-global-temperatures/) on the subject:

* 1877-78: strong El Nino event warms global temperatures
* 1880s-1910: small cooling, partially due to volcanic eruptions
* 1910-1940s: warming, partially due to recovery from volcanic eruptions, small increase in solar output and natural variability
* 1950s-1970s: fairly flat temperatures as cooling sulphate aerosols mask the greenhouse gas warming
* 1980-now: strong warming, with temperatures pushed higher in 1998 and 2016 due to strong El Nino events

The rest of this post walks through how I built the visualization, focusing on the tricky parts like plotting a radial path, adding the gradient, and animating the path using a tween function.  I started with a [Nadieh Bremer's example code](http://bl.ocks.org/nbremer/a43dbd5690ccd5ac4c6cc392415140e7) as a base, and went from there.  


## Getting the Data

All the data for this graphic are available [here](http://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/download.html).  I import and parse the TSV from the Hadley Center directly and use various D3 functions to convert the numerical values and dates to pixel positions on the SVG.  

## Adding the Path

One confusing thing about building plots in d3 is that what many would consider a line is actually called a path.  More specifically, a path is a series of lines connecting a set of points.  So how do build a path?  

First, you need to create functions that interpret the input data you have into pixel values. A polar plot requires a radian value to communicate the level of rotation around the center, and a second value to communicate the distance from the center.  These two functions accomplish this task:

{% highlight javascript %}

var distScale = d3.scale.linear()
    .range([innerRadius, outerRadius])
    .domain([domLow, domHigh]);
    
var radian = d3.scale.linear()
    .range([0, Math.PI*2*(climateData.length/12) ])  
    .domain(d3.extent(climateData, function(d) { return d.date; }));

{% endhighlight %}

The `distScale` function takes values that range from the lowest to the highest input values, and converts them to radial distances that will fit between the inner and outer radius that is set elsewhere in the code. 

The radian function does something similar, but instead of returning a pixel value, it returns a value between `0` and `Math.PI*2*(climateData.length/12)`, with one year/one full rotation around the circle being equal to `Math.PI*2 radians`.  So the radian function converts a date between 1850 and 2016 to a radian value, which is then used below in the line function.  

Next, we're ready to apply the two scaling functions from above to build the line function:

{% highlight javascript %}

var line = d3.svg.line.radial()
    .angle(function(d) { return radian(d.date); })  
    .radius(function(d) { return distScale(d.mean_temp); });

{% endhighlight %}

Rather than taking `x` and `y` functions, the radial line function takes the angle and radius functions that we created above.

Finally, we create the path using the line function, which is applied to every date and mean temperature in the dataset to produce the final path.  Note that in the code, this is wrapped in an `onClick` function so it isn't drawn immediately upon loading.  

{% highlight javascript %}

var path = barWrapper.append("path")
    .attr("d", line(climateData))
    .attr("class", "line")
    .attr("x", -0.75)
    .style("stroke", "url(#radial-gradient)")

{% endhighlight %}


## Animating the Path

The work with the path isn't quite done.  If we don't apply a transition to it, it will show up immediately.  Below is the transition that I apply so it appears to circle the center until the full path is drawn.  You can find a more in-depth explanation of how this transition works [here](http://jaketrent.com/post/animating-d3-line/).  

{% highlight javascript %}

var totalLength = path.node().getTotalLength();

path.attr("stroke-dasharray", totalLength + " " + totalLength)
    .attr("stroke-dashoffset", totalLength)
    .transition()
    //Works, but kind of a hack:
    .tween("customTween", function() {
        return function(t) {
            d3.select("text.yearText").text(years[Math.floor(t*years.length-1)])
                .transition()
                .duration(t/1.5);
        };
    })
    .duration(duration)  
    .ease("linear")
    .attr("stroke-dashoffset", 0);

{% endhighlight %}

Note that I also apply a `tween` function to the transition.  This oddly named function splits the transition up evenly into time increments between 0 and 1.  The function is applied at each time increment, passing the new time value in for `t`.  I use this function for it's side effect, and change the year text in the center of the plot using it.  This probably isn't a best practice, but it works for me in this situation.   


## Adding the Gradient

The final step is to add the gradient to the line, so the color changes from blue to red as the temperature anomaly increases.  Creating a gradient along a path can be [kind of a pain](http://bl.ocks.org/mbostock/4163057).  But we can take advantage of the fact that this is a polar plot and apply a radial gradient to the underlying SVG, and then have the line pick up that gradient. 

Here's the code that does that:

{% highlight javascript %}

//Base the color scale on average temperature extremes
var colorScale = d3.scale.linear()
    .domain([domLow, (domLow+domHigh)/2, domHigh])
    .range(["#2c7bb6", "#ffff8c", "#d7191c"])
    .interpolate(d3.interpolateHcl);

//Calculate the variables for the temp gradient
var numStops = 10;
tempRange = distScale.domain();
tempRange[2] = tempRange[1] - tempRange[0];
tempPoint = [];
for(var i = 0; i < numStops; i++) {
    tempPoint.push(i * tempRange[2]/(numStops-1) + tempRange[0]);
}

//Create the radial gradient
var radialGradient = svg.append("defs")
    .append("radialGradient")
    .attr("id", "radial-gradient")
    .selectAll("stop") 
    .data(d3.range(numStops))               
    .enter().append("stop")
    .attr("offset", function(d,i) { return distScale(tempPoint[i])/ outerRadius; })      
    .attr("stop-color", function(d,i) { return colorScale( tempPoint[i] ); });

{% endhighlight %}

The code essentially divides the distance between the inner radius and outer radius into ten evenly spaces stop points that are then applied to the radial gradient.  The color comes from a color function, which is set to vary from blue to red across the radial values.  

Then we just apply the `url(#radial-gradient)` style to the path when we create it:

{% highlight javascript %}

//Create path using line function
var path = barWrapper.append("path")
    .attr("d", line(climateData))
    .attr("class", "line")
    .attr("x", -0.75)
    .style("stroke", "url(#radial-gradient)");
    
{% endhighlight %}

## Conclusion

Hopefully this post is somewhat clear, and helps someone out if they're trying to do something similar.  I think this post highlights both the expressive power of D3, and that it can be confusing at times.

Oh, and also, we need to do something about carbon emissions!



<script> 

///////////////////////////////////////////////////////////////////////////
//////////////////// Set up and initiate svg containers ///////////////////
/////////////////////////////////////////////////////////////////////////// 

var margin = {
    top: 70,
    right: 20,
    bottom: 120,
    left: 20
};
// var width = window.innerWidth - margin.left - margin.right - 20;
// var height = window.innerHeight - margin.top - margin.bottom - 20;
var width = 700 - margin.left - margin.right - 20;
var height = 800 - margin.top - margin.bottom - 20;

var domLow = -1.5,  //-15, low end of data
    domHigh = 1.25,  //30, high end of data
    axisTicks = [-1, 0, 1],   //[-20,-10,0,10,20,30];  [-2,-1,0,1,2,3];  [-1.5,-0.5,0.5,1.5];
    duration = 25000; //100000, 50000


//SVG container
var svg = d3.select("#weatherRadial")
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + (margin.left + width/2) + "," + (margin.top + height/2) + ")");

//Parses a string into a date
var parseDate = d3.time.format("%Y-%m-%d").parse;


///////////////////////////////////////////////////////////////////////////
//////////////////////////// Create scales ////////////////////////////////
///////////////////////////////////////////////////////////////////////////


//Loads data, everything below is within callback: 
d3.text("{{ site.baseurl }}/rawdata/HadCRUT.4.5.0.0.monthly_ns_avg.tsv", function(text) {

var years = [];

var climateData = d3.csv.parseRows(text, function(d) {
    var temp = d[0].split('   ').slice(0,2);
    //console.log(temp[0].split('/'))
    years.push(temp[0].split('/')[0]);
    return {date: parseDate(temp[0].replace('/', '-') + '-1'), mean_temp: +temp[1]}  //'-') + '-01'
});
//var data = d3.csv.parseRows(text);
//console.log(climateData);


//Set the minimum inner radius and max outer radius of the chart
var outerRadius = Math.min(width, height, 500)/2,
    innerRadius = outerRadius * 0.1;  //Sets the ratio.  Smaller magnifies differences. 0.1 good, 0.15

//Base the color scale on average temperature extremes
var colorScale = d3.scale.linear()
    .domain([domLow, (domLow+domHigh)/2, domHigh])
    .range(["#2c7bb6", "#ffff8c", "#d7191c"])
    .interpolate(d3.interpolateHcl);

//Scale for the heights of the bar, not starting at zero to give the bars an initial offset outward
var distScale = d3.scale.linear()
    .range([innerRadius, outerRadius])
    .domain([domLow, domHigh]); 

//Scale to turn the date into an angle of 360 degrees in total
//With the first datapoint (Jan 1st) on top
// var angle = d3.scale.linear()
//     .range([-180, 180])
//     .domain(d3.extent(climateData, function(d) { return d.date; }));

//Function to convert date into radians for path function
//The radial scale in this case starts with 0 at 90 degrees
//http://stackoverflow.com/questions/14404345/polar-plots-using-d3-js
var radian = d3.scale.linear()
    .range([0, Math.PI*2*(climateData.length/12) ])  
    .domain(d3.extent(climateData, function(d) { return d.date; }));


///////////////////////////////////////////////////////////////////////////
//////////////////////////// Create Titles ////////////////////////////////
///////////////////////////////////////////////////////////////////////////

var textWrapper = svg.append("g").attr("class", "textWrapper")
    .attr("transform", "translate(" + Math.max(-width/2, -outerRadius - 170) + "," + 0 + ")");

//Append title to the top
textWrapper.append("text")
    .attr("class", "title")
    .attr("x", 25)  //0
    .attr("y", -outerRadius - 50)  //-40
    .text("Global Temperature Anomaly");

//Subtitle:
textWrapper.append("text")
    .attr("class", "subtitle")
    .attr("x", 25)
    .attr("y", -outerRadius - 30)
    .text('January 1850 - August 2016');

//Append play button
var play = textWrapper.append("text")
    .attr("class", "play")
    .attr("x", 25)
    .attr("y", -outerRadius + 20)
    .text("\u25B7")  //unicode triangle: U+25B2  \u25b2



///////////////////////////////////////////////////////////////////////////
///////////////////////////// Create Axes /////////////////////////////////
///////////////////////////////////////////////////////////////////////////

//Wrapper for the bars and to position it downward
var barWrapper = svg.append("g")
    .attr("transform", "translate(" + 0 + "," + 30 + ")");
    
//Draw gridlines below the bars
var axes = barWrapper.selectAll(".gridCircles")
    .data(axisTicks)
    .enter().append("g");
//Draw the circles
axes.append("circle")
    .attr("class", "axisCircles")
    .attr("r", function(d) { return distScale(d); });
//Draw the axis labels
axes.append("text")
    .attr("class", "axisText")
    .attr("y", function(d) { return distScale(d) - 8; })
    .attr("dy", "0.3em")
    .text(function(d) { return d + "°C"});

//Add January for reference
barWrapper.append("text")
    .attr("class", "january")
    .attr("x", 7)
    .attr("y", -outerRadius * 1.1)
    .attr("dy", "0.9em")
    .text("January");
//Add a line to split the year
barWrapper.append("line")
    .attr("class", "yearLine")
    .attr("x1", 0)
    .attr("y1", -innerRadius * 1.8)  //.65
    .attr("x2", 0)
    .attr("y2", -outerRadius * 1.1);

//Add year in center
barWrapper.append("text")
    .attr("class", "yearText")
    .attr("x", -22)
    .attr("y", 0)
    //.attr("dy", "0.9em")
    .text("1850");

///////////////////////////////////////////////////////////////////////////
//////////////// Create radial gradient for the line //////////////////////
///////////////////////////////////////////////////////////////////////////


//Extra scale since the color scale is interpolated
// var distScale = d3.scale.linear()
//     .domain([domLow, domHigh])
//     .range([innerRadius, outerRadius]);

//Calculate the variables for the temp gradient
var numStops = 10;
tempRange = distScale.domain();
tempRange[2] = tempRange[1] - tempRange[0];
tempPoint = [];
for(var i = 0; i < numStops; i++) {
    tempPoint.push(i * tempRange[2]/(numStops-1) + tempRange[0]);
}

//Create the radial gradient
var radialGradient = svg.append("defs")
    .append("radialGradient")
    .attr("id", "radial-gradient")
    .selectAll("stop") 
    .data(d3.range(numStops))               
    .enter().append("stop")
    .attr("offset", function(d,i) { return distScale(tempPoint[i])/ outerRadius; })      
    .attr("stop-color", function(d,i) { return colorScale( tempPoint[i] ); });



///////////////////////////////////////////////////////////////////////////
////////////////////////////// Draw lines /////////////////////////////////
///////////////////////////////////////////////////////////////////////////


//Radial line, takes radians as argument
//http://stackoverflow.com/questions/18487780/how-to-make-a-radial-line-segment-using-d3-js
//http://stackoverflow.com/questions/14404345/polar-plots-using-d3-js
var line = d3.svg.line.radial()
    .angle(function(d) { return radian(d.date); })  
    .radius(function(d) { return distScale(d.mean_temp); });

//Append path drawing function to play button
play.on("click", function(){

    if (d3.select("path.line")) {
        d3.select("path.line").remove();
    }

    //Create path using line function
    var path = barWrapper.append("path")
        .attr("d", line(climateData))
        .attr("class", "line")
        .attr("x", -0.75)
        .style("stroke", "url(#radial-gradient)")
        //.datum(climateData);  attaches all data

    var totalLength = path.node().getTotalLength();

    path.attr("stroke-dasharray", totalLength + " " + totalLength)
        .attr("stroke-dashoffset", totalLength)
        .transition()
        //Works, but kind of a hack:
        .tween("customTween", function() {
            return function(t) {
                d3.select("text.yearText").text(years[Math.floor(t*years.length-1)])
                    .transition()
                    .duration(t/1.5);
            };
        })
        .duration(duration)  
        .ease("linear")
        .attr("stroke-dashoffset", 0);
});

 
///////////////////////////////////////////////////////////////////////////
//////////////// Create the gradient for the legend ///////////////////////
///////////////////////////////////////////////////////////////////////////

//Extra scale since the color scale is interpolated
var tempScale = d3.scale.linear()
    .domain([domLow, domHigh])
    .range([0, width]);

//Calculate the variables for the temp gradient
var numStops = 10;
tempRange = tempScale.domain();
tempRange[2] = tempRange[1] - tempRange[0];
tempPoint = [];
for(var i = 0; i < numStops; i++) {
    tempPoint.push(i * tempRange[2]/(numStops-1) + tempRange[0]);
}//for i

//Create the gradient
svg.append("defs")
    .append("linearGradient")
    .attr("id", "legend-weather")
    .attr("x1", "0%").attr("y1", "0%")
    .attr("x2", "100%").attr("y2", "0%")
    .selectAll("stop") 
    .data(d3.range(numStops))                
    .enter().append("stop") 
    .attr("offset", function(d,i) { return tempScale( tempPoint[i] )/width; })   
    .attr("stop-color", function(d,i) { return colorScale( tempPoint[i] ); });

///////////////////////////////////////////////////////////////////////////
////////////////////////// Draw the legend ////////////////////////////////
///////////////////////////////////////////////////////////////////////////

var legendWidth = Math.min(outerRadius*2, 400);

//Color Legend container
var legendsvg = svg.append("g")
    .attr("class", "legendWrapper")
    .attr("transform", "translate(" + 0 + "," + (outerRadius + 70) + ")");

//Draw the Rectangle
legendsvg.append("rect")
    .attr("class", "legendRect")
    .attr("x", -legendWidth/2)
    .attr("y", 0)
    .attr("rx", 8/2)
    .attr("width", legendWidth)
    .attr("height", 8)
    .style("fill", "url(#legend-weather)");
    
//Append title
legendsvg.append("text")
    .attr("class", "legendTitle")
    .attr("x", 0)
    .attr("y", -10)
    .style("text-anchor", "middle")
    .text("Temperature Anomaly");

//Set scale for x-axis
var xScale = d3.scale.linear()
    .range([-legendWidth/2, legendWidth/2])
    .domain([domLow, domHigh] );

//Define x-axis
var xAxis = d3.svg.axis()
    .orient("bottom")
    .ticks(5)
    .tickFormat(function(d) { return d + "°C"; })
    .scale(xScale);

//Set up X axis
legendsvg.append("g")
    .attr("class", "axis")
    .attr("transform", "translate(0," + (10) + ")")
    .call(xAxis);

}); //End data callback

</script>