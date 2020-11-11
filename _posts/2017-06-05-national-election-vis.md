---
layout: post
title: "Visualizing Voter Turnout and Margins by County, 2004 to 2016"
excerpt: "An interactive, draggable visualization showing turnout, party margins and more."
#modified: 2016-02-22
tags: [pandas, python, d3.js, politics, data visualization]
comments: true
share: false
---

In my continuing quest to understand the 2016 election, I decided to build another visualization.  This version shows the turnout and two party margin by county for the 2004, 2008, 2012 and 2016 presidential elections.  I made an [earlier]({{ site.baseurl }}/2016/12/09/wisconsin-election) version of this visualization using Wisconsin data, but I recently pieced together the national data as well. I added a few features in this version:

* It's now possible to search by state or county.  
* The county bubble areas are proportional to the fraction of national votes, fraction of electoral votes, or the Voter Power Index (VPI).    
* Electoral votes and national vote percentages are tallied in the bottom left.  
* Each tooltip now shows both the county level and state level data.  
* Clicking and dragging the counties updates the vote percentages and electoral counts if the vote threshold for the state is crossed.  I find this is a good way to consider "what if" scenarios for the elections.
* A dropdown menu now allows switching between county, state, and different demographic data sources.


All the code and data are available at a GitHub repo [here](https://github.com/psthomas/election-vis).   


<!--https://stackoverflow.com/questions/5867985-->
<div class="outer">
<div class="inner">
<!--src="{{ site.baseurl }}/vis/national-election.html"-->
<iframe id="vis" style="width: 98vw; height: 100vh; border: none; position: relative; right:-50%; scrolling:no;"></iframe>
</div>
</div>

<script src="https://d3js.org/d3.v4.js"></script>
<script> d3.request("https://raw.githubusercontent.com/psthomas/election-vis/master/scatter.html").get(function(a) { document.getElementById("vis").srcdoc = a.response; }); </script>

## A Few Notes

It's pretty interesting to click through the years and see the turnout and margin changes for each county.  Here are a few things that I noticed when building the visualization:

* The drop in turnout happened in 2012; 2016 was largely about a left-right sorting of counties by size (although crucial counties like Milwaukee still saw a drop in turnout).  
* The left-right sorting is especially apparent in Midwestern swing states that gave the election to Trump.  Try searching for WI, PA, MI, IA, MN and clicking through the years to see this sorting in action.     
* The value of an additional voter is much higher in some states than others in most elections (except 2012).  To see this, weight the circles by the Voter Power Index (VPI) and click through the years.  New Hampshire, Pennsylvania, Wisconsin and Michigan dominate the voting power calculation for 2016.  Clinton would have won the 2016 election if turnout was a few points higher in just three counties: Milwaukee County WI, Wayne County MI, and Philadelphia County PA.    
* A good approach to flipping an election is to weight the circles by VPI, then click and drag the largest circles to increase the turnout or margin.

## Assumptions

* I assume increases in turnout are apportioned based on the fraction of each county that voted for each party initially.  This probably underestimates the impact of increased turnout for Democrats because the electorate often leans left as turnout increases.  
* Changes in margin are zero sum. Any increase in the Democrat’s vote total comes from Republican voters switching sides, not from third party candidates.


## Calculations

**Voter Power Index**:  This index is an estimate of the value of additional voters in each state based on [given] the candidate margin of victory.  Groups like [538](link) predict how likely a state is to switch between the candidates in order to calculate the VPI, but this takes a simpler approach as outlined at [DailyKos](http://www.dailykos.com/story/2016/12/19/1612252/-Voter-Power-Index-Just-How-Much-Does-the-Electoral-College-Distort-the-Value-of-Your-Vote).  This equation calculates the VPI and apportions it to each county based on the fraction of the state's votes:

* `VPI = (county_number/state_number) * (state_electoral_votes/(Math.abs(num_state_dem-num_state_rep)))`

**Electoral Weighting**:  This weighting splits the electoral college points among the counties based on their fraction of the state vote: 

* `electoral_weighting = (county_number/state_number)*state_electoral_votes`

**Vote Weighting**: This approach sizes the circle area in proportion to the total votes in the county.

**Dragging Circles**: When the user drags a circle, these equations are used to recalculate the county level data.  These updates and others happen in the `dragged()` function in the code:

* `new_county_number = new_turnout*county_voting_age_population`  
* `new_dem_number = (old_dem_fraction + dem_margin_change/2)*new_county_number`  
* `new_rep_number = (old_rep_fraction - dem_margin_change/2)*new_county_number`
  

## Data Issues

I'm fairly confident that the aggregate data are accurate because vote counts and electoral outcomes are similar to those of David Leip's [Election Atlas](http://uselectionatlas.org/).  But even if the aggregates are accurate, it's still possible that there are problems at the individual county level.   

The turnout exceeded 100% in 16 counties, which I made note of and filtered out in the [Jupyter notebook](https://github.com/psthomas/election-vis/blob/master/voting_national.ipynb).  This issue is either caused by bad county level vote tallies or bad voting age population data.  I think the latter is most likely, as I had to use the 2005-2009 American Community Survey average estimates for the 2004 and 2008 elections.  It's possible that the individual year estimates exist somewhere, I just couldn't find them.  I relied on kyaroch's [GitHub repo](https://github.com/kyaroch/2012_and_2016_presidential_election_results_by_county) for the 2012 and 2016 data.  The author uses the annual voting age population data and voting data from The Guardian and the Census Bureau. 

It's important to mention the [distinction](http://www.electproject.org/home/voter-turnout/faq/denominator) between Voting Age Population (VAP) and Voting Eligible Population (VEP).  VEP estimates remove non-citizens, felons (depending on state law), and other groups that are ineligible to vote.  This means that using the VAP data could underestimate turnout in counties with e.g. high felony convictions.  The Sentencing Project [estimates](http://www.pewtrusts.org/en/research-and-analysis/blogs/stateline/2016/10/10/more-than-six-million-felons-cant-vote-in-2016) that 6 million felons were ineligible to vote in 2016, so the effect on estimated turnout could be substantial.  Unfortunately, VEP data isn't available at the county level so I used VAP data instead.  This might be preferable in some ways though because it highlights a problem -- close to 2.5 percent of the US Population isn't being represented by their government.  

Adding in the demographic data led to a new set of problems. I used a combination of the Census Bureau's Current Population Survey [4] for the `Turnout` and `Fraction of the Electorate` values (courtesy of the Elections Project [5]), and the American National Election Studies for the `Democratic Margin` values [6]. Extrapolating from demographic survey data to national vote counts doesn't lead to good estimates, so think of the difference between the estimated percentages and actual percentages from the county data as a measure of the error. This is a well known problem [7] and is a result of uncertainty in the surveys. I also had to interpolate some values to get the categories to line up across datasets, so I make note of that when it's done in the Jupyter notebook.
   
My goal is to improve the accuracy and number of years covered over time, so suggestions and pull requests are welcome. 

## Sources

[1] MIT Election Labs, 2000-2016 County level presidential results: [https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/VOQCHQ](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/VOQCHQ)

[2] Census Bureau County Voting Age Population data: [https://www.census.gov/rdo/data/voting_age_population_by_citizenship_and_race_cvap.html](https://www.census.gov/rdo/data/voting_age_population_by_citizenship_and_race_cvap.html)

[3] Voting and Registration Tables. US Census Bureau. [https://www.census.gov/topics/public-sector/voting/data/tables.All.html](https://www.census.gov/topics/public-sector/voting/data/tables.All.html)

[4] United States Election Project, demographic turnout data. [http://www.electproject.org/home/voter-turnout/demographics](http://www.electproject.org/home/voter-turnout/demographics)

[5] American National Election Studies, demographic margins data. [http://www.electionstudies.org/studypages/download/datacenter_all_NoData.html](http://www.electionstudies.org/studypages/download/datacenter_all_NoData.html)

[6] Voter Trends in 2016. Center for American Progress. [https://www.americanprogress.org/issues/democracy/reports/2017/11/01/441926/voter-trends-in-2016/](https://www.americanprogress.org/issues/democracy/reports/2017/11/01/441926/voter-trends-in-2016/)
