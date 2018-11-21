---
layout: post
title: "Voting Power, Turnout, and Persuasion in Presidential Elections"
excerpt: "I use the voting power index to find counties that are especially powerful in general elections."
#modified:
tags: [Python, Jupyter notebook, politics, Voting Power Index, folium, altair]
comments: true
share: false

---

One interesting feature of the electoral college is that some states have more electoral votes per person than others.  This, combined with the fact that we have swing states, means the importance of a vote varies considerably by location.  

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower/vpi2016.png"><img src="{{ site.baseurl }}/images/votepower/vpi2016.png"></a>
	<figcaption>The Voting Power Index by county for the 2016 Presidential Election.</figcaption>
</figure>

Andrew Gelman has done [some](http://andrewgelman.com/2016/11/07/chance-vote-will-decide-election/) [work](https://pkremp.github.io/pr_decisive_vote.html) on this subject by calculating the probability a voter will swing a presidential election. Below, I ask a different but related question: "Given an election turned out the way it did, how valuable was an additional vote in each state?"  This alternate metric, called the Voting Power Index (VPI), is discussed more at the DailyKos [here](https://www.dailykos.com/stories/2016/12/19/1612252/-Voter-Power-Index-Just-How-Much-Does-the-Electoral-College-Distort-the-Value-of-Your-Vote).  Rather than rely on predicted probabilities of electoral outcomes, this metric simply divides the state's electoral votes by the realized vote margin:

* `state_vpi = state_electoral_votes/(dem_voters - rep_voters)`

I decided to take this metric a step further and calculate a county VPI, which is the fraction of the state's voting power that resides with the voting age population of each county:  

* `county_vpi = state_vpi*(county_vap/state_vap)`

These numbers can then provide some insight on the ongoing [persuasion vs. turnout debate](https://twitter.com/Nate_Cohn/status/972608738631868416) because the county voting power can be further disaggregated by voting status:

* `persuasion_vpi = county_vpi*(voting_vap/county_vap)`  
* `turnout_vpi = county_vpi*(nonvoting_vap/county_vap)`

This `turnout_vpi` value could hopefully act as an adjustment on the numbers from [The Missing Obama Millions](https://www.nytimes.com/2018/03/10/opinion/sunday/obama-trump-voters-democrats.html) article, which didn't take the electoral college into account. To be honest, I'm mainly using this metric because it's straightforward to calculate and easy to understand.  I haven't fully considered all the implications, but it seems to produce results that are similar to other analyses [5].  I'm definietly open to critique from others in order to "kick the tires" of this metric. 

These data were compiled for a [previous visualization]({{ site.baseurl }}/2017/06/05/national-election-vis), and are available along with all the code [here](https://github.com/psthomas/voting-power).


## Visualizing the County Data

These plots show that the VPI follows a lognormal or power law distribution, with some years like 2012 having fewer outlying values.  A power law distribution wouldn't be too surprising here because the values are derived using population values for counties, which probably follow something close to a power law themselves.  Note that I adjusted all of the county values so the median value across all years is one.   

<figure>
	<a href="{{ site.baseurl }}/images/votepower/output_9_1.png"><img src="{{ site.baseurl }}/images/votepower/output_9_1.png"></a>
	<figcaption>Boxplot of the VPI for each county by year, note the log y-axis.</figcaption>
</figure>

<figure>
	<a href="{{ site.baseurl }}/images/votepower/output_10_1.png"><img src="{{ site.baseurl }}/images/votepower/output_10_1.png"></a>
	<figcaption>Histograms of the VPI by year, log adjusted.</figcaption>
</figure>

<figure>
	<a href="{{ site.baseurl }}/images/votepower/output_12_3.png"><img src="{{ site.baseurl }}/images/votepower/output_12_3.png"></a>
	<figcaption>Maps of the VPI by county, 2004-2016.</figcaption>
</figure>


## A Closer Look at 2016

Below, I select out just the 2016 values for a more in-depth look.  One important point to make is that the VPI only shows counties that were important given the way the election turned out.  It's entirely possible that a different set of counties would show up if campaigns focused their resources elsewhere, depending on how powerful you think campaigns are.  So this 2016 data is more useful for providing a picture of what happened, rather than saying what should have been done instead.  The averages I look at later can provide more of a general picture of places that tend to be important.   

### Top 2016 Counties

The following table just shows the counties sorted by top VPI in 2016:

{% highlight python %}
county2016_df = county_df[county_df['year'] == 2016]

cols_2016 = ['county_name','state', 'year', 'dem_margin',
             'turnout', 'turnout_vpi', 'persuasion_vpi', 'county_vpi',]

county2016_df[cols_2016].sort_values(by='county_vpi', ascending=False).head(30)
{% endhighlight %}

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table  class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>county_name</th>
      <th>state</th>
      <th>year</th>
      <th>dem_margin</th>
      <th>turnout</th>
      <th>turnout_vpi</th>
      <th>persuasion_vpi</th>
      <th>county_vpi</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>4847</th>
      <td>Hillsborough County</td>
      <td>NH</td>
      <td>2016</td>
      <td>-0.0020</td>
      <td>0.6545</td>
      <td>763.202291</td>
      <td>1446.068221</td>
      <td>2209.270512</td>
    </tr>
    <tr>
      <th>4849</th>
      <td>Rockingham County</td>
      <td>NH</td>
      <td>2016</td>
      <td>-0.0583</td>
      <td>0.7383</td>
      <td>435.852891</td>
      <td>1229.390599</td>
      <td>1665.243490</td>
    </tr>
    <tr>
      <th>4390</th>
      <td>Wayne County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.3734</td>
      <td>0.5837</td>
      <td>539.384492</td>
      <td>756.163891</td>
      <td>1295.548383</td>
    </tr>
    <tr>
      <th>4371</th>
      <td>Oakland County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.0811</td>
      <td>0.6801</td>
      <td>303.963423</td>
      <td>646.094828</td>
      <td>950.058250</td>
    </tr>
    <tr>
      <th>4848</th>
      <td>Merrimack County</td>
      <td>NH</td>
      <td>2016</td>
      <td>0.0308</td>
      <td>0.6848</td>
      <td>259.213077</td>
      <td>563.095587</td>
      <td>822.308664</td>
    </tr>
    <tr>
      <th>4826</th>
      <td>Clark County</td>
      <td>NV</td>
      <td>2016</td>
      <td>0.1096</td>
      <td>0.4527</td>
      <td>443.659050</td>
      <td>366.924796</td>
      <td>810.583846</td>
    </tr>
    <tr>
      <th>4850</th>
      <td>Strafford County</td>
      <td>NH</td>
      <td>2016</td>
      <td>0.0856</td>
      <td>0.6590</td>
      <td>241.359028</td>
      <td>466.455912</td>
      <td>707.814940</td>
    </tr>
    <tr>
      <th>4358</th>
      <td>Macomb County</td>
      <td>MI</td>
      <td>2016</td>
      <td>-0.1153</td>
      <td>0.6148</td>
      <td>255.384842</td>
      <td>407.628058</td>
      <td>663.012901</td>
    </tr>
    <tr>
      <th>4846</th>
      <td>Grafton County</td>
      <td>NH</td>
      <td>2016</td>
      <td>0.1896</td>
      <td>0.6738</td>
      <td>166.484551</td>
      <td>343.872287</td>
      <td>510.356838</td>
    </tr>
    <tr>
      <th>4349</th>
      <td>Kent County</td>
      <td>MI</td>
      <td>2016</td>
      <td>-0.0308</td>
      <td>0.6372</td>
      <td>170.557276</td>
      <td>299.596590</td>
      <td>470.153866</td>
    </tr>
    <tr>
      <th>4844</th>
      <td>Cheshire County</td>
      <td>NH</td>
      <td>2016</td>
      <td>0.1262</td>
      <td>0.6652</td>
      <td>142.008996</td>
      <td>282.158481</td>
      <td>424.167478</td>
    </tr>
    <tr>
      <th>3183</th>
      <td>Maricopa County</td>
      <td>AZ</td>
      <td>2016</td>
      <td>-0.0289</td>
      <td>0.4787</td>
      <td>191.532380</td>
      <td>175.913839</td>
      <td>367.446219</td>
    </tr>
    <tr>
      <th>6165</th>
      <td>Milwaukee County</td>
      <td>WI</td>
      <td>2016</td>
      <td>0.3701</td>
      <td>0.6069</td>
      <td>144.012269</td>
      <td>222.310555</td>
      <td>366.322824</td>
    </tr>
    <tr>
      <th>4842</th>
      <td>Belknap County</td>
      <td>NH</td>
      <td>2016</td>
      <td>-0.1678</td>
      <td>0.7013</td>
      <td>100.996831</td>
      <td>237.125381</td>
      <td>338.122212</td>
    </tr>
    <tr>
      <th>4333</th>
      <td>Genesee County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.0946</td>
      <td>0.6238</td>
      <td>115.104725</td>
      <td>190.826300</td>
      <td>305.931025</td>
    </tr>
    <tr>
      <th>4389</th>
      <td>Washtenaw County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.4128</td>
      <td>0.6460</td>
      <td>100.443951</td>
      <td>183.323358</td>
      <td>283.767309</td>
    </tr>
    <tr>
      <th>5372</th>
      <td>Philadelphia County</td>
      <td>PA</td>
      <td>2016</td>
      <td>0.6698</td>
      <td>0.5792</td>
      <td>115.593496</td>
      <td>159.124457</td>
      <td>274.717953</td>
    </tr>
    <tr>
      <th>4843</th>
      <td>Carroll County</td>
      <td>NH</td>
      <td>2016</td>
      <td>-0.0566</td>
      <td>0.7359</td>
      <td>71.663218</td>
      <td>199.688143</td>
      <td>271.351361</td>
    </tr>
    <tr>
      <th>4418</th>
      <td>Hennepin County</td>
      <td>MN</td>
      <td>2016</td>
      <td>0.3493</td>
      <td>0.7074</td>
      <td>74.660455</td>
      <td>180.535170</td>
      <td>255.195626</td>
    </tr>
  </tbody>
</table>
</div>

Here's an interactive map showing VPI by county in 2016:

<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="{{ site.baseurl }}/vis/vpi_folium-2016.html" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>

### Which counties were crucial in states Democrats lost?

{% highlight python %}
#Important counties for Democrats, in states they lost:
county2016_df[(county2016_df['state_dem_margin'] < 0)] \
    .sort_values(by='county_vpi', ascending=False)[cols_2016].head(20)
{% endhighlight %}

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table  class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>county_name</th>
      <th>state</th>
      <th>year</th>
      <th>dem_margin</th>
      <th>turnout</th>
      <th>turnout_vpi</th>
      <th>persuasion_vpi</th>
      <th>county_vpi</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>4390</th>
      <td>Wayne County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.3734</td>
      <td>0.5837</td>
      <td>539.384492</td>
      <td>756.163891</td>
      <td>1295.548383</td>
    </tr>
    <tr>
      <th>4371</th>
      <td>Oakland County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.0811</td>
      <td>0.6801</td>
      <td>303.963423</td>
      <td>646.094828</td>
      <td>950.058250</td>
    </tr>
    <tr>
      <th>4358</th>
      <td>Macomb County</td>
      <td>MI</td>
      <td>2016</td>
      <td>-0.1153</td>
      <td>0.6148</td>
      <td>255.384842</td>
      <td>407.628058</td>
      <td>663.012901</td>
    </tr>
    <tr>
      <th>4349</th>
      <td>Kent County</td>
      <td>MI</td>
      <td>2016</td>
      <td>-0.0308</td>
      <td>0.6372</td>
      <td>170.557276</td>
      <td>299.596590</td>
      <td>470.153866</td>
    </tr>
    <tr>
      <th>3183</th>
      <td>Maricopa County</td>
      <td>AZ</td>
      <td>2016</td>
      <td>-0.0289</td>
      <td>0.4787</td>
      <td>191.532380</td>
      <td>175.913839</td>
      <td>367.446219</td>
    </tr>
    <tr>
      <th>6165</th>
      <td>Milwaukee County</td>
      <td>WI</td>
      <td>2016</td>
      <td>0.3701</td>
      <td>0.6069</td>
      <td>144.012269</td>
      <td>222.310555</td>
      <td>366.322824</td>
    </tr>
    <tr>
      <th>4333</th>
      <td>Genesee County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.0946</td>
      <td>0.6238</td>
      <td>115.104725</td>
      <td>190.826300</td>
      <td>305.931025</td>
    </tr>
    <tr>
      <th>4389</th>
      <td>Washtenaw County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.4128</td>
      <td>0.6460</td>
      <td>100.443951</td>
      <td>183.323358</td>
      <td>283.767309</td>
    </tr>
    <tr>
      <th>5372</th>
      <td>Philadelphia County</td>
      <td>PA</td>
      <td>2016</td>
      <td>0.6698</td>
      <td>0.5792</td>
      <td>115.593496</td>
      <td>159.124457</td>
      <td>274.717953</td>
    </tr>
    <tr>
      <th>4341</th>
      <td>Ingham County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.2687</td>
      <td>0.5697</td>
      <td>96.279322</td>
      <td>127.483898</td>
      <td>223.763221</td>
    </tr>
    <tr>
      <th>5323</th>
      <td>Allegheny County</td>
      <td>PA</td>
      <td>2016</td>
      <td>0.1645</td>
      <td>0.6601</td>
      <td>75.873263</td>
      <td>147.367799</td>
      <td>223.241062</td>
    </tr>
    <tr>
      <th>6137</th>
      <td>Dane County</td>
      <td>WI</td>
      <td>2016</td>
      <td>0.4717</td>
      <td>0.7387</td>
      <td>55.366688</td>
      <td>156.548600</td>
      <td>211.915288</td>
    </tr>
    <tr>
      <th>4378</th>
      <td>Ottawa County</td>
      <td>MI</td>
      <td>2016</td>
      <td>-0.3047</td>
      <td>0.6671</td>
      <td>69.241319</td>
      <td>138.756781</td>
      <td>207.998100</td>
    </tr>
    <tr>
      <th>4347</th>
      <td>Kalamazoo County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.1276</td>
      <td>0.6177</td>
      <td>75.981134</td>
      <td>122.779735</td>
      <td>198.760869</td>
    </tr>
    <tr>
      <th>3441</th>
      <td>Miami-Dade County</td>
      <td>FL</td>
      <td>2016</td>
      <td>0.2960</td>
      <td>0.4532</td>
      <td>92.740626</td>
      <td>76.856905</td>
      <td>169.597531</td>
    </tr>
  </tbody>
</table>
</div>

### Where was more turnout especially important for Democrats?  

The `partisanturnout_vpi` multiplies the democratic margin for each county times the fraction of county's voting power that resided with non-voters, in states that Democrats lost. 

{% highlight python %}
#Adjusting turnout for party margin
county_df['partisanturnout_vpi'] = county_df['dem_margin']*county_df['turnout_vpi']

county2016_df[(county2016_df['state_dem_margin'] < 0)] \
    .sort_values(by='partisanturnout_vpi', ascending=False) \
    .head(20)
{% endhighlight %}

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table  class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>county_name</th>
      <th>state</th>
      <th>year</th>
      <th>dem_margin</th>
      <th>turnout</th>
      <th>turnout_vpi</th>
      <th>persuasion_vpi</th>
      <th>county_vpi</th>
      <th>partisanturnout_vpi</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>4390</th>
      <td>Wayne County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.3734</td>
      <td>0.5837</td>
      <td>539.384492</td>
      <td>756.163891</td>
      <td>1295.548383</td>
      <td>201.406169</td>
    </tr>
    <tr>
      <th>5372</th>
      <td>Philadelphia County</td>
      <td>PA</td>
      <td>2016</td>
      <td>0.6698</td>
      <td>0.5792</td>
      <td>115.593496</td>
      <td>159.124457</td>
      <td>274.717953</td>
      <td>77.424524</td>
    </tr>
    <tr>
      <th>6165</th>
      <td>Milwaukee County</td>
      <td>WI</td>
      <td>2016</td>
      <td>0.3701</td>
      <td>0.6069</td>
      <td>144.012269</td>
      <td>222.310555</td>
      <td>366.322824</td>
      <td>53.298941</td>
    </tr>
    <tr>
      <th>4389</th>
      <td>Washtenaw County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.4128</td>
      <td>0.6460</td>
      <td>100.443951</td>
      <td>183.323358</td>
      <td>283.767309</td>
      <td>41.463263</td>
    </tr>
    <tr>
      <th>3441</th>
      <td>Miami-Dade County</td>
      <td>FL</td>
      <td>2016</td>
      <td>0.2960</td>
      <td>0.4532</td>
      <td>92.740626</td>
      <td>76.856905</td>
      <td>169.597531</td>
      <td>27.451225</td>
    </tr>
    <tr>
      <th>6137</th>
      <td>Dane County</td>
      <td>WI</td>
      <td>2016</td>
      <td>0.4717</td>
      <td>0.7387</td>
      <td>55.366688</td>
      <td>156.548600</td>
      <td>211.915288</td>
      <td>26.116467</td>
    </tr>
    <tr>
      <th>4341</th>
      <td>Ingham County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.2687</td>
      <td>0.5697</td>
      <td>96.279322</td>
      <td>127.483898</td>
      <td>223.763221</td>
      <td>25.870254</td>
    </tr>
    <tr>
      <th>4371</th>
      <td>Oakland County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.0811</td>
      <td>0.6801</td>
      <td>303.963423</td>
      <td>646.094828</td>
      <td>950.058250</td>
      <td>24.651434</td>
    </tr>
    <tr>
      <th>3404</th>
      <td>Broward County</td>
      <td>FL</td>
      <td>2016</td>
      <td>0.3514</td>
      <td>0.5507</td>
      <td>53.225032</td>
      <td>65.232522</td>
      <td>118.457554</td>
      <td>18.703276</td>
    </tr>
    <tr>
      <th>5323</th>
      <td>Allegheny County</td>
      <td>PA</td>
      <td>2016</td>
      <td>0.1645</td>
      <td>0.6601</td>
      <td>75.873263</td>
      <td>147.367799</td>
      <td>223.241062</td>
      <td>12.481152</td>
    </tr>
    <tr>
      <th>4333</th>
      <td>Genesee County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.0946</td>
      <td>0.6238</td>
      <td>115.104725</td>
      <td>190.826300</td>
      <td>305.931025</td>
      <td>10.888907</td>
    </tr>
    <tr>
      <th>5367</th>
      <td>Montgomery County</td>
      <td>PA</td>
      <td>2016</td>
      <td>0.2128</td>
      <td>0.6807</td>
      <td>46.131019</td>
      <td>98.363149</td>
      <td>144.494168</td>
      <td>9.816681</td>
    </tr>
    <tr>
      <th>4347</th>
      <td>Kalamazoo County</td>
      <td>MI</td>
      <td>2016</td>
      <td>0.1276</td>
      <td>0.6177</td>
      <td>75.981134</td>
      <td>122.779735</td>
      <td>198.760869</td>
      <td>9.695193</td>
    </tr>
  </tbody>
</table>
</div>

# County Averages, 2004-2016

The above 2016 analysis is interesting but if we want values that are more generalizable to future elections it makes sense to look at averages.  If you average over too few elections you risk overfitting to a specific point in time, but averaging over too many years will make the results irrelevant to the present.  I was only able to compile data from 2004 forward anyways, so these are the years I went with.   

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table  class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>county_name</th>
      <th>state</th>
      <th>dem_margin</th>
      <th>turnout</th>
      <th>turnout_vpi</th>
      <th>persuasion_vpi</th>
      <th>county_vpi</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1901</th>
      <td>Bernalillo County</td>
      <td>NM</td>
      <td>0.149150</td>
      <td>0.574300</td>
      <td>322.191780</td>
      <td>458.901725</td>
      <td>781.093505</td>
    </tr>
    <tr>
      <th>1875</th>
      <td>Hillsborough County</td>
      <td>NH</td>
      <td>0.004500</td>
      <td>0.673875</td>
      <td>261.531237</td>
      <td>509.284778</td>
      <td>770.816015</td>
    </tr>
    <tr>
      <th>1466</th>
      <td>St. Louis County County</td>
      <td>MO</td>
      <td>0.147975</td>
      <td>0.713775</td>
      <td>146.267445</td>
      <td>475.652972</td>
      <td>621.920417</td>
    </tr>
    <tr>
      <th>1877</th>
      <td>Rockingham County</td>
      <td>NH</td>
      <td>-0.033725</td>
      <td>0.736700</td>
      <td>154.517507</td>
      <td>427.941955</td>
      <td>582.459462</td>
    </tr>
    <tr>
      <th>1935</th>
      <td>Clark County</td>
      <td>NV</td>
      <td>0.123775</td>
      <td>0.491850</td>
      <td>274.776186</td>
      <td>247.379861</td>
      <td>522.156047</td>
    </tr>
    <tr>
      <th>1418</th>
      <td>Jackson County</td>
      <td>MO</td>
      <td>0.198300</td>
      <td>0.625425</td>
      <td>135.126185</td>
      <td>287.882299</td>
      <td>423.008484</td>
    </tr>
    <tr>
      <th>1282</th>
      <td>Wayne County</td>
      <td>MI</td>
      <td>0.432750</td>
      <td>0.613300</td>
      <td>148.977818</td>
      <td>212.273072</td>
      <td>361.250891</td>
    </tr>
    <tr>
      <th>1876</th>
      <td>Merrimack County</td>
      <td>NH</td>
      <td>0.086950</td>
      <td>0.690625</td>
      <td>91.522184</td>
      <td>198.694873</td>
      <td>290.217058</td>
    </tr>
    <tr>
      <th>3004</th>
      <td>Milwaukee County</td>
      <td>WI</td>
      <td>0.333100</td>
      <td>0.681100</td>
      <td>89.948122</td>
      <td>193.970429</td>
      <td>283.918551</td>
    </tr>
    <tr>
      <th>1263</th>
      <td>Oakland County</td>
      <td>MI</td>
      <td>0.077700</td>
      <td>0.722425</td>
      <td>82.209028</td>
      <td>179.036279</td>
      <td>261.245307</td>
    </tr>
    <tr>
      <th>1878</th>
      <td>Strafford County</td>
      <td>NH</td>
      <td>0.138775</td>
      <td>0.653925</td>
      <td>85.666172</td>
      <td>161.759279</td>
      <td>247.425451</td>
    </tr>
    <tr>
      <th>1485</th>
      <td>St. Louis City County</td>
      <td>MO</td>
      <td>0.648300</td>
      <td>0.562800</td>
      <td>87.590113</td>
      <td>134.671075</td>
      <td>222.261188</td>
    </tr>
    <tr>
      <th>1908</th>
      <td>Dona Ana County</td>
      <td>NM</td>
      <td>0.134450</td>
      <td>0.487375</td>
      <td>106.915843</td>
      <td>111.046813</td>
      <td>217.962656</td>
    </tr>
    <tr>
      <th>1462</th>
      <td>St. Charles County</td>
      <td>MO</td>
      <td>-0.186850</td>
      <td>0.691450</td>
      <td>51.804907</td>
      <td>160.086089</td>
      <td>211.890996</td>
    </tr>
    <tr>
      <th>149</th>
      <td>Maricopa County</td>
      <td>AZ</td>
      <td>-0.096975</td>
      <td>0.504300</td>
      <td>102.560581</td>
      <td>101.472468</td>
      <td>204.033050</td>
    </tr>
    <tr>
      <th>1250</th>
      <td>Macomb County</td>
      <td>MI</td>
      <td>-0.001075</td>
      <td>0.646625</td>
      <td>69.591618</td>
      <td>112.881508</td>
      <td>182.473126</td>
    </tr>
  </tbody>
</table>
</div>

Here's a map of the averages:

<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="{{ site.baseurl }}/vis/vpi_folium-2004-2016.html" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>

<figure>
	<a href="{{ site.baseurl }}/images/votepower/output_24_1.png"><img src="{{ site.baseurl }}/images/votepower/output_24_1.png"></a>
</figure>


### Which counties are important for Democrats, on average?

Next, I repeat much of the same analysis as for 2016 using these average values now.  The following table shows counties that are crucial for Democrats in states they're often within one standard deviation of losing: 

{% highlight python %}
#Using stdev as cutoff:
avg_df[(avg_df['state_dem_margin'] - avg_df['state_dem_margin_std'])  < 0] \
    .sort_values(by='county_vpi', ascending=False) \
    [avg_cols].head(30)
{% endhighlight %}

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table  class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>county_name</th>
      <th>state</th>
      <th>dem_margin</th>
      <th>turnout</th>
      <th>turnout_vpi</th>
      <th>persuasion_vpi</th>
      <th>county_vpi</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1875</th>
      <td>Hillsborough County</td>
      <td>NH</td>
      <td>0.004500</td>
      <td>0.673875</td>
      <td>261.531237</td>
      <td>509.284778</td>
      <td>770.816015</td>
    </tr>
    <tr>
      <th>1466</th>
      <td>St. Louis County County</td>
      <td>MO</td>
      <td>0.147975</td>
      <td>0.713775</td>
      <td>146.267445</td>
      <td>475.652972</td>
      <td>621.920417</td>
    </tr>
    <tr>
      <th>1877</th>
      <td>Rockingham County</td>
      <td>NH</td>
      <td>-0.033725</td>
      <td>0.736700</td>
      <td>154.517507</td>
      <td>427.941955</td>
      <td>582.459462</td>
    </tr>
    <tr>
      <th>1935</th>
      <td>Clark County</td>
      <td>NV</td>
      <td>0.123775</td>
      <td>0.491850</td>
      <td>274.776186</td>
      <td>247.379861</td>
      <td>522.156047</td>
    </tr>
    <tr>
      <th>1418</th>
      <td>Jackson County</td>
      <td>MO</td>
      <td>0.198300</td>
      <td>0.625425</td>
      <td>135.126185</td>
      <td>287.882299</td>
      <td>423.008484</td>
    </tr>
    <tr>
      <th>1282</th>
      <td>Wayne County</td>
      <td>MI</td>
      <td>0.432750</td>
      <td>0.613300</td>
      <td>148.977818</td>
      <td>212.273072</td>
      <td>361.250891</td>
    </tr>
    <tr>
      <th>1876</th>
      <td>Merrimack County</td>
      <td>NH</td>
      <td>0.086950</td>
      <td>0.690625</td>
      <td>91.522184</td>
      <td>198.694873</td>
      <td>290.217058</td>
    </tr>
    <tr>
      <th>3004</th>
      <td>Milwaukee County</td>
      <td>WI</td>
      <td>0.333100</td>
      <td>0.681100</td>
      <td>89.948122</td>
      <td>193.970429</td>
      <td>283.918551</td>
    </tr>
    <tr>
      <th>1263</th>
      <td>Oakland County</td>
      <td>MI</td>
      <td>0.077700</td>
      <td>0.722425</td>
      <td>82.209028</td>
      <td>179.036279</td>
      <td>261.245307</td>
    </tr>
    <tr>
      <th>1878</th>
      <td>Strafford County</td>
      <td>NH</td>
      <td>0.138775</td>
      <td>0.653925</td>
      <td>85.666172</td>
      <td>161.759279</td>
      <td>247.425451</td>
    </tr>
    <tr>
      <th>1485</th>
      <td>St. Louis City County</td>
      <td>MO</td>
      <td>0.648300</td>
      <td>0.562800</td>
      <td>87.590113</td>
      <td>134.671075</td>
      <td>222.261188</td>
    </tr>
    <tr>
      <th>1462</th>
      <td>St. Charles County</td>
      <td>MO</td>
      <td>-0.186850</td>
      <td>0.691450</td>
      <td>51.804907</td>
      <td>160.086089</td>
      <td>211.890996</td>
    </tr>
    <tr>
      <th>149</th>
      <td>Maricopa County</td>
      <td>AZ</td>
      <td>-0.096975</td>
      <td>0.504300</td>
      <td>102.560581</td>
      <td>101.472468</td>
      <td>204.033050</td>
    </tr>
    <tr>
      <th>1250</th>
      <td>Macomb County</td>
      <td>MI</td>
      <td>-0.001075</td>
      <td>0.646625</td>
      <td>69.591618</td>
      <td>112.881508</td>
      <td>182.473126</td>
    </tr>
    <tr>
      <th>1874</th>
      <td>Grafton County</td>
      <td>NH</td>
      <td>0.207425</td>
      <td>0.695250</td>
      <td>56.945682</td>
      <td>121.479588</td>
      <td>178.425270</td>
    </tr>
    <tr>
      <th>1409</th>
      <td>Greene County</td>
      <td>MO</td>
      <td>-0.230925</td>
      <td>0.603550</td>
      <td>58.499603</td>
      <td>115.185390</td>
      <td>173.684993</td>
    </tr>
    <tr>
      <th>2976</th>
      <td>Dane County</td>
      <td>WI</td>
      <td>0.426900</td>
      <td>0.766800</td>
      <td>37.693819</td>
      <td>118.256630</td>
      <td>155.950449</td>
    </tr>
    <tr>
      <th>1683</th>
      <td>Mecklenburg County</td>
      <td>NC</td>
      <td>0.199550</td>
      <td>0.623500</td>
      <td>46.769953</td>
      <td>105.776832</td>
      <td>152.546785</td>
    </tr>
  </tbody>
</table>
</div>

### Where is turnout important for Democrats, on average?

These are counties that have a high `partisanturnout_vpi`, which is calculated by multiplying the Democratic margin in a county times the `turnout_vpi`, then filtering by states Democrats are within one standard deviation of losing on average. 

{% highlight python %}
#Using standard deviation as cutoff:
avg_df[(avg_df['state_dem_margin'] - avg_df['state_dem_margin_std'])  < 0] \
    .sort_values(by='partisanturnout_vpi', ascending=False) \
    [temp_cols].head(20)
{% endhighlight %}

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table  class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>county_name</th>
      <th>state</th>
      <th>dem_margin</th>
      <th>turnout</th>
      <th>turnout_vpi</th>
      <th>persuasion_vpi</th>
      <th>county_vpi</th>
      <th>partisanturnout_vpi</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1485</th>
      <td>St. Louis City County</td>
      <td>MO</td>
      <td>0.648300</td>
      <td>0.562800</td>
      <td>87.590113</td>
      <td>134.671075</td>
      <td>222.261188</td>
      <td>59.512773</td>
    </tr>
    <tr>
      <th>1282</th>
      <td>Wayne County</td>
      <td>MI</td>
      <td>0.432750</td>
      <td>0.613300</td>
      <td>148.977818</td>
      <td>212.273072</td>
      <td>361.250891</td>
      <td>56.343820</td>
    </tr>
    <tr>
      <th>1418</th>
      <td>Jackson County</td>
      <td>MO</td>
      <td>0.198300</td>
      <td>0.625425</td>
      <td>135.126185</td>
      <td>287.882299</td>
      <td>423.008484</td>
      <td>33.846646</td>
    </tr>
    <tr>
      <th>1466</th>
      <td>St. Louis County County</td>
      <td>MO</td>
      <td>0.147975</td>
      <td>0.713775</td>
      <td>146.267445</td>
      <td>475.652972</td>
      <td>621.920417</td>
      <td>28.579127</td>
    </tr>
    <tr>
      <th>2264</th>
      <td>Philadelphia County</td>
      <td>PA</td>
      <td>0.665325</td>
      <td>0.609925</td>
      <td>42.629915</td>
      <td>61.745824</td>
      <td>104.375739</td>
      <td>28.265886</td>
    </tr>
    <tr>
      <th>3004</th>
      <td>Milwaukee County</td>
      <td>WI</td>
      <td>0.333100</td>
      <td>0.681100</td>
      <td>89.948122</td>
      <td>193.970429</td>
      <td>283.918551</td>
      <td>26.973063</td>
    </tr>
    <tr>
      <th>1935</th>
      <td>Clark County</td>
      <td>NV</td>
      <td>0.123775</td>
      <td>0.491850</td>
      <td>274.776186</td>
      <td>247.379861</td>
      <td>522.156047</td>
      <td>26.547873</td>
    </tr>
    <tr>
      <th>333</th>
      <td>Miami-Dade County</td>
      <td>FL</td>
      <td>0.189300</td>
      <td>0.530975</td>
      <td>70.069633</td>
      <td>62.784885</td>
      <td>132.854518</td>
      <td>16.912560</td>
    </tr>
    <tr>
      <th>2976</th>
      <td>Dane County</td>
      <td>WI</td>
      <td>0.426900</td>
      <td>0.766800</td>
      <td>37.693819</td>
      <td>118.256630</td>
      <td>155.950449</td>
      <td>14.620923</td>
    </tr>
    <tr>
      <th>296</th>
      <td>Broward County</td>
      <td>FL</td>
      <td>0.335900</td>
      <td>0.597550</td>
      <td>41.629796</td>
      <td>54.008480</td>
      <td>95.638276</td>
      <td>14.402219</td>
    </tr>
    <tr>
      <th>814</th>
      <td>Marion County</td>
      <td>IN</td>
      <td>0.188175</td>
      <td>0.543075</td>
      <td>46.917241</td>
      <td>71.846952</td>
      <td>118.764192</td>
      <td>12.542131</td>
    </tr>
    <tr>
      <th>1683</th>
      <td>Mecklenburg County</td>
      <td>NC</td>
      <td>0.199550</td>
      <td>0.623500</td>
      <td>46.769953</td>
      <td>105.776832</td>
      <td>152.546785</td>
      <td>11.133419</td>
    </tr>
  </tbody>
</table>
</div>

## How well does the VPI predict the future?

One purpose of this analysis is to use the VPI to predict the locations that will be important for future elections, so below I run a few regressions to estimate the predictive power.  Note that I use the state level VPI for these regressions because the county level observations aren't independent (they're all derived from the state level VPI).  First is a regression showing how the previous election predicts the next one:

<figure>
  <a href="{{ site.baseurl }}/images/votepower/output_25_1.png"><img src="{{ site.baseurl }}/images/votepower/output_25_1.png"></a>
</figure>

So, looking at the R^2 values, the ability of the previous election to predict the next one varies but overall seems pretty unstable.  Next, I look at how the average of the last three elections predicts the 2016 election:

<figure>
  <a href="{{ site.baseurl }}/images/votepower/output_26_1.png"><img src="{{ site.baseurl }}/images/votepower/output_26_1.png"></a>
</figure>

This seems like it might do a little better job, but it's still pretty inconsistent at the high end of VPIs which is where you'd want to use it to allocate resources.  So overall the VPI seems like it might be more useful as a metric to describe the results of past elections rather than predict the future.     

## Turnout vs. Persuasion

Next, I sum the persuasion and turnout values for each election, and then calculate their ratio.  This shows that persuasion wins out in every election, but that these ratios can vary considerably.  The average pesuasion to turnout ratio is `1.6:1`, but the ratio was only `1.3:1` in 2012, a year with low turnout and few close states.  

{% highlight python %}
yr_df = county_df.groupby(['year']) \
    .agg({'persuasion_vpi': 'sum',
          'turnout_vpi': 'sum', 'turnout_advantage':'sum'})
yr_df['ratio'] = yr_df['persuasion_vpi'] / yr_df['turnout_vpi']
yr_df
{% endhighlight %}


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table  class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>turnout_advantage</th>
      <th>turnout_vpi</th>
      <th>persuasion_vpi</th>
      <th>ratio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2004</th>
      <td>-7565.454805</td>
      <td>11808.359012</td>
      <td>19373.813817</td>
      <td>1.640686</td>
    </tr>
    <tr>
      <th>2008</th>
      <td>-10075.903226</td>
      <td>11373.802537</td>
      <td>21449.705764</td>
      <td>1.885887</td>
    </tr>
    <tr>
      <th>2012</th>
      <td>-1775.685570</td>
      <td>5122.170093</td>
      <td>6897.855664</td>
      <td>1.346667</td>
    </tr>
    <tr>
      <th>2016</th>
      <td>-7459.669223</td>
      <td>11810.178369</td>
      <td>19269.847592</td>
      <td>1.631631</td>
    </tr>
  </tbody>
</table>
</div>

Averages for all elections:

{% highlight python %}
yr_df.mean()

turnout_advantage    -6719.178206
turnout_vpi          10028.627503
persuasion_vpi       16747.805709
ratio                    1.626218
{% endhighlight %}


An interesting point Nate Cohn [made](https://twitter.com/Nate_Cohn/status/972608738631868416) is that when you persuade someone, it's usually the case that you're switching their vote from an opponent.  On the face of it, this would make persuasion doubly effective:  

<figure>
	<a href="{{ site.baseurl }}/images/votepower/cohnpersuasion.png"><img src="{{ site.baseurl }}/images/votepower/cohnpersuasion.png"></a>
</figure>

But when you turn out a strong Democratic voter they're likely to vote for every Democrat on the ballot, while persuading a Republican to vote for a particular candidate might only lead to a [split ticket](https://en.wikipedia.org/wiki/Split-ticket_voting).  So the net political effect of increased turnout might be larger when you consider every candidate on the ballot and their political power.  In addition, if voting is habit forming, the benefits of increased turnout could extend to future elections [7].      

These results are interesting, but aren't informative until we have data on the cost effectiveness of each approach, which probably depends on things like the population density and price of ad buys in different locations.  Rather than thinking in binary terms, I think it makes sense to ask which strategy is better depending on the location.  For more on this discussion, see this [twitter thread](https://twitter.com/davidshor/status/1055918122371350530):

<figure>
  <a href="{{ site.baseurl }}/images/votepower/cost-effectiveness.png"><img src="{{ site.baseurl }}/images/votepower/cost-effectiveness.png"></a>
</figure>

## Conclusion

* Voting power is lognormally or power law distributed, so some counties/voters are much more powerful than others.  
* Certain locations in NH, NM, MO, NV, MI, WI, PA, and FL regularly top the list.   
* At least according to this metric, persuasion has more power than turnout (an average 1.6:1 ratio), but the cost of each approach needs to be considered before drawing any conclusions.  
* The VPI doesn't do a very good job of predicting future elections, so it's probably more useful as a way to describe results from the past.    

## Next steps

This analysis only considers the power of a location in the presidential elections, but Senate, House and State Level elections are crucial too.  It wouldn't be very hard to include results from Senate elections as those are statewide, but House districts don't match county lines and have ever-changing boundaries.  As a result, it would be hard to get Voting Age Population data and distribute the voting power amongst the counties.

One thing I could do is create a [synthetic population](https://github.com/UDST/synthpop) of the US using census data.  I could then distribute voting power to every individual based on their location in Presidential, Congressional and State elections, then aggregate it by any boundary I choose.  I'd need accurate district boundaries, results for every election, and a model of how power is shared across branches of government to make this work though.
  
## References

[1] What is the chance that your vote will decide the election? Ask Stan! [http://andrewgelman.com/2016/11/07/chance-vote-will-decide-election/](http://andrewgelman.com/2016/11/07/chance-vote-will-decide-election/)

[2] What is the Chance That Your Vote Will Decide the Election? [https://pkremp.github.io/pr_decisive_vote.html](https://pkremp.github.io/pr_decisive_vote.html)

[3] Nate Cohn.  [https://twitter.com/Nate_Cohn/status/972608738631868416](https://twitter.com/Nate_Cohn/status/972608738631868416)

[4] The Missing Obama Millions.  [https://www.nytimes.com/2018/03/10/opinion/sunday/obama-trump-voters-democrats.html](https://www.nytimes.com/2018/03/10/opinion/sunday/obama-trump-voters-democrats.html)

[5] Voter Power Index: Just How Much Does the Electoral College Distort the Value of Your Vote?  [https://www.dailykos.com/stories/2016/12/19/1612252/-Voter-Power-Index-Just-How-Much-Does-the-Electoral-College-Distort-the-Value-of-Your-Vote](https://www.dailykos.com/stories/2016/12/19/1612252/-Voter-Power-Index-Just-How-Much-Does-the-Electoral-College-Distort-the-Value-of-Your-Vote)

[6] Synthpop: Synthetic populations from census data.  [https://github.com/UDST/synthpop](https://github.com/UDST/synthpop)

[7] Is Voting Habit Forming? New Evidence from Experiments and Regression Discontinuities.  [https://onlinelibrary.wiley.com/doi/abs/10.1111/ajps.12210](https://onlinelibrary.wiley.com/doi/abs/10.1111/ajps.12210)

