---
layout: post
title: "Where does political power reside in the United States?"
excerpt: "Combining election results to find where voters are especially influential."
tags: [Python, Jupyter notebook, politics, voting power, Geopandas, Pandas, altair]
comments: true
share: false
---

It's difficult to get a broad mental overview of politics in the United States. There are so many elections covering different districts and each office holder has a different level of influence over policy.  This post is an attempt to help simplify things by bringing all the federal and state level election results together in one place. I then use an approach outlined below to combine all the results into a single voting power metric for each location.  The end result is a map that communicates the cumulative political influence of the voters by location:

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/sum-votepower.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/sum-votepower.png"></a>
	<figcaption>The cumulative voting power for each geography over the last election cycle.</figcaption>
</figure>

Here are my main takeaways from this analysis:

* We should pay more attention to Governors races.  Governors probably collectively wield as much power as the President, but their elections don't get anywhere near the same level of attention.
* Voting power within states is eroded by the fact that 40 percent (!) of the candidates for state legislature run unopposed.  This is probably a symptom of overly gerrymandered state districts.
* Voters in FL, NC, MI, PA, NH, WI and GA are especially powerful, mainly because they participated in close elections for President and Governor.
* By this metric, the most powerful location during the past election cycle was a western suburb of Miami.

All the code and most of the data for this post are available on GitHub [here](https://github.com/psthomas/voting-power-comp).  This analysis builds on my [earlier post](https://pstblog.com/2018/05/08/voting-power) covering voting power at the presidential level, but it's more comprehensive because it includes the often-ignored state level elections.  

# The Power Sharing Model

It seems to me that at least two things influence the political power of a voter:
 
1. Their ability to change election outcomes.  If there's no chance a voter will swing an election, there isn't much point in voting.
2. The power held by their elected officials.  If a voter's representatives can't influence policy, they're powerless.

So I build off these two concepts to come up with the voting power metric below.  The first step is to allocate potential power to each seat in the government.  I start out with an arbitrary 100 points of power, and allocate half to the federal government and half to the states.  The power at the federal level is then further subdivided between the President (25) and Congress (25), with the House and Senate dividing the congressional power evenly.  The other 50 points of power are divided between the states according to their fraction of the national population.  Each state's value is then split between the governor and state legislature just like at the federal level.  The end result is a potential power value for every seat of the state and federal government (judiciary excluded).

The second step is to calculate a realized voting power value for each seat.  Here's the equation:

`voting_power = seat_potential_power/percent_absolute_margin`

So the realized voting power of a seat increases as the vote margin approaches zero.  This means that closer an election is, the more powerful the voters.  One thing to note here that the voting power of a seat doesn't have a ceiling\* -- an election for state legislature could exceed the power of the presidential vote if the margin is close enough.  

\*Actually, there is a ceiling but it's just really high. For example, if an election is won by a single vote, voting_power = seat_potential_power\*(n/100), where n is the total number of voters in the election.   

# Summary Statistics

So after the theory above, what do these values look like if they're actually calculated out?  After a pretty tedious process, I was able to compile data for almost all the state and federal seats in the past election cycle (a cycle here is defined as the time for every seat to be replaced once).  Here's the distribution of voting power values overall and by seat:

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/dist.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/dist.png"></a>
	<figcaption>The overall distribution of voting power values.</figcaption>
</figure>

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/ind-dist.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/ind-dists.png"></a>
	<figcaption>The distribution of voting power values by seat.</figcaption>
</figure>

So looking at the overall distribution above, it's clear the values follow something more extreme than a lognormal distribution.  The individual distributions make it clear that the federal elections ouperform the state level elections with the exception of the governor's races.  

Here are the cumulative sums by office type:

<table>
  <thead>
    <tr>
      <th></th>
      <th>mean_abs_margin</th>
      <th>sum_power</th>
      <th>mean_dem_margin</th>
      <th>sum_voting_power</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>governor</th>
      <td>14.157078</td>
      <td>24.946323</td>
      <td>-3.274936</td>
      <td>10.740176</td>
    </tr>
    <tr>
      <th>president</th>
      <td>18.380372</td>
      <td>25.000000</td>
      <td>-3.674600</td>
      <td>9.040410</td>
    </tr>
    <tr>
      <th>ussenate</th>
      <td>21.055863</td>
      <td>12.500000</td>
      <td>-1.019923</td>
      <td>3.414887</td>
    </tr>
    <tr>
      <th>ushouse</th>
      <td>30.623423</td>
      <td>12.385057</td>
      <td>7.662104</td>
      <td>1.702852</td>
    </tr>
    <tr>
      <th>statesenate</th>
      <td>52.964234</td>
      <td>11.785348</td>
      <td>-6.824567</td>
      <td>1.048945</td>
    </tr>
    <tr>
      <th>statehouse</th>
      <td>54.282532</td>
      <td>11.780629</td>
      <td>-4.403811</td>
      <td>0.949632</td>
    </tr>
  </tbody>
</table>

Looking at the `sum_power` column table above, the governor, president US congress and state legislatures all have the same amounts of theoretical power (the small differences are due to missing election data).  But when you look at the realized `sum_voting_power` column, the high mean absolute margins erode the potential power for the state legislatures especially.  

It's also interesting to note that the governors have more cumulative power than the president in this model because they have closer elections.  This doesn't strike me as obviously false, but it's worth considering whether or not this reflects reality.

# Seat Level Results

Next I thought it would be interesting to show detailed maps of the results for each level of government.  It's pretty rare to see all the state legislative results mapped out, so enjoy!    

## President
<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/president.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/president.png"></a>
</figure>

## Senate
<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/ussenate.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/ussenate.png"></a>
</figure>


## House
<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/ushouse-margin.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/ushouse-margin.png"></a>
</figure>

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/ushouse-votepower.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/ushouse-votepower.png"></a>
</figure>

## Governor
<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/governors.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/governors.png"></a>
</figure>

## State House
Rare to see these, I never have. Include table of unopposed races here.   

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/statehouse-margin.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/statehouse-margin.png"></a>
</figure>

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/statehouse-votepower.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/statehouse-votepower.png"></a>
</figure>

## State Senate

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/statesenate-margin.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/statesenate-margin.png"></a>
</figure>

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/statesenate-votepower.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/statesenate-votepower.png"></a>
</figure>

## Combined Results
Main point is that statewide results overpower sub-state results.  

Include summary tables here? - Yes, one of overall state sums, and one of top offices by the top states. 

### State Level Results

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/statesum-votepower.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/statesum-votepower.png"></a>
</figure>

Here is a table with the sums by state:

<table>
  <thead>
    <tr>
      <th></th>
      <th>state_abbr</th>
      <th>state_fips</th>
      <th>voting_power</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>9</th>
      <td>FL</td>
      <td>12</td>
      <td>6.551916</td>
    </tr>
    <tr>
      <th>27</th>
      <td>NC</td>
      <td>37</td>
      <td>4.105122</td>
    </tr>
    <tr>
      <th>22</th>
      <td>MI</td>
      <td>26</td>
      <td>3.660639</td>
    </tr>
    <tr>
      <th>38</th>
      <td>PA</td>
      <td>42</td>
      <td>1.575222</td>
    </tr>
    <tr>
      <th>30</th>
      <td>NH</td>
      <td>33</td>
      <td>1.523800</td>
    </tr>
    <tr>
      <th>48</th>
      <td>WI</td>
      <td>55</td>
      <td>1.192909</td>
    </tr>
    <tr>
      <th>10</th>
      <td>GA</td>
      <td>13</td>
      <td>1.001493</td>
    </tr>
    <tr>
      <th>43</th>
      <td>TX</td>
      <td>48</td>
      <td>0.680421</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CA</td>
      <td>6</td>
      <td>0.521339</td>
    </tr>
    <tr>
      <th>23</th>
      <td>MN</td>
      <td>27</td>
      <td>0.513667</td>
    </tr>
    <tr>
      <th>35</th>
      <td>OH</td>
      <td>39</td>
      <td>0.431217</td>
    </tr>
    <tr>
      <th>45</th>
      <td>VA</td>
      <td>51</td>
      <td>0.422264</td>
    </tr>
    <tr>
      <th>34</th>
      <td>NY</td>
      <td>36</td>
      <td>0.364836</td>
    </tr>
    <tr>
      <th>33</th>
      <td>NV</td>
      <td>32</td>
      <td>0.306071</td>
    </tr>
    <tr>
      <th>3</th>
      <td>AZ</td>
      <td>4</td>
      <td>0.290053</td>
    </tr>
    <tr>
      <th>5</th>
      <td>CO</td>
      <td>8</td>
      <td>0.272018</td>
    </tr>
    <tr>
      <th>14</th>
      <td>IL</td>
      <td>17</td>
      <td>0.241070</td>
    </tr>
    <tr>
      <th>31</th>
      <td>NJ</td>
      <td>34</td>
      <td>0.231329</td>
    </tr>
    <tr>
      <th>44</th>
      <td>UT</td>
      <td>49</td>
      <td>0.208606</td>
    </tr>
    <tr>
      <th>24</th>
      <td>MO</td>
      <td>29</td>
      <td>0.207401</td>
    </tr>
    <tr>
      <th>12</th>
      <td>IA</td>
      <td>19</td>
      <td>0.185651</td>
    </tr>
    <tr>
      <th>15</th>
      <td>IN</td>
      <td>18</td>
      <td>0.182072</td>
    </tr>
    <tr>
      <th>47</th>
      <td>WA</td>
      <td>53</td>
      <td>0.173504</td>
    </tr>
    <tr>
      <th>6</th>
      <td>CT</td>
      <td>9</td>
      <td>0.163913</td>
    </tr>
    <tr>
      <th>37</th>
      <td>OR</td>
      <td>41</td>
      <td>0.131566</td>
    </tr>
    <tr>
      <th>16</th>
      <td>KS</td>
      <td>20</td>
      <td>0.127854</td>
    </tr>
    <tr>
      <th>40</th>
      <td>SC</td>
      <td>45</td>
      <td>0.127477</td>
    </tr>
    <tr>
      <th>21</th>
      <td>ME</td>
      <td>23</td>
      <td>0.124064</td>
    </tr>
    <tr>
      <th>17</th>
      <td>KY</td>
      <td>21</td>
      <td>0.106102</td>
    </tr>
    <tr>
      <th>20</th>
      <td>MD</td>
      <td>24</td>
      <td>0.105236</td>
    </tr>
    <tr>
      <th>32</th>
      <td>NM</td>
      <td>35</td>
      <td>0.104684</td>
    </tr>
    <tr>
      <th>49</th>
      <td>WV</td>
      <td>54</td>
      <td>0.101614</td>
    </tr>
    <tr>
      <th>18</th>
      <td>LA</td>
      <td>22</td>
      <td>0.094424</td>
    </tr>
    <tr>
      <th>0</th>
      <td>AK</td>
      <td>2</td>
      <td>0.092161</td>
    </tr>
    <tr>
      <th>26</th>
      <td>MT</td>
      <td>30</td>
      <td>0.087219</td>
    </tr>
    <tr>
      <th>1</th>
      <td>AL</td>
      <td>1</td>
      <td>0.086837</td>
    </tr>
    <tr>
      <th>42</th>
      <td>TN</td>
      <td>47</td>
      <td>0.083975</td>
    </tr>
    <tr>
      <th>36</th>
      <td>OK</td>
      <td>40</td>
      <td>0.076436</td>
    </tr>
    <tr>
      <th>19</th>
      <td>MA</td>
      <td>25</td>
      <td>0.065192</td>
    </tr>
    <tr>
      <th>25</th>
      <td>MS</td>
      <td>28</td>
      <td>0.054925</td>
    </tr>
    <tr>
      <th>29</th>
      <td>NE</td>
      <td>31</td>
      <td>0.044191</td>
    </tr>
    <tr>
      <th>28</th>
      <td>ND</td>
      <td>38</td>
      <td>0.042327</td>
    </tr>
    <tr>
      <th>2</th>
      <td>AR</td>
      <td>5</td>
      <td>0.041736</td>
    </tr>
    <tr>
      <th>41</th>
      <td>SD</td>
      <td>46</td>
      <td>0.038921</td>
    </tr>
    <tr>
      <th>8</th>
      <td>DE</td>
      <td>10</td>
      <td>0.036613</td>
    </tr>
    <tr>
      <th>39</th>
      <td>RI</td>
      <td>44</td>
      <td>0.033107</td>
    </tr>
    <tr>
      <th>13</th>
      <td>ID</td>
      <td>16</td>
      <td>0.028847</td>
    </tr>
    <tr>
      <th>46</th>
      <td>VT</td>
      <td>50</td>
      <td>0.021205</td>
    </tr>
    <tr>
      <th>11</th>
      <td>HI</td>
      <td>15</td>
      <td>0.019575</td>
    </tr>
    <tr>
      <th>50</th>
      <td>WY</td>
      <td>56</td>
      <td>0.012467</td>
    </tr>
    <tr>
      <th>7</th>
      <td>DC</td>
      <td>11</td>
      <td>0.001613</td>
    </tr>
  </tbody>
</table>

And here are the top offices within the top states.  Generally, governors or presidential votes are driving the scores, but not always:

<table>
  <thead>
    <tr>
      <th>state_abbr</th>
      <th>state_power</th>
      <th>office</th>
      <th>power</th>
      <th>min_abs_margin</th>
      <th>voting_power</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="6" valign="top">FL</th>
      <th>6.551916</th>
      <td>governor</td>
      <td>1.627555</td>
      <td>0.394900</td>
      <td>4.121436</td>
    </tr>
    <tr>
      <th></th>
      <td>president</td>
      <td>1.347584</td>
      <td>1.198626</td>
      <td>1.124274</td>
    </tr>
    <tr>
      <th></th>
      <td>ussenate</td>
      <td>0.125000</td>
      <td>0.122503</td>
      <td>1.036689</td>
    </tr>
    <tr>
      <th></th>
      <td>statehouse</td>
      <td>0.006796</td>
      <td>0.084434</td>
      <td>0.123028</td>
    </tr>
    <tr>
      <th></th>
      <td>ushouse</td>
      <td>0.028736</td>
      <td>0.874615</td>
      <td>0.111829</td>
    </tr>
    <tr>
      <th></th>
      <td>statesenate</td>
      <td>0.020388</td>
      <td>3.258565</td>
      <td>0.034659</td>
    </tr>
    <tr>
      <th rowspan="6" valign="top">NC</th>
      <th>4.105122</th>
      <td>governor</td>
      <td>0.793448</td>
      <td>0.218148</td>
      <td>3.637197</td>
    </tr>
    <tr>
      <th></th>
      <td>president</td>
      <td>0.697026</td>
      <td>3.655229</td>
      <td>0.190693</td>
    </tr>
    <tr>
      <th></th>
      <td>ushouse</td>
      <td>0.028736</td>
      <td>0.320108</td>
      <td>0.114202</td>
    </tr>
    <tr>
      <th></th>
      <td>ussenate</td>
      <td>0.125000</td>
      <td>1.564446</td>
      <td>0.101845</td>
    </tr>
    <tr>
      <th></th>
      <td>statehouse</td>
      <td>0.003313</td>
      <td>0.383575</td>
      <td>0.037828</td>
    </tr>
    <tr>
      <th></th>
      <td>statesenate</td>
      <td>0.007952</td>
      <td>0.890182</td>
      <td>0.023357</td>
    </tr>
    <tr>
      <th rowspan="6" valign="top">MI</th>
      <th>3.660639</th>
      <td>president</td>
      <td>0.743494</td>
      <td>0.223033</td>
      <td>3.333558</td>
    </tr>
    <tr>
      <th></th>
      <td>statesenate</td>
      <td>0.010072</td>
      <td>0.075871</td>
      <td>0.153072</td>
    </tr>
    <tr>
      <th></th>
      <td>governor</td>
      <td>0.763823</td>
      <td>9.567130</td>
      <td>0.079838</td>
    </tr>
    <tr>
      <th></th>
      <td>ushouse</td>
      <td>0.028736</td>
      <td>3.834388</td>
      <td>0.035380</td>
    </tr>
    <tr>
      <th></th>
      <td>statehouse</td>
      <td>0.003479</td>
      <td>0.593936</td>
      <td>0.030168</td>
    </tr>
    <tr>
      <th></th>
      <td>ussenate</td>
      <td>0.125000</td>
      <td>6.505602</td>
      <td>0.028623</td>
    </tr>
    <tr>
      <th rowspan="6" valign="top">PA</th>
      <th>1.575222</th>
      <td>president</td>
      <td>0.929368</td>
      <td>0.724270</td>
      <td>1.283180</td>
    </tr>
    <tr>
      <th></th>
      <td>ussenate</td>
      <td>0.125000</td>
      <td>1.432453</td>
      <td>0.096975</td>
    </tr>
    <tr>
      <th></th>
      <td>statehouse</td>
      <td>0.002416</td>
      <td>0.068476</td>
      <td>0.065791</td>
    </tr>
    <tr>
      <th></th>
      <td>governor</td>
      <td>0.978632</td>
      <td>17.072299</td>
      <td>0.057323</td>
    </tr>
    <tr>
      <th></th>
      <td>ushouse</td>
      <td>0.028736</td>
      <td>2.519118</td>
      <td>0.049276</td>
    </tr>
    <tr>
      <th></th>
      <td>statesenate</td>
      <td>0.009807</td>
      <td>2.724007</td>
      <td>0.022677</td>
    </tr>
    <tr>
      <th rowspan="6" valign="top">NH</th>
      <th>1.523800</th>
      <td>ussenate</td>
      <td>0.125000</td>
      <td>0.137592</td>
      <td>0.947011</td>
    </tr>
    <tr>
      <th></th>
      <td>president</td>
      <td>0.185874</td>
      <td>0.367596</td>
      <td>0.505647</td>
    </tr>
    <tr>
      <th></th>
      <td>statesenate</td>
      <td>0.002164</td>
      <td>0.061277</td>
      <td>0.040793</td>
    </tr>
    <tr>
      <th></th>
      <td>governor</td>
      <td>0.103652</td>
      <td>7.044083</td>
      <td>0.014715</td>
    </tr>
    <tr>
      <th></th>
      <td>statehouse</td>
      <td>0.000130</td>
      <td>0.137468</td>
      <td>0.010124</td>
    </tr>
    <tr>
      <th></th>
      <td>ushouse</td>
      <td>0.028736</td>
      <td>8.551431</td>
      <td>0.005511</td>
    </tr>
    <tr>
      <th rowspan="6" valign="top">WI</th>
      <th>1.192909</th>
      <td>president</td>
      <td>0.464684</td>
      <td>0.764343</td>
      <td>0.607952</td>
    </tr>
    <tr>
      <th></th>
      <td>governor</td>
      <td>0.444235</td>
      <td>1.093290</td>
      <td>0.406329</td>
    </tr>
    <tr>
      <th></th>
      <td>statesenate</td>
      <td>0.006745</td>
      <td>0.070027</td>
      <td>0.111116</td>
    </tr>
    <tr>
      <th></th>
      <td>ussenate</td>
      <td>0.125000</td>
      <td>3.361977</td>
      <td>0.048715</td>
    </tr>
    <tr>
      <th></th>
      <td>ushouse</td>
      <td>0.028736</td>
      <td>11.005491</td>
      <td>0.010840</td>
    </tr>
    <tr>
      <th></th>
      <td>statehouse</td>
      <td>0.002248</td>
      <td>2.667798</td>
      <td>0.007957</td>
    </tr>
    <tr>
      <th rowspan="6" valign="top">GA</th>
      <th>1.001493</th>
      <td>governor</td>
      <td>0.803830</td>
      <td>1.389146</td>
      <td>0.578650</td>
    </tr>
    <tr>
      <th></th>
      <td>ushouse</td>
      <td>0.028736</td>
      <td>0.149408</td>
      <td>0.231010</td>
    </tr>
    <tr>
      <th></th>
      <td>president</td>
      <td>0.743494</td>
      <td>5.131343</td>
      <td>0.144893</td>
    </tr>
    <tr>
      <th></th>
      <td>ussenate</td>
      <td>0.125000</td>
      <td>7.682710</td>
      <td>0.025361</td>
    </tr>
    <tr>
      <th></th>
      <td>statehouse</td>
      <td>0.002238</td>
      <td>0.902439</td>
      <td>0.013748</td>
    </tr>
    <tr>
      <th></th>
      <td>statesenate</td>
      <td>0.007192</td>
      <td>3.847239</td>
      <td>0.007831</td>
    </tr>
  </tbody>

<!-- <figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/avg-margin.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/avg-margin.png"></a>
</figure>

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/votepower-comp/sum-votepower.png"><img style="max-height:800px" src="{{ site.baseurl }}/images/votepower-comp/sum-votepower.png"></a>
</figure> -->


# Model Problems

Judiciary, local government are left out.
Power law distribution too extreme?  Maybe, maybe not.  
Past results aren't indicative of future.  The high power values might just be random variation, and not say anything intrinsic about a place.   
Too much influence for single election results.
Threshold for flipping control of house matters too.  This doesn't take that into account.   

# Conclusion


# References 




