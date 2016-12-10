---
layout: post
title: "An Interactive Visualization for the Wisconsin Election Results"
excerpt: "I build an interactive bubble chart to show trends in the 2000-2016 election results by county."
#modified: 2016-02-22
tags: [visualization, d3.js, Plots, html, css, javascript, politics]
comments: true
share: false

---

<style type="text/css">
	
.axis {
  font: 12px sans-serif;   
}

.axis path,
.axis line {
  fill: none;
  stroke: #aaa; 
  shape-rendering: crispEdges;
}

.axis text {
  fill: #858585;
}

.title {
  font: 500 100px serif; /*180px "Helvetica Neue"*/
  fill: #e5e5e5;
}

.party {
  font: 500 35px serif; /*180px "Helvetica Neue" "PT Sans"*/
  fill: #e5e5e5;
}

.incr {
  font: 500 35px serif;  /* sans-serif"Helvetica Neue"; 55px + - */
  fill: #e5e5e5; 
  cursor: pointer;
}

.incr:hover {
  fill: #ccc;
}

.circle {
	stroke: gray; /* #e5e5e5 */
	cursor: pointer;
}

.circle:hover {
	/*stroke: black;*/
	fill-opacity: 0.8;
}

.tooltip {
  /*border: 1px solid #999;*/
  /*line-height: 1;*/
  font: 16px serif;/*18px serif "Helvetica Neuesans-serif;  "PT Sans"*/
  /*font-weight: bold;*/
  /*padding: 5px;*/ 
  /*background: #fcfcfa;*/ /*rgba(0, 0, 0, 0.8) */ 
  color: #999;   /*#fff #888; #999*/
  /*border-radius: 2px;*/
  max-width: 400px;
}

</style>

I built a few static visualization of Wisconsin results for my [last post](https://pstblog.com/2016/12/08/presidential-election), but it seemed like making an interactive one could help explain trends over time better.  To see the results, click through each of the years using the arrows in the lower left corner.  You can also consider “what-if” scenarios by clicking and dragging the counties.  For example, you can see how the election would have changed if turnout was 8% higher or the Democrat’s margin was 3% larger in Milwaukee County.

This visualization was built with D3.js, and the code is available [here](https://gist.github.com/psthomas/58a003fdfbce2334e00c78e95ccedcf1#file-index-html), and a full page version is available [here](http://bl.ocks.org/psthomas/raw/58a003fdfbce2334e00c78e95ccedcf1/).

<div id="electionvis"></div>

## A Few Notes

* There seems to be a large increase in turnout from 2000-2004.
* Smaller rural counties are more erratic, swinging towards Obama in 2008, then back to Trump in 2016.
* Milwaukee County had a 8% drop in turnout from 2012-2016, probably costing Clinton the state.  
* Strong conservative counties like Waukesha actually shifted towards Democrats in 2016, suggesting a clash between establishment conservatism and Trump’s campaign.

## Assumptions

* I assume increases in turnout are apportioned based on the fraction of each county that voted for each party initially.  
* Changes in margin are zero sum.  Any increase in the Democrat’s vote total comes from Republican voters switching sides, not from third party candidates. 

## Next Steps

I think it would be cool to make this graphic with the results from every county in the US, and allow filtering by state.  I could also include the electoral college count, so people could see how changes in a few large counties could affect the results.  The rest of the data is available at David Leip’s [Election Atlas](http://uselectionatlas.org/) site, but it’s behind a paywall so I won't do this next step for now.  

Aggregating all of this data clearly takes a lot of work, but I’m surprised the government doesn’t do the aggregating and make it publicly available for free.  Something as important as a presidential election should have all the ward-level data available so the public can analyze it in real time to look for anomalies.  Right now, the only option seems to be to get access to the incredibly expensive [AP elections API](https://developer.ap.org/ap-elections-api), or wait a few days and pay for the Election Atlas data at the county level as it becomes available. 


<script src="https://d3js.org/d3.v4.min.js"></script>


<script type="text/javascript">

var margin = {top: 20, right: 20, bottom: 50, left: 30},  
	width = 960 - margin.left - margin.right,
	height = 500 - margin.top - margin.bottom;


//Formatting Functions
var pctFormat = d3.format(".1%")
var thsdFormat = d3.format(",")

//Create SVG
var svg = d3.select("#electionvis").append("svg")
	.attr("width", width + margin.left + margin.right)
	.attr("height", height + margin.top + margin.bottom)
	//.attr("style", "outline: 1.5px solid #e5e5e5;")
	.append("g")
	.attr("transform", "translate(" + margin.left + "," + margin.top + ")");


//Year Title
var title = svg.append("text")
    .attr("class", "title")
    .attr("dy", height-10)  
    .attr("dx", ".35em");  

var demtext = svg.append("text")
    .attr("class", "party")
    .attr("dy", height-50)  
    .attr("dx", 243);  


var reptext = svg.append("text")
    .attr("class", "party")
    .attr("dy", height-14)  
    .attr("dx", 243);  


//Define static scales
var xScale = d3.scaleLinear()
	.domain([-80, 80])   //-100, 100
	.range([0, width]);

var yScale = d3.scaleLinear()
	.domain([0, 100])  //Max margin is 100
	.range([height, 0]);


//Base the color scale on the democratic margin.  
var colorScale = d3.scaleLinear()
	.domain([-80, 0, 80])
	//.domain([d3.min(...), 0, d3.max(data, function(d) {return d.; })]) 
	.range(['#EF3B2C', '#FFFFFF', '#08519C'])
	.interpolate(d3.interpolateRgb);  

//Define x, y axes
var xAxis = d3.axisBottom(xScale);
var yAxis = d3.axisLeft(yScale);

//Append Axes
svg.append("g")
	.attr("class", "axis")
	.attr("transform", "translate(0," + height + ")")
	.call(xAxis)
	.append("text")
	.attr("y", "3em")
	.attr("x", width/2)
	.text("Democratic Margin (%)");

svg.append("g")
	.attr("class", "axis")
	.call(yAxis)
	.attr("transform", "translate(" + (width/2) + ",0)")
	.append("text")
	.attr("transform", "rotate(-90)")
	.attr("y", 6)
	.attr("dy", "-3.75em")  
	.style("text-anchor", "end")
	.text("Turnout (%VAP)");


//Relative offsets for tooltip:
var leftOffset = document.getElementById("electionvis").offsetLeft,
    topOffset = document.getElementById("electionvis").offsetTop;


//Statically place tooltip:
//http://stackoverflow.com/questions/30051141
// var tooltip = d3.select("body")
var tooltip = d3.select("#electionvis")
	.append("div")    
	.style("position", "absolute")
    // .style("position", "inherit")
	.style("visibility", "hidden")
	.style("left", leftOffset + width/2 + margin.left + 8 + "px")
	.style("top", topOffset + height - margin.bottom - 8 + "px")
	.attr("class", "tooltip");


function tooltipOn(d) {
	//Transition might prevent mouseout from registering
	// tooltip.transition()
	// 	.duration(500)
	// 	.style("visibility", "visible");
	tooltip.style("visibility", "visible")
		.html(
		"County: " + d.county + "<br>" +
		"D: " + pctFormat(d.num_dem/d.county_num) +
		" R: " + pctFormat(d.num_rep/d.county_num) + "<br>" +
		"Turnout: " + pctFormat(d.turnout) + "<br>" +
		"Voters: " + thsdFormat(Math.round(d.county_num)) + "<br>" ); 
}


function parseRows(d) {
	return {'county': d.county, 'county_num': +d.county_num, 'turnout': +d.turnout,
		   'num_rep': +d.num_rep, 'num_dem': +d.num_dem, 'year': +d.year, 
		   'vap': +d.county_num/+d.turnout};
}


d3.csv("{{ site.baseurl }}/rawdata/county_results_20002016.csv", parseRows, function(error, data) {

	if (error) {throw error};

	var dataset = d3.nest()
		.key(function(d) { return +d.year; })
		.entries(data);


	var years = [];
	for (var i=0; i<dataset.length; i++) {
		years.push(+dataset[i].key)
	}
	var year = years[0];

	//Create a copy, so it can be edited on drag:
	//var yearData = Object.assign({}, getYearData(dataset, year));
	var yearData = copyObj(getYearData(dataset, year));


	//Data is just array of all objects from csv
	var rScale = d3.scaleLinear()
		.domain([0, d3.max(data, function(d) {return d.county_num; })])
		.range([5, 50]);


	//Append increment buttons
	var incr = svg.append("text")
		.attr("class", "incr")
		.attr("dy", height-43) // 1em
		.attr("dx", 0)  //.5em
		.html("&#9650;")
		.on("click", function() {
			year += 4;
			if (year > years[years.length - 1]) {
				year = years[0]
			}
			//Assign to new object, update circles:
			yearData = copyObj(getYearData(dataset, year));
			update(yearData, year);
		});

	var decr = svg.append("text")
		.attr("class", "incr")
		.attr("dy", height-10)
		.attr("dx", 0)  //".5em"
		.html("&#9660;")
		.on("click", function() {
			year -= 4;
			if (year < years[0]) {
				year = years[years.length - 1];
			} 
			//Assign to new object, update:
			yearData = copyObj(getYearData(dataset, year));
			update(yearData, year);
		});

	//Dragging behavior
	//https://bl.ocks.org/mbostock/6123708
	var drag = d3.drag()
	    .on("drag", dragged)
	    .on("end", ended);


	function dragged(d) {
		//Remove transitions temporarily
		d3.selectAll("circle").transition();

		//Issue when dragged across 0 threshold, county_num = 0

		if (d3.event.y >= height) {
			return;
		}

		//Relocate circle with mouse
		d3.select(this).attr("cx", d.x = d3.event.x).attr("cy", d.y = d3.event.y);
		
		//Avoid case of no shift
		if (d.x === undefined || d.y === undefined) {
			return;
		}


		var newMargin = xScale.invert(d.x)/100,
			newTurnout = yScale.invert(d.y)/100,  //Math.abs()  d.y
			//turnoutChange = yScale.invert(d.dy)/100,
			//vap = d.county_num/d.turnout,    
			oldMargin = (d.num_dem-d.num_rep)/d.county_num,
			marginChange = newMargin-oldMargin, 
			dfrac = d.num_dem/d.county_num,
			rfrac = d.num_rep/d.county_num;

		//Recalculate fractions based on margin change
		//Half goes to each side, zero sum
		dfrac += marginChange/2;   
		rfrac -= marginChange/2;

		//Add increses in turnout to county_num
		//Assume change in turnout affects D&R equally
		d.county_num = newTurnout*d.vap;


		// Recalculate based on margin change first, assumes
		// margin changes are zero sum between parties.
		d.num_dem = dfrac*d.county_num;
		d.num_rep = rfrac*d.county_num;
		d.turnout =  newTurnout;

		//Call the tooltip function each time to update.  
		tooltipOn(d);
		//Update score as well:
		updateScore(yearData);
		//Wait to update circles until ended below
		//update(yearData, d.year);
	}

	function ended(d) {
		//Update circle radius, color at end of drag.  
		update(yearData, d.year);

	}

	function updateScore(yearData) {

		//Could get this data directly from dataframe,
		//but want to calculate so can be updated easily on drag.   
		var sums = [0,0,0];
		for (var i=0; i<yearData.length; i++) {
			sums[0] += yearData[i].num_dem;
			sums[1] += yearData[i].num_rep;
			sums[2] += yearData[i].county_num;
		}

		var dfrac = sums[0]/sums[2],
			rfrac = sums[1]/sums[2];

		//update dfrac rfrac text, update color background
		demtext.text('D ' + pctFormat(dfrac))  
		reptext.text('R ' + pctFormat(rfrac)) 


		//demtext.style('color', 'red')
		if (dfrac > rfrac) {
			demtext.style('fill', '#bbb');
			reptext.style('fill', null);
		} else {
			demtext.style('fill', null);
			reptext.style('fill', '#bbb');
		}

		//Optional, set background color based on winner
		// var backColor = dfrac > rfrac ? colorScale(5) : colorScale(-5);
		// //var backColor = colorScale((dfrac-rfrac)*100);
		// d3.selectAll('svg')
		// 	.style('background-color', backColor);
	}


	function update(yearData, year) {

		//Change D,R scores:
		updateScore(yearData);

		//Update title
		title.text(year);

		//Create any new circles
		var circles = svg.selectAll("circle")
			.data(yearData)
			.enter()
			.append("circle")
			.attr("class", "circle")
			.attr("cx", function(d) {
				return xScale(((d.num_dem-d.num_rep)/d.county_num)*100);
			})
			.attr("cy", function(d) {
				return yScale(d.turnout*100);
			})
			.attr("r", function(d) {
				return rScale(d.county_num);
			})
			.attr("fill",function(d){
				return colorScale(((d.num_dem-d.num_rep)/d.county_num)*100);
			})
			.call(drag)
			.on("mouseover", tooltipOn)
			.on("mouseout", function(d){return tooltip.style("visibility", "hidden");});

		//Update circles
		svg.selectAll("circle").data(yearData)
			.transition()
			.duration(750)
			.attr("class", "circle")
			.attr("cx", function(d) {
				return xScale(((d.num_dem-d.num_rep)/d.county_num)*100);
			})
			.attr("cy", function(d) {
				return yScale(d.turnout*100);
			})
			.attr("r", function(d) {
				return rScale(d.county_num);
			})
			.attr("fill",function(d){
				return colorScale(((d.num_dem-d.num_rep)/d.county_num)*100);
			});

	}

	//Initialize scatterplot
	update(yearData, year);


	// Helper functions: 
	function copyObj(original) {
		return JSON.parse(JSON.stringify(original));
	}

	function getYearData(dataset, year) {
		for (var i=0; i<dataset.length; i++) {
			if (Number(dataset[i].key) === year) {
				return dataset[i].values;
			}
		}
	}




});
</script>


