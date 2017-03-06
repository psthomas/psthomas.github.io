---
layout: post
title: "Women's March and Tea Party, by the Numbers"
excerpt: "I compare the turnout for the Women's March and Tea Party by city and state."
#modified: 2016-02-22
tags: [pandas, python, d3.js, matplotlib, politics, data visualization]
comments: true
share: false

---

The Tea Party protests took the country by storm in 2009 and had an outsized impact on the legislative process.  The recent Women's March and associated movement could have a similar effect, so I was curious to see how the two compared in size and location.  Below, I look at the distribution and size of the marches, compare turnout by city, then look at the fraction of each state that attended protests.

<figure>
	<a href="{{ site.baseurl }}/images/march/output_13_0.png"><img src="{{ site.baseurl }}/images/march/output_13_0.png"></a>
</figure>

Overall, there were ten times more Women's Marchers (**4,157,678**) than Tea Party marchers (**310,960**).  Interestingly, both protests had a similar median number of marchers (**322** vs **450**), and the majority of the marchers attended protests sized in the **100s** or **1000s**.  This means that the Tea Party wasn't any more "grassroots" than the Women's March, and both were geographically distributed.  Finally, almost every state had a larger percentage of the population turnout for the Women's March, with Colorado leading the way at **2.9%**.

If the energy from the Women's March is put to use, it could have an even larger impact than the Tea Party.  We may be seeing the results in congress and town halls already.  


## Data Sources

Jeremy Pressman, Erica Chenoweth and others recently finished compiling all the Women's March [data](https://docs.google.com/spreadsheets/d/1xa0iLqYKz8x9Yc_rfhtmSOJQ2EGgeUVjvV4A8LsIaxY/htmlview?sle=true#gid=0) and 538 compiled [data](https://fivethirtyeight.com/features/tea-parties-appear-to-draw-at-least/) on the Tea Party protests a few years ago, so I used both those sources.  I got the state level population [data](https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=PEP_2015_PEPANNRES&src=pt) from the US Census, and the voter turnout [data](https://docs.google.com/spreadsheets/d/133Eb4qQmOxNvtesw2hdVns073R68EZx4SfCnP4IGQf8/htmlview?sle=true#gid=19) from David Wasserman.  All these sources are available in a zipped file [here](https://www.dropbox.com/s/4f2tccm0urnt97f/march_data.zip?dl=1).

All the code for this post is available in a Jupyter notebook [here](http://nbviewer.jupyter.org/gist/psthomas/79b61a107205a90b3660bb4649fb2672).


## Marchers by City

First, I look at this data by city.  The boxplot shows that the median march size was actually very similar between cities (**322** vs **450**).  The mean, however, was an order of magnitude higher for the Women's March (**6673**), and there are more outliers at the high end of the march size.  There were also ten times more Women's Marchers (**4,157,678**) than Tea Party marchers (**310,960**).  

<figure>
	<a href="{{ site.baseurl }}/images/march/output_8_0.png"><img src="{{ site.baseurl }}/images/march/output_8_0.png"></a>
</figure>



<div>
<table >
  <thead>
    <tr >
      <th></th>
      <th>march_num</th>
      <th>tea_num</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>623.000000</td>
      <td>344.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>6673.641091</td>
      <td>903.953488</td>
    </tr>
    <tr>
      <th>std</th>
      <td>42193.461677</td>
      <td>1308.635137</td>
    </tr>
    <tr>
      <th>min</th>
      <td>1.000000</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>80.750000</td>
      <td>200.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>322.500000</td>
      <td>450.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>1725.000000</td>
      <td>1000.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>725000.000000</td>
      <td>15000.000000</td>
    </tr>
  </tbody>
</table>
</div>


Below is an interactive scatter plot of the number of protesters in each city for each movement.  This is created using an outer join, so the assumption is that any cities not shared by both lists had marchers in one city and not the other.  

Any city above the 45 degree line had more Tea Party Marchers, and those below had more Women's Marchers.  These are log axes, so the cities do skew substantially towards the Women's march (especially the large ones).  


<iframe srcdoc="
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset=&quot;utf-8&quot;>
    <title>Zoom + Pan</title>
    <style>
    
    body {
      position: relative;
      width: 700px; /*960px*/
    }

    svg {font: 10px sans-serif;}

    rect {fill: #e5e5e5; }

    .label {
        font-size: 12px;
        /*stroke: #ddd;*/
        fill: #555;
    }

    .dot {
      /*stroke: #aaa;*/
      /*stroke: red;*/
      /*border: 1;*/
    }
    
    .dot:hover {fill-opacity: 0.4;}

    .axis path,
    .axis line {
      stroke: #f4f4f4;  /* black;*/
      fill: none; 
      stroke-width: 1px;
    }
    
    #main-tick{
      fill: none;
      stroke: #777;  
      stroke-width: 1px;
      opacity: 1;
    }

    .buttons {
      position: absolute;
      right: 30px;
      top: 30px;
    }
    button {
      font: 16px sans-serif;
      display: block;
      border-radius: 0px;
      width: 25px;
      /*outline: none;*/
      /*outline:0;*/
      background-color: white;
      border: none;
    }
    
    button:hover {
      background-image:none;
      background-color:#d5d5d5;
    }
    
    button:focus{ 
    /*outline-color: #ddd;
    outline:none;
    outline: 1;*/
    outline-color: #b5b5b5;
    }
    
    div.tooltip {
      position: absolute;
      padding: 5px;
      font: 12px sans-serif;
      background: white;
      border: 0px;
      border-radius: 0px;
      pointer-events:none;
    }

    </style>
    </head>
    <body>
    
    <div class=&quot;buttons&quot;>
      <button data-zoom=&quot;+0.5&quot;>+</button>  <!-- data-zoom=&quot;+1&quot; -->
      <button data-zoom=&quot;-0.5&quot;>-</button>
    </div>
    <script src=&quot;//d3js.org/d3.v3.min.js&quot;></script>
    <script>

    var margin = {top: 20, right: 20, bottom: 40, left: 40},
        width = 700 - margin.left - margin.right,
        height = 530 - margin.top - margin.bottom;
        
    var fmtTh = d3.format(&quot;,&quot;);

    var keys = {&quot;city&quot;: 0, &quot;march_num&quot;: 2, &quot;tea_num&quot;: 3, &quot;state&quot;: 1};
    var data = [[&quot;Accident&quot;,&quot;MD&quot;,54.0,0.0],[&quot;Adak&quot;,&quot;AK&quot;,10.0,0.0],[&quot;Adrian&quot;,&quot;MI&quot;,150.0,0.0],[&quot;Ajo&quot;,&quot;AZ&quot;,250.0,0.0],[&quot;Alameda&quot;,&quot;CA&quot;,8.0,0.0],[&quot;Alamosa&quot;,&quot;CO&quot;,350.0,0.0],[&quot;Albany&quot;,&quot;CA&quot;,500.0,0.0],[&quot;Albany&quot;,&quot;NY&quot;,7900.0,1000.0],[&quot;Albuquerque&quot;,&quot;NM&quot;,8400.0,1000.0],[&quot;Alexandria&quot;,&quot;VA&quot;,17.0,0.0],[&quot;Alliance&quot;,&quot;NE&quot;,125.0,0.0],[&quot;Almanor West&quot;,&quot;CA&quot;,4.0,0.0],[&quot;Alpine&quot;,&quot;TX&quot;,96.0,0.0],[&quot;Altoona&quot;,&quot;PA&quot;,0.0,0.0],[&quot;Amarillo&quot;,&quot;TX&quot;,645.0,0.0],[&quot;Amelia Island&quot;,&quot;FL&quot;,1000.15,0.0],[&quot;Anacortes&quot;,&quot;WA&quot;,1200.0,0.0],[&quot;Anchorage&quot;,&quot;AK&quot;,2900.0,1500.0],[&quot;Angola&quot;,&quot;IN&quot;,42.0,0.0],[&quot;Ann Arbor&quot;,&quot;MI&quot;,11000.0,200.0],[&quot;Annapolis&quot;,&quot;MD&quot;,1600.0,2750.0],[&quot;Annville&quot;,&quot;PA&quot;,30.0,0.0],[&quot;Appleton&quot;,&quot;WI&quot;,3.0,0.0],[&quot;Arden&quot;,&quot;DE&quot;,45.0,0.0],[&quot;Arlington&quot;,&quot;VA&quot;,0.0,0.0],[&quot;Asbury Park&quot;,&quot;NJ&quot;,6000.0,0.0],[&quot;Asheville&quot;,&quot;NC&quot;,8350.0,0.0],[&quot;Ashland&quot;,&quot;OR&quot;,11150.0,0.0],[&quot;Aspen&quot;,&quot;CO&quot;,560.0,0.0],[&quot;Astoria&quot;,&quot;OR&quot;,1435.0,100.0],[&quot;Athens&quot;,&quot;GA&quot;,2635.0,0.0],[&quot;Athens&quot;,&quot;OH&quot;,390.0,0.0],[&quot;Atlanta&quot;,&quot;GA&quot;,61350.0,15000.0],[&quot;Augusta&quot;,&quot;GA&quot;,600.0,1700.0],[&quot;Augusta&quot;,&quot;ME&quot;,7250.0,600.0],[&quot;Austin&quot;,&quot;TX&quot;,50550.0,1250.0],[&quot;Avalon&quot;,&quot;CA&quot;,44.0,0.0],[&quot;Bailey&quot;,&quot;CO&quot;,5.0,0.0],[&quot;Bainbridge Island&quot;,&quot;WA&quot;,267.5,0.0],[&quot;Bakersfield&quot;,&quot;CA&quot;,119.0,2650.0],[&quot;Baltimore&quot;,&quot;MD&quot;,5000.0,150.0],[&quot;Bandon&quot;,&quot;OR&quot;,70.0,0.0],[&quot;Bar Harbor&quot;,&quot;ME&quot;,52.5,0.0],[&quot;Bayfield&quot;,&quot;WI&quot;,427.0,0.0],[&quot;Beaufort&quot;,&quot;NC&quot;,11.0,0.0],[&quot;Beaumont&quot;,&quot;TX&quot;,300.0,0.0],[&quot;Beaver&quot;,&quot;PA&quot;,288.0,0.0],[&quot;Beaver Island&quot;,&quot;MI&quot;,20.0,0.0],[&quot;Bellingham&quot;,&quot;WA&quot;,5450.0,1500.0],[&quot;Bemidji&quot;,&quot;MN&quot;,362.5,0.0],[&quot;Bend&quot;,&quot;OR&quot;,3900.0,1200.0],[&quot;Bennington&quot;,&quot;VT&quot;,100.0,0.0],[&quot;Bentonville&quot;,&quot;AR&quot;,435.0,0.0],[&quot;Berkeley&quot;,&quot;CA&quot;,560.0,0.0],[&quot;Bethel&quot;,&quot;AK&quot;,70.0,0.0],[&quot;Bethlehem&quot;,&quot;CT&quot;,2.0,0.0],[&quot;Bethlehem&quot;,&quot;PA&quot;,518.0,275.0],[&quot;Bettendorf&quot;,&quot;IA&quot;,525.0,0.0],[&quot;Beverly Hills&quot;,&quot;CA&quot;,275.0,0.0],[&quot;Binghamton&quot;,&quot;NY&quot;,2450.0,0.0],[&quot;Birmingham&quot;,&quot;AL&quot;,7250.0,0.0],[&quot;Bishop&quot;,&quot;CA&quot;,600.0,0.0],[&quot;Bismarck&quot;,&quot;ND&quot;,500.0,0.0],[&quot;Black Mountain&quot;,&quot;NC&quot;,317.5,0.0],[&quot;Block Island&quot;,&quot;RI&quot;,70.0,0.0],[&quot;Bloomsburg&quot;,&quot;PA&quot;,50.0,0.0],[&quot;Bluff&quot;,&quot;UT&quot;,48.0,0.0],[&quot;Boise&quot;,&quot;ID&quot;,5000.0,2500.0],[&quot;Borrego Springs&quot;,&quot;CA&quot;,145.0,0.0],[&quot;Boston&quot;,&quot;MA&quot;,175000.0,2500.0],[&quot;Bozeman&quot;,&quot;MT&quot;,13.0,0.0],[&quot;Brattleboro&quot;,&quot;VT&quot;,225.0,0.0],[&quot;Breen&quot;,&quot;CO&quot;,1.0,0.0],[&quot;Bridgewater&quot;,&quot;MA&quot;,12.0,0.0],[&quot;Brighton&quot;,&quot;MI&quot;,300.0,0.0],[&quot;Brookings&quot;,&quot;OR&quot;,275.0,0.0],[&quot;Broomfield&quot;,&quot;CO&quot;,150.0,0.0],[&quot;Brownsville&quot;,&quot;TX&quot;,340.5,0.0],[&quot;Brunswick&quot;,&quot;ME&quot;,345.0,0.0],[&quot;Buffalo&quot;,&quot;NY&quot;,2725.0,150.0],[&quot;Burbank&quot;,&quot;CA&quot;,300.0,0.0],[&quot;Burns&quot;,&quot;OR&quot;,20.0,0.0],[&quot;Burnsville&quot;,&quot;NC&quot;,80.0,0.0],[&quot;Cambridge&quot;,&quot;MN&quot;,22.0,0.0],[&quot;Canton&quot;,&quot;NY&quot;,217.5,0.0],[&quot;Cape Henlopen&quot;,&quot;DE&quot;,250.0,0.0],[&quot;Carbondale&quot;,&quot;CO&quot;,425.0,0.0],[&quot;Carbondale&quot;,&quot;IL&quot;,1900.0,50.0],[&quot;Carmel&quot;,&quot;CA&quot;,20.0,0.0],[&quot;Casper&quot;,&quot;WY&quot;,835.0,0.0],[&quot;Cathlamet&quot;,&quot;WA&quot;,2.0,0.0],[&quot;Cedaredge&quot;,&quot;CO&quot;,0.0,0.0],[&quot;Champaign&quot;,&quot;IL&quot;,5360.0,400.0],[&quot;Charleston&quot;,&quot;SC&quot;,2000.0,2500.0],[&quot;Charleston&quot;,&quot;WV&quot;,2450.0,550.0],[&quot;Charlotte&quot;,&quot;NC&quot;,24500.0,1500.0],[&quot;Charlottesville&quot;,&quot;VA&quot;,2225.0,1500.0],[&quot;Chattanooga&quot;,&quot;TN&quot;,1900.0,2000.0],[&quot;Chelan&quot;,&quot;WA&quot;,431.5,0.0],[&quot;Chesapeake Bay&quot;,&quot;MD&quot;,1.0,0.0],[&quot;Cheyenne&quot;,&quot;WY&quot;,1560.0,300.0],[&quot;Chicago&quot;,&quot;IL&quot;,250000.0,2000.0],[&quot;Chico&quot;,&quot;CA&quot;,1900.0,500.0],[&quot;Chillicothe&quot;,&quot;OH&quot;,1000.0,400.0],[&quot;Christiansted&quot;,&quot;VI&quot;,440.0,0.0],[&quot;Cincinnati&quot;,&quot;OH&quot;,8150.0,3000.0],[&quot;Clare&quot;,&quot;MI&quot;,49.5,0.0],[&quot;Clarion&quot;,&quot;PA&quot;,82.5,0.0],[&quot;Clemson&quot;,&quot;SC&quot;,500.0,0.0],[&quot;Cleveland&quot;,&quot;OH&quot;,15000.0,1500.0],[&quot;Cobb&quot;,&quot;CA&quot;,2.0,0.0],[&quot;Cobleskill&quot;,&quot;NY&quot;,350.0,0.0],[&quot;Cody&quot;,&quot;WY&quot;,445.0,250.0],[&quot;College Station&quot;,&quot;TX&quot;,50.0,0.0],[&quot;Colorado Springs&quot;,&quot;CO&quot;,7000.0,2000.0],[&quot;Columbia&quot;,&quot;MD&quot;,112.5,0.0],[&quot;Columbia&quot;,&quot;MO&quot;,2721.8,0.0],[&quot;Columbia&quot;,&quot;SC&quot;,2450.0,2650.0],[&quot;Columbus&quot;,&quot;OH&quot;,2650.0,2700.0],[&quot;Compton&quot;,&quot;CA&quot;,40.0,0.0],[&quot;Concord&quot;,&quot;NH&quot;,4900.0,600.0],[&quot;Conover&quot;,&quot;WI&quot;,1.0,0.0],[&quot;Conway&quot;,&quot;NH&quot;,0.0,0.0],[&quot;Cooperstown&quot;,&quot;NY&quot;,200.0,0.0],[&quot;Coos Bay&quot;,&quot;OR&quot;,200.0,100.0],[&quot;Copper Harbor&quot;,&quot;MI&quot;,28.0,0.0],[&quot;Cordova&quot;,&quot;AK&quot;,111.0,0.0],[&quot;Corpus Christi&quot;,&quot;TX&quot;,24.0,500.0],[&quot;Cortez&quot;,&quot;CO&quot;,447.0,0.0],[&quot;Corvallis&quot;,&quot;OR&quot;,100.0,0.0],[&quot;Craftsbury&quot;,&quot;VT&quot;,15.0,0.0],[&quot;Crested Butte&quot;,&quot;CO&quot;,418.0,0.0],[&quot;Crestone&quot;,&quot;CO&quot;,1.0,0.0],[&quot;Cruz Bay&quot;,&quot;VI&quot;,200.0,0.0],[&quot;Crystal River&quot;,&quot;FL&quot;,7.0,0.0],[&quot;Dallas&quot;,&quot;TX&quot;,6350.0,4000.0],[&quot;Davis&quot;,&quot;WV&quot;,12.0,0.0],[&quot;Dayton&quot;,&quot;OH&quot;,3000.0,0.0],[&quot;Daytona Beach&quot;,&quot;FL&quot;,300.0,0.0],[&quot;Decorah&quot;,&quot;IA&quot;,890.0,0.0],[&quot;Delaware&quot;,&quot;OH&quot;,128.5,0.0],[&quot;Delhi&quot;,&quot;NY&quot;,85.0,0.0],[&quot;Deming&quot;,&quot;NM&quot;,47.5,0.0],[&quot;Denton&quot;,&quot;TX&quot;,2635.0,950.0],[&quot;Denver&quot;,&quot;CO&quot;,145000.0,5000.0],[&quot;Des Moines&quot;,&quot;IA&quot;,26000.0,0.0],[&quot;Detroit&quot;,&quot;MI&quot;,4000.0,0.0],[&quot;Douglas-Saugatuck&quot;,&quot;MI&quot;,1785.0,0.0],[&quot;Doylestown&quot;,&quot;PA&quot;,1450.0,0.0],[&quot;Driggs&quot;,&quot;ID&quot;,1000.0,0.0],[&quot;Dubuque&quot;,&quot;IA&quot;,400.0,0.0],[&quot;Duluth&quot;,&quot;MN&quot;,1590.0,600.0],[&quot;Durango&quot;,&quot;CO&quot;,560.0,0.0],[&quot;Eagle Pass&quot;,&quot;TX&quot;,30.0,0.0],[&quot;East Haddam&quot;,&quot;CT&quot;,500.0,0.0],[&quot;East Liberty&quot;,&quot;PA&quot;,2000.0,0.0],[&quot;East Millinocket&quot;,&quot;ME&quot;,4.0,0.0],[&quot;Eastport&quot;,&quot;ME&quot;,111.0,0.0],[&quot;Eastsound&quot;,&quot;WA&quot;,250.0,0.0],[&quot;Eau Claire&quot;,&quot;WI&quot;,250.0,0.0],[&quot;Eau Gallie&quot;,&quot;FL&quot;,0.0,0.0],[&quot;El Centro&quot;,&quot;CA&quot;,100.0,0.0],[&quot;El Morro&quot;,&quot;NM&quot;,30.0,0.0],[&quot;El Paso&quot;,&quot;TX&quot;,1450.0,0.0],[&quot;Elgin&quot;,&quot;IL&quot;,560.0,0.0],[&quot;Elizabethtown&quot;,&quot;NY&quot;,0.0,0.0],[&quot;Elkton&quot;,&quot;OR&quot;,0.0,0.0],[&quot;Ellensburg&quot;,&quot;WA&quot;,237.5,0.0],[&quot;Ellsworth&quot;,&quot;ME&quot;,60.0,0.0],[&quot;Ely&quot;,&quot;MN&quot;,50.0,0.0],[&quot;Encinitas&quot;,&quot;CA&quot;,50.0,0.0],[&quot;Enterprise&quot;,&quot;OR&quot;,0.0,0.0],[&quot;Ephrata&quot;,&quot;WA&quot;,250.0,0.0],[&quot;Erie&quot;,&quot;PA&quot;,3175.0,0.0],[&quot;Esperanza&quot;,&quot;PR&quot;,322.5,0.0],[&quot;Eugene&quot;,&quot;OR&quot;,8350.0,0.0],[&quot;Eureka&quot;,&quot;CA&quot;,6350.0,0.0],[&quot;Evanston&quot;,&quot;WY&quot;,1.0,0.0],[&quot;Evansville&quot;,&quot;IN&quot;,0.0,150.0],[&quot;Fairbanks&quot;,&quot;AK&quot;,2000.0,0.0],[&quot;Fairfax&quot;,&quot;CA&quot;,238.75,0.0],[&quot;Fairfield&quot;,&quot;IA&quot;,200.0,0.0],[&quot;Fairmont&quot;,&quot;WV&quot;,95.0,0.0],[&quot;Falmouth&quot;,&quot;MA&quot;,1000.0,0.0],[&quot;Fargo&quot;,&quot;ND&quot;,1900.0,0.0],[&quot;Fayetteville&quot;,&quot;AR&quot;,1000.0,700.0],[&quot;Fernandina Beach&quot;,&quot;FL&quot;,1135.0,0.0],[&quot;Flagstaff&quot;,&quot;AZ&quot;,1450.0,0.0],[&quot;Florence&quot;,&quot;OR&quot;,300.0,0.0],[&quot;Floyd&quot;,&quot;VA&quot;,200.0,0.0],[&quot;Forks&quot;,&quot;WA&quot;,45.0,0.0],[&quot;Fort Atkinson&quot;,&quot;WI&quot;,200.0,0.0],[&quot;Fort Bragg&quot;,&quot;CA&quot;,2635.0,0.0],[&quot;Fort Collins&quot;,&quot;CO&quot;,600.0,1000.0],[&quot;Fort Sumner&quot;,&quot;NM&quot;,0.0,0.0],[&quot;Fort Wayne&quot;,&quot;IN&quot;,1000.0,0.0],[&quot;Fort Worth&quot;,&quot;TX&quot;,5450.0,3750.0],[&quot;Francestown&quot;,&quot;NH&quot;,134.0,0.0],[&quot;Frederick&quot;,&quot;MD&quot;,1000.0,0.0],[&quot;Fredonia&quot;,&quot;NY&quot;,95.0,0.0],[&quot;Fresno&quot;,&quot;CA&quot;,2000.0,1000.0],[&quot;Friday Harbor&quot;,&quot;WA&quot;,1500.0,0.0],[&quot;Gainesville&quot;,&quot;FL&quot;,2000.0,1000.0],[&quot;Galesburg&quot;,&quot;IL&quot;,335.0,0.0],[&quot;Gila&quot;,&quot;NM&quot;,1.0,0.0],[&quot;Glens Falls&quot;,&quot;NY&quot;,1225.0,0.0],[&quot;Glenwood Springs&quot;,&quot;CO&quot;,100.0,100.0],[&quot;Gloucester&quot;,&quot;NJ&quot;,225.0,0.0],[&quot;Gold Canyon&quot;,&quot;AZ&quot;,0.0,0.0],[&quot;Gouldsboro&quot;,&quot;ME&quot;,35.0,0.0],[&quot;Grand Forks&quot;,&quot;ND&quot;,304.0,0.0],[&quot;Grand Junction&quot;,&quot;CO&quot;,4725.0,2000.0],[&quot;Grand Marais&quot;,&quot;MN&quot;,108.5,0.0],[&quot;Grand Rapids&quot;,&quot;MI&quot;,2725.0,0.0],[&quot;Grants Pass&quot;,&quot;OR&quot;,1.0,0.0],[&quot;Green Bay&quot;,&quot;WI&quot;,200.0,0.0],[&quot;Green Valley&quot;,&quot;AZ&quot;,451.25,0.0],[&quot;Greenfield&quot;,&quot;MA&quot;,2000.0,0.0],[&quot;Greensboro&quot;,&quot;NC&quot;,4350.0,0.0],[&quot;Greensburg&quot;,&quot;IN&quot;,55.0,0.0],[&quot;Greenville&quot;,&quot;NC&quot;,150.0,200.0],[&quot;Greenville&quot;,&quot;SC&quot;,2000.0,0.0],[&quot;Greenwood&quot;,&quot;IN&quot;,0.0,0.0],[&quot;Gross Pointe&quot;,&quot;MI&quot;,1213.65,0.0],[&quot;Gualala&quot;,&quot;CA&quot;,251.5,0.0],[&quot;Guilford&quot;,&quot;CT&quot;,32.0,0.0],[&quot;Gulfport&quot;,&quot;MS&quot;,484.05,0.0],[&quot;Gustavus&quot;,&quot;AK&quot;,105.0,0.0],[&quot;Hagatna&quot;,&quot;GM&quot;,200.0,0.0],[&quot;Haines&quot;,&quot;AK&quot;,160.0,0.0],[&quot;Halfway&quot;,&quot;OR&quot;,31.0,0.0],[&quot;Hana&quot;,&quot;HI&quot;,30.0,0.0],[&quot;Harrisburg&quot;,&quot;PA&quot;,994.05,0.0],[&quot;Harrisville&quot;,&quot;MI&quot;,5.0,0.0],[&quot;Hartford&quot;,&quot;CT&quot;,10000.0,3000.0],[&quot;Harwich&quot;,&quot;MA&quot;,200.0,0.0],[&quot;Hattiesburg&quot;,&quot;MS&quot;,0.0,0.0],[&quot;Helena&quot;,&quot;AR&quot;,2.0,0.0],[&quot;Helena&quot;,&quot;MT&quot;,10000.0,200.0],[&quot;Hemet&quot;,&quot;CA&quot;,98.0,0.0],[&quot;Hilldale&quot;,&quot;UT&quot;,1.0,0.0],[&quot;Hillsboro&quot;,&quot;WI&quot;,0.0,0.0],[&quot;Hillsborough&quot;,&quot;NC&quot;,1010.0,0.0],[&quot;Hilo&quot;,&quot;HI&quot;,1815.0,0.0],[&quot;Holden Village&quot;,&quot;WA&quot;,49.5,0.0],[&quot;Homer&quot;,&quot;AK&quot;,900.0,0.0],[&quot;Honolulu (Oahu) HI&quot;,&quot;HI&quot;,5250.0,0.0],[&quot;Hood River&quot;,&quot;OR&quot;,200.0,0.0],[&quot;Hospital Ward&quot;,&quot;CA&quot;,5.0,0.0],[&quot;Houghton&quot;,&quot;MI&quot;,500.0,0.0],[&quot;Houlton&quot;,&quot;ME&quot;,47.5,0.0],[&quot;Houston&quot;,&quot;TX&quot;,21434.15,2000.0],[&quot;Howard County&quot;,&quot;MD&quot;,112.5,0.0],[&quot;Hudson&quot;,&quot;NY&quot;,2450.0,0.0],[&quot;Huntsville&quot;,&quot;AL&quot;,95.0,2000.0],[&quot;Huron&quot;,&quot;SD&quot;,12.0,0.0],[&quot;Idaho Falls&quot;,&quot;ID&quot;,500.0,0.0],[&quot;Idyllwild&quot;,&quot;CA&quot;,0.0,0.0],[&quot;Indiana&quot;,&quot;PA&quot;,150.0,0.0],[&quot;Indianapolis&quot;,&quot;IN&quot;,6700.0,3625.0],[&quot;Inverness&quot;,&quot;CA&quot;,5.0,0.0],[&quot;Iowa City&quot;,&quot;IA&quot;,1000.0,300.0],[&quot;Isla Vista&quot;,&quot;CA&quot;,500.0,0.0],[&quot;Issaquah&quot;,&quot;WA&quot;,56.0,0.0],[&quot;Ithaca&quot;,&quot;NY&quot;,8900.0,0.0],[&quot;Jackson&quot;,&quot;MS&quot;,2662.5,2500.0],[&quot;Jackson&quot;,&quot;NH&quot;,300.0,0.0],[&quot;Jackson Hole&quot;,&quot;WY&quot;,1000.0,0.0],[&quot;Jacksonville&quot;,&quot;FL&quot;,2450.0,4500.0],[&quot;Jefferson City&quot;,&quot;MO&quot;,6.5,200.0],[&quot;Jerome&quot;,&quot;AZ&quot;,92.5,0.0],[&quot;Jonesborough&quot;,&quot;TN&quot;,1000.0,0.0],[&quot;Joseph&quot;,&quot;OR&quot;,310.0,0.0],[&quot;June Lake&quot;,&quot;CA&quot;,21.0,0.0],[&quot;Juneau&quot;,&quot;AK&quot;,1000.0,0.0],[&quot;Kahului&quot;,&quot;HI&quot;,3075.0,250.0],[&quot;Kalamazoo&quot;,&quot;MI&quot;,1450.0,0.0],[&quot;Kanab&quot;,&quot;UT&quot;,175.0,0.0],[&quot;Kansas City&quot;,&quot;MO&quot;,7250.0,1000.0],[&quot;Kauai&quot;,&quot;HI&quot;,0.0,0.0],[&quot;Kaunakakai (Molokai)&quot;,&quot;HI&quot;,200.0,0.0],[&quot;Kawaihae&quot;,&quot;HI&quot;,50.0,0.0],[&quot;Keene&quot;,&quot;NH&quot;,404.75,0.0],[&quot;Kennebunk&quot;,&quot;ME&quot;,1000.0,0.0],[&quot;Kent&quot;,&quot;CT&quot;,190.0,0.0],[&quot;Kent&quot;,&quot;OH&quot;,100.0,0.0],[&quot;Ketchikan&quot;,&quot;AK&quot;,175.0,0.0],[&quot;Ketchum&quot;,&quot;ID&quot;,1067.5,0.0],[&quot;Key West&quot;,&quot;FL&quot;,3225.0,0.0],[&quot;Killington&quot;,&quot;VT&quot;,81.5,0.0],[&quot;King's Beach&quot;,&quot;CA&quot;,635.0,0.0],[&quot;Kingston&quot;,&quot;WA&quot;,60.0,0.0],[&quot;Klamath Falls&quot;,&quot;OR&quot;,250.0,0.0],[&quot;Knoxville&quot;,&quot;TN&quot;,3350.0,1700.0],[&quot;Kodiak&quot;,&quot;AK&quot;,364.25,0.0],[&quot;Kona&quot;,&quot;HI&quot;,3225.0,0.0],[&quot;Kotzebue&quot;,&quot;AK&quot;,35.5,0.0],[&quot;La Crosse&quot;,&quot;WI&quot;,113.0,0.0],[&quot;La Grande&quot;,&quot;OR&quot;,177.0,0.0],[&quot;Lafayette&quot;,&quot;CO&quot;,89.0,0.0],[&quot;Lafayette&quot;,&quot;IN&quot;,890.0,0.0],[&quot;Laguna Beach&quot;,&quot;CA&quot;,3725.0,0.0],[&quot;Lake Havasu City&quot;,&quot;AZ&quot;,35.0,0.0],[&quot;Lakeside&quot;,&quot;OH&quot;,300.0,0.0],[&quot;Lakeville&quot;,&quot;CT&quot;,92.5,0.0],[&quot;Lamoni&quot;,&quot;IA&quot;,24.0,0.0],[&quot;Lancaster&quot;,&quot;NH&quot;,400.0,0.0],[&quot;Lancaster&quot;,&quot;PA&quot;,1010.0,400.0],[&quot;Lander&quot;,&quot;WY&quot;,417.5,0.0],[&quot;Langley&quot;,&quot;WA&quot;,1245.0,0.0],[&quot;Lansdale&quot;,&quot;PA&quot;,3.0,0.0],[&quot;Lansing&quot;,&quot;MI&quot;,17900.0,4500.0],[&quot;Laramie&quot;,&quot;WY&quot;,0.0,0.0],[&quot;Las Cruces&quot;,&quot;NM&quot;,785.0,0.0],[&quot;Las Vegas&quot;,&quot;NM&quot;,50.0,0.0],[&quot;Las Vegas&quot;,&quot;NV&quot;,8950.0,500.0],[&quot;Leonia&quot;,&quot;NJ&quot;,190.0,0.0],[&quot;Lewes&quot;,&quot;DE&quot;,250.0,0.0],[&quot;Lewis&quot;,&quot;NY&quot;,227.1,0.0],[&quot;Lewisburg&quot;,&quot;PA&quot;,175.0,0.0],[&quot;Lexington&quot;,&quot;KY&quot;,7250.0,0.0],[&quot;Lihue (Kauai) HI&quot;,&quot;HI&quot;,1500.0,0.0],[&quot;Lilly&quot;,&quot;PA&quot;,4.0,0.0],[&quot;Lincoln&quot;,&quot;NE&quot;,2900.0,0.0],[&quot;Little Rock&quot;,&quot;AR&quot;,7000.0,500.0],[&quot;Logan&quot;,&quot;UT&quot;,75.0,0.0],[&quot;Lompoc&quot;,&quot;CA&quot;,100.0,0.0],[&quot;Longview&quot;,&quot;WA&quot;,200.0,0.0],[&quot;Longville&quot;,&quot;MN&quot;,67.0,0.0],[&quot;Los Angeles&quot;,&quot;CA&quot;,447500.0,0.0],[&quot;Louisville&quot;,&quot;KY&quot;,5000.0,1000.0],[&quot;Loup City&quot;,&quot;NE&quot;,125.0,0.0],[&quot;Lovell&quot;,&quot;ME&quot;,2.0,0.0],[&quot;Lovettsville&quot;,&quot;VA&quot;,5.0,0.0],[&quot;Lubbock&quot;,&quot;TX&quot;,642.5,0.0],[&quot;Lubec&quot;,&quot;ME&quot;,95.0,0.0],[&quot;Lyons&quot;,&quot;CO&quot;,27.5,0.0],[&quot;Madison&quot;,&quot;WI&quot;,86250.0,5000.0],[&quot;Manchester&quot;,&quot;VT&quot;,50.0,0.0],[&quot;Mankato&quot;,&quot;MN&quot;,95.0,200.0],[&quot;Marfa&quot;,&quot;TX&quot;,76.0,0.0],[&quot;Marina&quot;,&quot;CA&quot;,0.0,0.0],[&quot;Marquette&quot;,&quot;MI&quot;,470.0,0.0],[&quot;Marshall&quot;,&quot;MN&quot;,2.0,0.0],[&quot;Martha's Vineyard&quot;,&quot;MA&quot;,100.0,0.0],[&quot;Maryville&quot;,&quot;IL&quot;,45.0,0.0],[&quot;Mayaguez&quot;,&quot;PR&quot;,0.0,0.0],[&quot;McCall&quot;,&quot;ID&quot;,112.5,0.0],[&quot;McMinnville&quot;,&quot;OR&quot;,1015.0,0.0],[&quot;Melbourne\/Brevard County&quot;,&quot;FL&quot;,500.0,0.0],[&quot;Memphis&quot;,&quot;TN&quot;,5700.0,1000.0],[&quot;Menomonie&quot;,&quot;WI&quot;,312.5,0.0],[&quot;Mentone&quot;,&quot;AL&quot;,60.0,0.0],[&quot;Merrill&quot;,&quot;MI&quot;,0.0,0.0],[&quot;Miami&quot;,&quot;FL&quot;,16750.0,0.0],[&quot;Miami Beach&quot;,&quot;FL&quot;,0.0,0.0],[&quot;Midland&quot;,&quot;MI&quot;,400.0,0.0],[&quot;Midland&quot;,&quot;TX&quot;,75.0,0.0],[&quot;Midway Atoll&quot;,&quot;--&quot;,6.0,0.0],[&quot;Miles City&quot;,&quot;MT&quot;,500.0,0.0],[&quot;Milford&quot;,&quot;CT&quot;,120.0,0.0],[&quot;Milhelm&quot;,&quot;PA&quot;,50.0,0.0],[&quot;Milwaukee&quot;,&quot;WI&quot;,1000.0,80.0],[&quot;Minneapolis&quot;,&quot;MN&quot;,0.0,0.0],[&quot;Minocqua&quot;,&quot;WI&quot;,300.0,0.0],[&quot;Minturn&quot;,&quot;CO&quot;,6.0,0.0],[&quot;Missoula&quot;,&quot;MT&quot;,100.0,500.0],[&quot;Mitchell&quot;,&quot;IN&quot;,19.0,0.0],[&quot;Moab&quot;,&quot;UT&quot;,200.0,0.0],[&quot;Mobile&quot;,&quot;AL&quot;,945.0,1000.0],[&quot;Modesto&quot;,&quot;CA&quot;,945.0,400.0],[&quot;Monhegan Island&quot;,&quot;ME&quot;,22.0,0.0],[&quot;Monterey Bay&quot;,&quot;CA&quot;,0.0,0.0],[&quot;Montpelier&quot;,&quot;VT&quot;,17250.0,500.0],[&quot;Mooresville&quot;,&quot;NC&quot;,70.0,0.0],[&quot;Mora&quot;,&quot;NM&quot;,1.0,0.0],[&quot;Morganton&quot;,&quot;NC&quot;,545.0,0.0],[&quot;Morris&quot;,&quot;MN&quot;,250.0,0.0],[&quot;Moscow&quot;,&quot;ID&quot;,2500.0,100.0],[&quot;Mount Vernon&quot;,&quot;OH&quot;,25.0,0.0],[&quot;Mount Vernon&quot;,&quot;WA&quot;,920.0,0.0],[&quot;Mt. Laurel&quot;,&quot;NJ&quot;,20.0,0.0],[&quot;Mt. Shasta&quot;,&quot;CA&quot;,400.0,0.0],[&quot;Murfreesboro&quot;,&quot;TN&quot;,0.0,0.0],[&quot;Murray&quot;,&quot;KY&quot;,700.0,0.0],[&quot;Nacogdoches&quot;,&quot;TX&quot;,250.0,0.0],[&quot;Nantucket&quot;,&quot;MA&quot;,400.0,0.0],[&quot;Napa&quot;,&quot;CA&quot;,3000.0,50.0],[&quot;Naples&quot;,&quot;FL&quot;,3625.0,3000.0],[&quot;Nashville&quot;,&quot;TN&quot;,17250.0,2900.0],[&quot;Nebraska City&quot;,&quot;NE&quot;,3.0,0.0],[&quot;Nederland&quot;,&quot;CO&quot;,27.5,0.0],[&quot;Nevada City&quot;,&quot;CA&quot;,100.0,0.0],[&quot;New Bern&quot;,&quot;NC&quot;,480.0,1200.0],[&quot;New Haven&quot;,&quot;CT&quot;,200.0,1000.0],[&quot;New Orleans&quot;,&quot;LA&quot;,10600.0,0.0],[&quot;New Smyrna Beach&quot;,&quot;FL&quot;,1000.0,0.0],[&quot;New York&quot;,&quot;NY&quot;,445000.0,3500.0],[&quot;Newark&quot;,&quot;DE&quot;,1090.0,0.0],[&quot;Newark&quot;,&quot;NJ&quot;,1000.0,50.0],[&quot;Newport&quot;,&quot;OR&quot;,1500.0,0.0],[&quot;Nome&quot;,&quot;AK&quot;,90.0,0.0],[&quot;Norfolk&quot;,&quot;VA&quot;,2360.0,0.0],[&quot;Northampton&quot;,&quot;MA&quot;,2725.0,0.0],[&quot;Oak Ridge&quot;,&quot;TN&quot;,495.0,0.0],[&quot;Oakhurst&quot;,&quot;CA&quot;,200.5,0.0],[&quot;Oakland&quot;,&quot;CA&quot;,100000.0,50.0],[&quot;Ocala&quot;,&quot;FL&quot;,200.0,1000.0],[&quot;Ocean City&quot;,&quot;MD&quot;,380.0,0.0],[&quot;Ocean Shores&quot;,&quot;WA&quot;,175.0,0.0],[&quot;Ocracoke&quot;,&quot;NC&quot;,114.0,0.0],[&quot;Ogden&quot;,&quot;UT&quot;,250.0,0.0],[&quot;Oklahoma City&quot;,&quot;OK&quot;,9250.0,4500.0],[&quot;Old Saybrook&quot;,&quot;CT&quot;,890.0,0.0],[&quot;Olympia&quot;,&quot;WA&quot;,10000.0,4500.0],[&quot;Omaha&quot;,&quot;NE&quot;,14700.0,150.0],[&quot;Oneonta&quot;,&quot;NY&quot;,500.0,0.0],[&quot;Onley&quot;,&quot;VA&quot;,50.0,0.0],[&quot;Ontario&quot;,&quot;CA&quot;,200.0,0.0],[&quot;Orange County&quot;,&quot;CA&quot;,0.0,0.0],[&quot;Orcas Island&quot;,&quot;WA&quot;,200.0,0.0],[&quot;Orford&quot;,&quot;NH&quot;,7.0,0.0],[&quot;Orlando&quot;,&quot;FL&quot;,5250.0,0.0],[&quot;Owensboro&quot;,&quot;KY&quot;,22.5,0.0],[&quot;Oxford&quot;,&quot;MS&quot;,450.0,0.0],[&quot;Pacifica&quot;,&quot;CA&quot;,1200.0,0.0],[&quot;Palm Desert&quot;,&quot;CA&quot;,1000.0,0.0],[&quot;Palm Springs&quot;,&quot;CA&quot;,250.0,1000.0],[&quot;Palmdale&quot;,&quot;CA&quot;,24.0,0.0],[&quot;Palmer&quot;,&quot;AK&quot;,657.35,0.0],[&quot;Panama City&quot;,&quot;FL&quot;,500.0,0.0],[&quot;Paoli&quot;,&quot;IN&quot;,67.0,0.0],[&quot;Paonia&quot;,&quot;CO&quot;,40.0,0.0],[&quot;Paradox&quot;,&quot;NY&quot;,3.0,0.0],[&quot;Park City&quot;,&quot;UT&quot;,6350.0,0.0],[&quot;Pasadena&quot;,&quot;CA&quot;,1040.0,0.0],[&quot;Pence&quot;,&quot;WI&quot;,1.0,0.0],[&quot;Pendelton&quot;,&quot;OR&quot;,526.25,0.0],[&quot;Pensacola&quot;,&quot;FL&quot;,2000.0,500.0],[&quot;Pentwater&quot;,&quot;MI&quot;,2.0,0.0],[&quot;Peoria&quot;,&quot;IL&quot;,1725.0,500.0],[&quot;Pequannock Township&quot;,&quot;NJ&quot;,890.0,0.0],[&quot;Peterborough&quot;,&quot;NH&quot;,55.0,0.0],[&quot;Petersburg&quot;,&quot;AK&quot;,65.0,0.0],[&quot;Philadelphia&quot;,&quot;PA&quot;,50000.0,200.0],[&quot;Phoenix&quot;,&quot;AZ&quot;,22250.0,5000.0],[&quot;Pierre&quot;,&quot;SD&quot;,132.5,0.0],[&quot;Pikeville&quot;,&quot;KY&quot;,100.0,0.0],[&quot;Pinedale&quot;,&quot;WY&quot;,100.0,0.0],[&quot;Pittsburgh&quot;,&quot;PA&quot;,25000.0,0.0],[&quot;Pittsfield&quot;,&quot;MA&quot;,1500.0,0.0],[&quot;Plattsburgh&quot;,&quot;NY&quot;,415.1,100.0],[&quot;Plymouth&quot;,&quot;WI&quot;,200.0,0.0],[&quot;Pocatello&quot;,&quot;ID&quot;,1200.0,650.0],[&quot;Point Reyes Station&quot;,&quot;CA&quot;,60.0,0.0],[&quot;Pompton Plains&quot;,&quot;NJ&quot;,0.0,0.0],[&quot;Port Angeles&quot;,&quot;WA&quot;,150.0,0.0],[&quot;Port Jefferson&quot;,&quot;NY&quot;,2000.0,0.0],[&quot;Port Jervis&quot;,&quot;NY&quot;,417.5,0.0],[&quot;Port Orford&quot;,&quot;OR&quot;,290.0,0.0],[&quot;Port Townsend&quot;,&quot;WA&quot;,615.0,0.0],[&quot;Portales&quot;,&quot;NM&quot;,50.0,0.0],[&quot;Portland&quot;,&quot;ME&quot;,10000.0,0.0],[&quot;Portland&quot;,&quot;OR&quot;,83557.5,1000.0],[&quot;Portsmouth&quot;,&quot;NH&quot;,3900.0,200.0],[&quot;Potsdam&quot;,&quot;NY&quot;,20.0,0.0],[&quot;Poughkeepsie&quot;,&quot;NY&quot;,5672.2,0.0],[&quot;Prescott&quot;,&quot;AZ&quot;,1200.0,2000.0],[&quot;Providence&quot;,&quot;RI&quot;,5900.0,2000.0],[&quot;Provincetown&quot;,&quot;MA&quot;,300.0,0.0],[&quot;Quincy&quot;,&quot;CA&quot;,77.5,0.0],[&quot;Raleigh&quot;,&quot;NC&quot;,18350.0,1200.0],[&quot;Rapid City&quot;,&quot;SD&quot;,1450.0,1000.0],[&quot;Reading&quot;,&quot;PA&quot;,257.5,150.0],[&quot;Red Bank&quot;,&quot;NJ&quot;,290.0,0.0],[&quot;Redding&quot;,&quot;CA&quot;,300.0,0.0],[&quot;Redondo Beach&quot;,&quot;CA&quot;,2000.0,0.0],[&quot;Redwood City&quot;,&quot;CA&quot;,2500.0,0.0],[&quot;Reno&quot;,&quot;NV&quot;,10000.0,200.0],[&quot;Richland&quot;,&quot;WA&quot;,1675.0,0.0],[&quot;Richmond&quot;,&quot;VA&quot;,2000.0,3000.0],[&quot;Ridgecrest&quot;,&quot;CA&quot;,190.0,0.0],[&quot;Ridgway&quot;,&quot;CO&quot;,100.0,0.0],[&quot;Riegelsville&quot;,&quot;PA&quot;,185.0,0.0],[&quot;Riverside&quot;,&quot;CA&quot;,4000.0,0.0],[&quot;Roanoke&quot;,&quot;VA&quot;,3675.0,0.0],[&quot;Rochester&quot;,&quot;MN&quot;,780.0,0.0],[&quot;Rochester&quot;,&quot;NY&quot;,1725.0,750.0],[&quot;Rock Springs&quot;,&quot;WY&quot;,105.0,0.0],[&quot;Rockford&quot;,&quot;IL&quot;,1000.0,200.0],[&quot;Romney&quot;,&quot;WV&quot;,40.0,0.0],[&quot;Roswell&quot;,&quot;NM&quot;,2.0,0.0],[&quot;Roxbury&quot;,&quot;CT&quot;,57.5,0.0],[&quot;Sacramento&quot;,&quot;CA&quot;,28100.0,3500.0],[&quot;Sag Harbor&quot;,&quot;NY&quot;,250.0,0.0],[&quot;Salem&quot;,&quot;OR&quot;,2440.0,1500.0],[&quot;Salem&quot;,&quot;WI&quot;,2.0,0.0],[&quot;Salida&quot;,&quot;CO&quot;,45.0,0.0],[&quot;Salinas&quot;,&quot;CA&quot;,80.0,0.0],[&quot;Salisbury&quot;,&quot;CT&quot;,305.3,0.0],[&quot;Salt Lake City&quot;,&quot;UT&quot;,8800.0,1500.0],[&quot;San Anselmo&quot;,&quot;CA&quot;,4.0,0.0],[&quot;San Antonio&quot;,&quot;TX&quot;,2175.0,4500.0],[&quot;San Bernardino&quot;,&quot;CA&quot;,80.0,100.0],[&quot;San Clemente&quot;,&quot;CA&quot;,150.0,0.0],[&quot;San Diego&quot;,&quot;CA&quot;,34500.0,500.0],[&quot;San Francisco&quot;,&quot;CA&quot;,154000.0,500.0],[&quot;San Jose&quot;,&quot;CA&quot;,31750.0,1000.0],[&quot;San Juan&quot;,&quot;PR&quot;,290.0,0.0],[&quot;San Juan Island&quot;,&quot;WA&quot;,0.0,0.0],[&quot;San Leandro&quot;,&quot;CA&quot;,0.0,0.0],[&quot;San Luis Obispo&quot;,&quot;CA&quot;,8350.0,0.0],[&quot;San Marcos&quot;,&quot;CA&quot;,6150.0,0.0],[&quot;San Rafael&quot;,&quot;CA&quot;,500.0,0.0],[&quot;Sandpoint&quot;,&quot;ID&quot;,890.0,0.0],[&quot;Sandy&quot;,&quot;OR&quot;,0.0,0.0],[&quot;Sanford&quot;,&quot;ME&quot;,115.0,0.0],[&quot;Santa Ana&quot;,&quot;CA&quot;,22250.0,1000.0],[&quot;Santa Barbara&quot;,&quot;CA&quot;,6350.0,0.0],[&quot;Santa Cruz&quot;,&quot;CA&quot;,11150.0,0.0],[&quot;Santa Fe&quot;,&quot;NM&quot;,13150.0,0.0],[&quot;Santa Rosa&quot;,&quot;CA&quot;,5000.0,500.0],[&quot;Santurce&quot;,&quot;PR&quot;,0.0,0.0],[&quot;Sarasota&quot;,&quot;FL&quot;,8625.0,0.0],[&quot;Saugatuck&quot;,&quot;MI&quot;,1010.0,0.0],[&quot;Sault Ste Marie&quot;,&quot;MI&quot;,40.0,0.0],[&quot;Sausalito&quot;,&quot;CA&quot;,3.0,0.0],[&quot;Savannah&quot;,&quot;GA&quot;,1000.0,0.0],[&quot;Saxaphaw&quot;,&quot;NC&quot;,80.0,0.0],[&quot;Seaside&quot;,&quot;CA&quot;,1450.0,0.0],[&quot;Seattle&quot;,&quot;WA&quot;,133750.0,1100.0],[&quot;Sedona&quot;,&quot;AZ&quot;,1000.0,0.0],[&quot;Seldovia&quot;,&quot;AK&quot;,41.0,0.0],[&quot;Selingsgrove&quot;,&quot;PA&quot;,119.0,0.0],[&quot;Seneca Falls&quot;,&quot;NY&quot;,10000.0,0.0],[&quot;Sequim&quot;,&quot;WA&quot;,390.0,0.0],[&quot;Seward&quot;,&quot;AK&quot;,62.0,0.0],[&quot;Sharon&quot;,&quot;PA&quot;,700.0,0.0],[&quot;Sheboygan&quot;,&quot;WI&quot;,390.0,0.0],[&quot;Show Low&quot;,&quot;AZ&quot;,1.0,0.0],[&quot;Shreveport\/Bossier&quot;,&quot;LA&quot;,560.0,0.0],[&quot;Sicklerville&quot;,&quot;NJ&quot;,225.0,0.0],[&quot;Silver City&quot;,&quot;NM&quot;,500.0,0.0],[&quot;Silverton&quot;,&quot;CO&quot;,50.0,0.0],[&quot;Sioux Falls&quot;,&quot;SD&quot;,3300.0,3000.0],[&quot;Sitka&quot;,&quot;AK&quot;,700.0,12.0],[&quot;Skagway&quot;,&quot;AK&quot;,122.0,0.0],[&quot;Skykomish&quot;,&quot;WA&quot;,8.0,0.0],[&quot;Soldotna&quot;,&quot;AK&quot;,261.0,0.0],[&quot;Sonoma&quot;,&quot;CA&quot;,3000.0,0.0],[&quot;South Bend&quot;,&quot;IN&quot;,1450.0,0.0],[&quot;South Lake Tahoe&quot;,&quot;CA\/NV&quot;,590.0,0.0],[&quot;South Orange&quot;,&quot;NJ&quot;,2000.0,0.0],[&quot;Southborough&quot;,&quot;MA&quot;,50.0,0.0],[&quot;Spokane&quot;,&quot;WA&quot;,7600.0,2300.0],[&quot;Springfield&quot;,&quot;IL&quot;,1000.0,400.0],[&quot;Springfield&quot;,&quot;MA&quot;,40.0,0.0],[&quot;Springfield&quot;,&quot;MO&quot;,2000.0,0.0],[&quot;Springfield&quot;,&quot;OH&quot;,5.0,0.0],[&quot;St. Augustine&quot;,&quot;FL&quot;,1450.0,0.0],[&quot;St. Cloud&quot;,&quot;MN&quot;,40.0,450.0],[&quot;St. Croix&quot;,&quot;VI&quot;,250.0,0.0],[&quot;St. George&quot;,&quot;UT&quot;,1323.75,0.0],[&quot;St. John&quot;,&quot;VA&quot;,0.0,0.0],[&quot;St. John&quot;,&quot;VI&quot;,60.0,0.0],[&quot;St. Johnsbury&quot;,&quot;VT&quot;,60.0,0.0],[&quot;St. Joseph&quot;,&quot;MI&quot;,60.0,0.0],[&quot;St. Louis&quot;,&quot;MO&quot;,14500.0,2000.0],[&quot;St. Mary of the Woods&quot;,&quot;IN&quot;,190.0,0.0],[&quot;St. Mary's City&quot;,&quot;MD&quot;,10.0,0.0],[&quot;St. Paul\/Minneapolis&quot;,&quot;MN&quot;,94500.0,0.0],[&quot;St. Petersburg&quot;,&quot;FL&quot;,20000.0,0.0],[&quot;St. Thomas&quot;,&quot;VI&quot;,0.0,0.0],[&quot;Stamford&quot;,&quot;CT&quot;,5000.0,0.0],[&quot;Stanley&quot;,&quot;ID&quot;,30.0,0.0],[&quot;State College&quot;,&quot;PA&quot;,335.0,0.0],[&quot;Statesboro&quot;,&quot;GA&quot;,200.0,0.0],[&quot;Staunton&quot;,&quot;VA&quot;,125.0,100.0],[&quot;Steamboat Springs&quot;,&quot;CO&quot;,1000.0,0.0],[&quot;Surry&quot;,&quot;ME&quot;,0.0,0.0],[&quot;Syracuse&quot;,&quot;NY&quot;,2450.0,400.0],[&quot;Talkeetna&quot;,&quot;AK&quot;,30.0,0.0],[&quot;Tallahassee&quot;,&quot;FL&quot;,15800.0,1500.0],[&quot;Taos&quot;,&quot;NM&quot;,100.0,0.0],[&quot;Tecumseh&quot;,&quot;MI&quot;,35.0,0.0],[&quot;Telluride&quot;,&quot;CO&quot;,560.0,0.0],[&quot;Tenants Harbor&quot;,&quot;ME&quot;,57.5,0.0],[&quot;Terre Haute&quot;,&quot;IN&quot;,0.0,0.0],[&quot;The Dalles&quot;,&quot;OR&quot;,100.0,0.0],[&quot;Tillamook&quot;,&quot;OR&quot;,300.0,0.0],[&quot;Tisbury&quot;,&quot;MA&quot;,130.0,0.0],[&quot;Toledo&quot;,&quot;OH&quot;,200.0,0.0],[&quot;Topeka&quot;,&quot;KS&quot;,3450.0,1500.0],[&quot;Traverse City&quot;,&quot;MI&quot;,3000.0,0.0],[&quot;Trenton&quot;,&quot;NJ&quot;,6900.0,400.0],[&quot;Troy&quot;,&quot;OH&quot;,175.0,0.0],[&quot;Troy&quot;,&quot;PA&quot;,6.0,0.0],[&quot;Truckee&quot;,&quot;CA&quot;,150.0,0.0],[&quot;Truth or Consequences&quot;,&quot;NM&quot;,154.0,0.0],[&quot;Tucson&quot;,&quot;AZ&quot;,15000.0,1750.0],[&quot;Tulsa&quot;,&quot;OK&quot;,1000.0,3200.0],[&quot;Tupper Lake&quot;,&quot;NY&quot;,5.0,0.0],[&quot;Tuscarora&quot;,&quot;NV&quot;,7.0,0.0],[&quot;Twisp&quot;,&quot;WA&quot;,690.0,0.0],[&quot;Ukiah&quot;,&quot;CA&quot;,1725.0,0.0],[&quot;Unalakleet&quot;,&quot;AK&quot;,39.0,0.0],[&quot;Unalaska (Dutch Harbor)&quot;,&quot;AK&quot;,83.0,0.0],[&quot;Union&quot;,&quot;WA&quot;,57.5,0.0],[&quot;University Park&quot;,&quot;MD&quot;,80.0,0.0],[&quot;Utica&quot;,&quot;NY&quot;,250.0,0.0],[&quot;Utqiagvik (Barrow)&quot;,&quot;AK&quot;,28.5,0.0],[&quot;Valdez&quot;,&quot;AK&quot;,115.0,0.0],[&quot;Vallejo&quot;,&quot;CA&quot;,150.0,0.0],[&quot;Valparaiso&quot;,&quot;IN&quot;,368.0,0.0],[&quot;Vancouver&quot;,&quot;WA&quot;,175.0,0.0],[&quot;Vashon&quot;,&quot;WA&quot;,261.5,0.0],[&quot;Ventura&quot;,&quot;CA&quot;,2285.0,1000.0],[&quot;Vermillion&quot;,&quot;SD&quot;,500.0,0.0],[&quot;Vienna&quot;,&quot;VA&quot;,31.5,0.0],[&quot;Vieques&quot;,&quot;PR&quot;,200.0,0.0],[&quot;Vinalhaven&quot;,&quot;ME&quot;,76.0,0.0],[&quot;Vineyard Haven&quot;,&quot;MA&quot;,0.0,0.0],[&quot;Visalia&quot;,&quot;CA&quot;,500.0,0.0],[&quot;Walla Walla&quot;,&quot;WA&quot;,2180.0,0.0],[&quot;Walnut Creek&quot;,&quot;CA&quot;,6150.0,0.0],[&quot;Washington&quot;,&quot;DC&quot;,725000.0,1000.0],[&quot;Watertown&quot;,&quot;NY&quot;,250.0,0.0],[&quot;Watsonville&quot;,&quot;CA&quot;,390.0,0.0],[&quot;Wausau&quot;,&quot;WI&quot;,175.0,0.0],[&quot;Welches&quot;,&quot;OR&quot;,0.0,0.0],[&quot;Wellfleet&quot;,&quot;MA&quot;,113.0,0.0],[&quot;Wenatchee&quot;,&quot;WA&quot;,2000.0,0.0],[&quot;West Chester&quot;,&quot;PA&quot;,175.0,0.0],[&quot;West Jefferson&quot;,&quot;NC&quot;,297.5,0.0],[&quot;West Lima&quot;,&quot;WI&quot;,1.0,0.0],[&quot;West Orange&quot;,&quot;NJ&quot;,0.0,0.0],[&quot;West Palm Beach&quot;,&quot;FL&quot;,5900.0,600.0],[&quot;West Plains&quot;,&quot;MO&quot;,0.0,0.0],[&quot;Westfield&quot;,&quot;NJ&quot;,1450.0,0.0],[&quot;Westwood&quot;,&quot;CA&quot;,7.0,0.0],[&quot;Whitefish&quot;,&quot;MT&quot;,0.0,0.0],[&quot;Wichita&quot;,&quot;KS&quot;,3000.0,1000.0],[&quot;Wichita Falls&quot;,&quot;TX&quot;,150.0,800.0],[&quot;Williamsburg&quot;,&quot;VA&quot;,835.0,0.0],[&quot;Willits&quot;,&quot;CA&quot;,50.0,0.0],[&quot;Willow Springs&quot;,&quot;MO&quot;,0.0,0.0],[&quot;Wilmington&quot;,&quot;NC&quot;,1900.0,0.0],[&quot;Wilmington&quot;,&quot;OH&quot;,70.0,0.0],[&quot;Wilton&quot;,&quot;NH&quot;,112.5,0.0],[&quot;Winchester&quot;,&quot;VA&quot;,1245.0,0.0],[&quot;Winston-Salem&quot;,&quot;NC&quot;,0.0,900.0],[&quot;Winters&quot;,&quot;CA&quot;,200.0,0.0],[&quot;Women's March Online&quot;,&quot;--&quot;,415.0,0.0],[&quot;Woods Hole&quot;,&quot;MA&quot;,1.0,0.0],[&quot;Woodstock&quot;,&quot;NY&quot;,1000.0,0.0],[&quot;Woodstock&quot;,&quot;VA&quot;,400.0,0.0],[&quot;Wooster&quot;,&quot;OH&quot;,725.0,0.0],[&quot;Worcester&quot;,&quot;MA&quot;,0.0,0.0],[&quot;Wyckoff&quot;,&quot;NJ&quot;,390.0,0.0],[&quot;Yakima&quot;,&quot;WA&quot;,890.0,600.0],[&quot;Yellow Springs&quot;,&quot;OH&quot;,250.0,0.0],[&quot;Ypsilanti&quot;,&quot;MI&quot;,1200.0,0.0],[&quot;Yucca Valley&quot;,&quot;CA&quot;,138.0,0.0],[&quot;Yuma&quot;,&quot;AZ&quot;,10.0,1000.0],[&quot;Zebulon&quot;,&quot;GA&quot;,35.0,0.0],[&quot;Abilene&quot;,&quot;TX&quot;,0.0,800.0],[&quot;Abingdon&quot;,&quot;VA&quot;,0.0,400.0],[&quot;Ada&quot;,&quot;OK&quot;,0.0,200.0],[&quot;Albany&quot;,&quot;OR&quot;,0.0,140.0],[&quot;Anderson&quot;,&quot;IN&quot;,0.0,100.0],[&quot;Ashland&quot;,&quot;OH&quot;,0.0,600.0],[&quot;Ashtabula&quot;,&quot;OH&quot;,0.0,275.0],[&quot;Astacadero&quot;,&quot;CA&quot;,0.0,850.0],[&quot;Bad Axe&quot;,&quot;MI&quot;,0.0,100.0],[&quot;Bangor&quot;,&quot;ME&quot;,0.0,300.0],[&quot;Bartow&quot;,&quot;FL&quot;,0.0,200.0],[&quot;Baton Rouge&quot;,&quot;LA&quot;,0.0,1000.0],[&quot;Baxter&quot;,&quot;AR&quot;,0.0,1000.0],[&quot;Beaumount&quot;,&quot;TX&quot;,0.0,1000.0],[&quot;Bellevue&quot;,&quot;WA&quot;,0.0,200.0],[&quot;Belton&quot;,&quot;TX&quot;,0.0,2000.0],[&quot;Billings&quot;,&quot;MT&quot;,0.0,500.0],[&quot;Bloomington&quot;,&quot;IN&quot;,0.0,200.0],[&quot;Boiling Springs&quot;,&quot;SC&quot;,0.0,120.0],[&quot;Borger&quot;,&quot;TX&quot;,0.0,275.0],[&quot;Bossier City&quot;,&quot;LA&quot;,0.0,5000.0],[&quot;Bound Book&quot;,&quot;NJ&quot;,0.0,20.0],[&quot;Bradenton&quot;,&quot;FL&quot;,0.0,75.0],[&quot;Bremerton&quot;,&quot;WA&quot;,0.0,100.0],[&quot;Bristol&quot;,&quot;TN&quot;,0.0,100.0],[&quot;Burleson&quot;,&quot;TX&quot;,0.0,500.0],[&quot;Camden&quot;,&quot;NY&quot;,0.0,100.0],[&quot;Camdenton&quot;,&quot;MO&quot;,0.0,300.0],[&quot;Canton&quot;,&quot;OH&quot;,0.0,2500.0],[&quot;Carmel Mountain Ranch&quot;,&quot;CA&quot;,0.0,1000.0],[&quot;Carson City&quot;,&quot;NV&quot;,0.0,2000.0],[&quot;Carterville&quot;,&quot;IL&quot;,0.0,40.0],[&quot;Cedar Rapids&quot;,&quot;IA&quot;,0.0,600.0],[&quot;Chelsea&quot;,&quot;MI&quot;,0.0,250.0],[&quot;Chester&quot;,&quot;NY&quot;,0.0,80.0],[&quot;Chico&quot;,&quot;WA&quot;,0.0,100.0],[&quot;Clarksville&quot;,&quot;TN&quot;,0.0,500.0],[&quot;Cleveland&quot;,&quot;TN&quot;,0.0,200.0],[&quot;Coldwater&quot;,&quot;MI&quot;,0.0,200.0],[&quot;Columbus&quot;,&quot;GA&quot;,0.0,300.0],[&quot;Columbus&quot;,&quot;IN&quot;,0.0,2000.0],[&quot;Columbus&quot;,&quot;MS&quot;,0.0,400.0],[&quot;Corona&quot;,&quot;CA&quot;,0.0,65.0],[&quot;Cotulla&quot;,&quot;TX&quot;,0.0,80.0],[&quot;Council Bluffs&quot;,&quot;IA&quot;,0.0,150.0],[&quot;Craig&quot;,&quot;CO&quot;,0.0,221.0],[&quot;Crown Point&quot;,&quot;IN- 100&quot;,0.0,0.0],[&quot;Crystal Lake&quot;,&quot;IL&quot;,0.0,200.0],[&quot;Cullman&quot;,&quot;AL&quot;,0.0,1000.0],[&quot;Currituck&quot;,&quot;NC&quot;,0.0,150.0],[&quot;Defiance&quot;,&quot;OH&quot;,0.0,175.0],[&quot;Dekalb&quot;,&quot;AL&quot;,0.0,200.0],[&quot;Deland&quot;,&quot;FL&quot;,0.0,1500.0],[&quot;Des Monies&quot;,&quot;IA&quot;,0.0,5000.0],[&quot;Dickinson&quot;,&quot;ND&quot;,0.0,200.0],[&quot;Doral&quot;,&quot;FL&quot;,0.0,800.0],[&quot;Dover&quot;,&quot;NH&quot;,0.0,125.0],[&quot;Edenton&quot;,&quot;NC&quot;,0.0,400.0],[&quot;El Dorado&quot;,&quot;AR&quot;,0.0,300.0],[&quot;Elba&quot;,&quot;AL&quot;,0.0,400.0],[&quot;Elizabeth City&quot;,&quot;NC&quot;,0.0,150.0],[&quot;Elizabethtown&quot;,&quot;KY&quot;,0.0,275.0],[&quot;Emporia&quot;,&quot;KS&quot;,0.0,150.0],[&quot;Escondido&quot;,&quot;CA&quot;,0.0,2000.0],[&quot;Farmington&quot;,&quot;NM&quot;,0.0,600.0],[&quot;Fayetteville&quot;,&quot;GA&quot;,0.0,200.0],[&quot;Fayetteville&quot;,&quot;NC&quot;,0.0,300.0],[&quot;Fishersville&quot;,&quot;VA&quot;,0.0,500.0],[&quot;Flemington&quot;,&quot;NJ&quot;,0.0,200.0],[&quot;Florence&quot;,&quot;AL&quot;,0.0,350.0],[&quot;Fon du Lac&quot;,&quot;WI&quot;,0.0,300.0],[&quot;Fort Lauderdale&quot;,&quot;FL&quot;,0.0,1750.0],[&quot;Fort Mill&quot;,&quot;SC&quot;,0.0,80.0],[&quot;Fort Myers&quot;,&quot;FL&quot;,0.0,4000.0],[&quot;Fort Plain&quot;,&quot;NY&quot;,0.0,12.0],[&quot;Fort Scott&quot;,&quot;KS&quot;,0.0,200.0],[&quot;Fort Smith&quot;,&quot;AR&quot;,0.0,500.0],[&quot;Frankfort&quot;,&quot;KY&quot;,0.0,250.0],[&quot;Fremont&quot;,&quot;OH&quot;,0.0,100.0],[&quot;Friendswood&quot;,&quot;TX&quot;,0.0,300.0],[&quot;Frisco&quot;,&quot;CO&quot;,0.0,50.0],[&quot;Gadsden&quot;,&quot;AL&quot;,0.0,35.0],[&quot;Gardiner&quot;,&quot;NY&quot;,0.0,400.0],[&quot;Gastonia&quot;,&quot;NC&quot;,0.0,100.0],[&quot;Gilbert&quot;,&quot;AZ&quot;,0.0,1000.0],[&quot;Gilmer&quot;,&quot;TX&quot;,0.0,250.0],[&quot;Glendale&quot;,&quot;CA&quot;,0.0,275.0],[&quot;Goldsboro&quot;,&quot;NC&quot;,0.0,300.0],[&quot;Green Cove Springs&quot;,&quot;FL&quot;,0.0,30.0],[&quot;Greensboro&quot;,&quot;NC 1000&quot;,0.0,0.0],[&quot;Greenville&quot;,&quot;TN&quot;,0.0,100.0],[&quot;Hannibal&quot;,&quot;MO&quot;,0.0,200.0],[&quot;Harrisburg&quot;,&quot;IL&quot;,0.0,300.0],[&quot;Harrison&quot;,&quot;AR&quot;,0.0,300.0],[&quot;Havasu&quot;,&quot;AZ&quot;,0.0,2250.0],[&quot;Herrin&quot;,&quot;IL&quot;,0.0,65.0],[&quot;Hollidaysburg&quot;,&quot;PA&quot;,0.0,450.0],[&quot;Honolulu&quot;,&quot;HI&quot;,0.0,400.0],[&quot;Houma&quot;,&quot;LA&quot;,0.0,600.0],[&quot;Hudsonville&quot;,&quot;MI&quot;,0.0,1000.0],[&quot;Hyannis&quot;,&quot;MA&quot;,0.0,600.0],[&quot;Jackson&quot;,&quot;MI&quot;,0.0,450.0],[&quot;Joliet&quot;,&quot;IL&quot;,0.0,300.0],[&quot;Joplin&quot;,&quot;MO&quot;,0.0,1000.0],[&quot;Kalispell&quot;,&quot;MT&quot;,0.0,150.0],[&quot;Kingston&quot;,&quot;NY&quot;,0.0,100.0],[&quot;Lake City&quot;,&quot;WA&quot;,0.0,24.0],[&quot;Lakewood Ranch&quot;,&quot;FL&quot;,0.0,300.0],[&quot;Lexington&quot;,&quot;NE&quot;,0.0,400.0],[&quot;Lisbon&quot;,&quot;OH&quot;,0.0,500.0],[&quot;Lisle&quot;,&quot;IL&quot;,0.0,1000.0],[&quot;Livonia&quot;,&quot;MI&quot;,0.0,400.0],[&quot;Longview&quot;,&quot;TX&quot;,0.0,650.0],[&quot;Loveland&quot;,&quot;CO&quot;,0.0,1000.0],[&quot;Lynchburg&quot;,&quot;VA&quot;,0.0,1200.0],[&quot;Manchester&quot;,&quot;NH&quot;,0.0,1000.0],[&quot;Marble Falls&quot;,&quot;TX&quot;,0.0,1000.0],[&quot;Marietta&quot;,&quot;WV&quot;,0.0,500.0],[&quot;Marion&quot;,&quot;IL&quot;,0.0,100.0],[&quot;Martinsburg&quot;,&quot;WV&quot;,0.0,300.0],[&quot;Massapequa&quot;,&quot;NY&quot;,0.0,300.0],[&quot;Matamoras&quot;,&quot;PA&quot;,0.0,600.0],[&quot;Medina&quot;,&quot;OH&quot;,0.0,1000.0],[&quot;Merced&quot;,&quot;CA&quot;,0.0,200.0],[&quot;Meridian&quot;,&quot;MS&quot;,0.0,100.0],[&quot;Miami&quot;,&quot;OK&quot;,0.0,250.0],[&quot;Minden&quot;,&quot;LA&quot;,0.0,300.0],[&quot;Monterey&quot;,&quot;CA&quot;,0.0,600.0],[&quot;Montgomery&quot;,&quot;AL&quot;,0.0,1000.0],[&quot;Morristown&quot;,&quot;NJ&quot;,0.0,600.0],[&quot;Muskegon&quot;,&quot;MI&quot;,0.0,300.0],[&quot;Myrtle Beach&quot;,&quot;SC&quot;,0.0,500.0],[&quot;Naperville&quot;,&quot;IL&quot;,0.0,500.0],[&quot;Natchez&quot;,&quot;MS&quot;,0.0,75.0],[&quot;Natrona&quot;,&quot;WY&quot;,0.0,1000.0],[&quot;Neunan&quot;,&quot;GA&quot;,0.0,200.0],[&quot;New Braunfels&quot;,&quot;TX&quot;,0.0,300.0],[&quot;New Richmond&quot;,&quot;WI&quot;,0.0,80.0],[&quot;Newport News&quot;,&quot;VA&quot;,0.0,250.0],[&quot;Nicholasville&quot;,&quot;KY&quot;,0.0,250.0],[&quot;Nicholson&quot;,&quot;GA&quot;,0.0,50.0],[&quot;Nobelsville&quot;,&quot;IN&quot;,0.0,35.0],[&quot;North Platte&quot;,&quot;NE&quot;,0.0,50.0],[&quot;Norwalk&quot;,&quot;OH&quot;,0.0,250.0],[&quot;Oak Harbor&quot;,&quot;WA&quot;,0.0,100.0],[&quot;Oceanside&quot;,&quot;CA&quot;,0.0,1000.0],[&quot;Opelousas&quot;,&quot;AL&quot;,0.0,50.0],[&quot;Oswego&quot;,&quot;IL&quot;,0.0,200.0],[&quot;Palmer Township&quot;,&quot;PA&quot;,0.0,200.0],[&quot;Pappilon&quot;,&quot;NE&quot;,0.0,200.0],[&quot;Parkersburg&quot;,&quot;WV&quot;,0.0,300.0],[&quot;Pataskala&quot;,&quot;OH&quot;,0.0,30.0],[&quot;Pearland&quot;,&quot;TX&quot;,0.0,450.0],[&quot;Piscataway&quot;,&quot;NJ&quot;,0.0,500.0],[&quot;Pismo Beach&quot;,&quot;CA&quot;,0.0,200.0],[&quot;Pittsburg\/Antoich&quot;,&quot;CA&quot;,0.0,50.0],[&quot;Pittsfield&quot;,&quot;NY&quot;,0.0,100.0],[&quot;Plainville&quot;,&quot;CT&quot;,0.0,13.0],[&quot;Pleasanton&quot;,&quot;CA&quot;,0.0,2000.0],[&quot;Plymouth&quot;,&quot;MI&quot;,0.0,1000.0],[&quot;Port St. Lucie&quot;,&quot;FL&quot;,0.0,500.0],[&quot;Pullman&quot;,&quot;WA&quot;,0.0,150.0],[&quot;Redlands&quot;,&quot;CA&quot;,0.0,500.0],[&quot;Richmond&quot;,&quot;CA&quot;,0.0,30.0],[&quot;Richmond Hill&quot;,&quot;GA&quot;,0.0,60.0],[&quot;Rochester&quot;,&quot;NH&quot;,0.0,200.0],[&quot;Roseburg&quot;,&quot;OR&quot;,0.0,750.0],[&quot;Rowlett&quot;,&quot;TX&quot;,0.0,200.0],[&quot;Rutland&quot;,&quot;VT&quot;,0.0,300.0],[&quot;San Marcos&quot;,&quot;TX&quot;,0.0,90.0],[&quot;San Mateo&quot;,&quot;CA&quot;,0.0,250.0],[&quot;Sandusky&quot;,&quot;OH&quot;,0.0,300.0],[&quot;Scranton&quot;,&quot;PA&quot;,0.0,200.0],[&quot;Seal Beach&quot;,&quot;CA&quot;,0.0,1000.0],[&quot;Seguin&quot;,&quot;TX&quot;,0.0,200.0],[&quot;Selma&quot;,&quot;AL&quot;,0.0,30.0],[&quot;Sevierville&quot;,&quot;TN&quot;,0.0,40.0],[&quot;Shelton&quot;,&quot;CT&quot;,0.0,100.0],[&quot;Simi Valley&quot;,&quot;CA&quot;,0.0,150.0],[&quot;South Kitsap&quot;,&quot;WA&quot;,0.0,150.0],[&quot;Southlake&quot;,&quot;TX&quot;,0.0,500.0],[&quot;St. Paul&quot;,&quot;MN&quot;,0.0,2000.0],[&quot;St. Simons Island&quot;,&quot;FL&quot;,0.0,500.0],[&quot;Stockton&quot;,&quot;CA&quot;,0.0,200.0],[&quot;Stuart&quot;,&quot;FL&quot;,0.0,2000.0],[&quot;Superior&quot;,&quot;WI&quot;,0.0,200.0],[&quot;Tampa&quot;,&quot;FL&quot;,0.0,500.0],[&quot;Temecula&quot;,&quot;CA&quot;,0.0,1000.0],[&quot;Thousand Oaks&quot;,&quot;CA&quot;,0.0,338.0],[&quot;Troy&quot;,&quot;MI&quot;,0.0,2000.0],[&quot;Tuscaloosa&quot;,&quot;AL&quot;,0.0,600.0],[&quot;Tyler&quot;,&quot;TX&quot;,0.0,1500.0],[&quot;Valdosta&quot;,&quot;GA&quot;,0.0,400.0],[&quot;Vero Beach&quot;,&quot;FL&quot;,0.0,3500.0],[&quot;Vineland&quot;,&quot;NJ&quot;,0.0,100.0],[&quot;Virginia Beach&quot;,&quot;VA&quot;,0.0,650.0],[&quot;Waco&quot;,&quot;TX&quot;,0.0,1100.0],[&quot;Walton&quot;,&quot;FL&quot;,0.0,200.0],[&quot;Wasilla&quot;,&quot;AK&quot;,0.0,850.0],[&quot;Watkinsville&quot;,&quot;GA&quot;,0.0,150.0],[&quot;West Covina&quot;,&quot;CA&quot;,0.0,60.0],[&quot;Westerville&quot;,&quot;OH&quot;,0.0,50.0],[&quot;Wheeling&quot;,&quot;WV&quot;,0.0,2000.0],[&quot;Wilmington&quot;,&quot;DE&quot;,0.0,1000.0],[&quot;York&quot;,&quot;SC&quot;,0.0,300.0],[&quot;Youngstown&quot;,&quot;OH&quot;,0.0,200.0],[&quot;Yucaipa&quot;,&quot;CA&quot;,0.0,200.0]];
    var xName = &quot;march_num&quot;;
    var yName = &quot;tea_num&quot;;
    var xLabel = &quot;Women's March (log)&quot;;
    var yLabel = &quot;Tea Party (log)&quot;;
    
    var min_x = d3.min(data, function(d) { return +d[keys[xName]]; });
    var max_x = d3.max(data, function(d) { return +d[keys[xName]]; });
    var min_y = d3.min(data, function(d) { return +d[keys[yName]]; });
    var max_y = d3.max(data, function(d) { return +d[keys[yName]]; });
    var max = d3.max([min_x, min_y, max_x, max_y].map(Math.abs));

    var x = d3.scale.log()
        .domain([0.7, 10*max_x])
        .range([0, width]);

    var y = d3.scale.log()
        .domain([0.7, 10*max_y])
        .range([height, 0]);

    var xAxis = d3.svg.axis()
        .scale(x)
        .orient(&quot;bottom&quot;)
        .ticks(10, &quot;,.1s&quot;)
        .tickSize(-height);

    var yAxis = d3.svg.axis()
        .scale(y)
        .orient(&quot;left&quot;)
        .ticks(10, &quot;,.1s&quot;)
        .tickSize(-width); 
        
    var zoom = d3.behavior.zoom()
        .x(x)
        .y(y)
        //.scaleExtent([1, 10])
        .center([width / 2, height / 2])
        .size([width, height])
        .on(&quot;zoom&quot;, zoomed);

    var svg = d3.select(&quot;body&quot;).append(&quot;svg&quot;)
        .attr(&quot;width&quot;, width + margin.left + margin.right)
        .attr(&quot;height&quot;, height + margin.top + margin.bottom)
      .append(&quot;g&quot;)
        .attr(&quot;transform&quot;, &quot;translate(&quot; + margin.left + &quot;,&quot; + margin.top + &quot;)&quot;)
        .call(zoom);
        

    //http://stackoverflow.com/questions/28723551
    //Create clip, then apply it to each dot
    var clip = svg.append(&quot;defs&quot;).append(&quot;svg:clipPath&quot;)
        .attr(&quot;id&quot;, &quot;clip&quot;)
        .append(&quot;svg:rect&quot;)
        .attr(&quot;id&quot;, &quot;clip-rect&quot;)
        .attr(&quot;x&quot;, &quot;0&quot;)  //
        .attr(&quot;y&quot;, &quot;0&quot;)  //
        .attr('width', width)
        .attr('height', height);

    svg.append(&quot;rect&quot;)
        .attr(&quot;width&quot;, width)
        .attr(&quot;height&quot;, height);

    svg.append(&quot;g&quot;)
        .attr(&quot;class&quot;, &quot;x axis&quot;)
        .attr(&quot;transform&quot;, &quot;translate(0,&quot; + height + &quot;)&quot;)
        //.attr(&quot;clip-path&quot;, &quot;url(#clip)&quot;)
        .call(xAxis);

    svg.append(&quot;g&quot;)
        .attr(&quot;class&quot;, &quot;y axis&quot;)
        //.attr(&quot;clip-path&quot;, &quot;url(#clip)&quot;)
        .call(yAxis);
      
    // Tooltips
    var div = d3.select(&quot;body&quot;)
        .append(&quot;div&quot;)  
        .attr(&quot;class&quot;, &quot;tooltip&quot;)
        .style(&quot;opacity&quot;, 0);
            
    
svg.append(&quot;line&quot;)
    .attr(&quot;x1&quot;, x(1))
    .attr(&quot;y1&quot;, y(1))
    .attr(&quot;x2&quot;, x(1e8))                         
    .attr(&quot;y2&quot;, y(1e8))
    .attr(&quot;stroke-width&quot;, 2.0)
    .attr(&quot;stroke&quot;, &quot;#fff&quot;) //#999 #fff
    .attr(&quot;opacity&quot;, &quot;1&quot;)
    //.attr(&quot;fill&quot;, &quot;none&quot;)
    //.style(&quot;stroke-dasharray&quot;, (&quot;10, 10&quot;))
    .attr(&quot;class&quot;, &quot;trendline&quot;)
    .attr(&quot;clip-path&quot;, &quot;url(#clip)&quot;);


    svg.selectAll(&quot;.dot&quot;)
      .data(data)
    .enter().append(&quot;circle&quot;)
      .attr(&quot;class&quot;, &quot;dot&quot;)
      .attr(&quot;clip-path&quot;, &quot;url(#clip)&quot;)  //add the clip to each dot
      .attr(&quot;r&quot;, 3.5) //3.5  4.5 3*zoom.scale()
      .attr(&quot;cx&quot;, function(d) { return x(+d[keys[xName]] + 1); })
      .attr(&quot;cy&quot;, function(d) { return y(+d[keys[yName]] + 1); })
      .style(&quot;fill&quot;, 'steelblue' ) //red  gray
      .attr('fill-opacity', 0.7) //0.6 0.9
      .on(&quot;mouseover&quot;, function(d) { drawTooltip(d); })
      .on(&quot;mouseout&quot;, function() {
        div.style(&quot;opacity&quot;, 0);
      });

    svg.append(&quot;text&quot;)
        .attr(&quot;class&quot;, &quot;x label&quot;)
        .attr(&quot;text-anchor&quot;, &quot;middle&quot;)
        .attr(&quot;x&quot;, width/2)
        .attr(&quot;y&quot;, height + 30)
        .text(&quot;Women's March (log)&quot;);

    svg.append(&quot;text&quot;)
        .attr(&quot;class&quot;, &quot;y label&quot;)
        .attr(&quot;text-anchor&quot;, &quot;middle&quot;)
        .attr(&quot;x&quot;, -height/2)
        .attr(&quot;y&quot;, -30) //-30
        .attr(&quot;transform&quot;, &quot;rotate(-90)&quot;)
        .text(&quot;Tea Party (log)&quot;);
        

    d3.selectAll(&quot;button[data-zoom]&quot;)
        .on(&quot;click&quot;, clicked);
        

    function zoomed() {
      svg.select(&quot;.x.axis&quot;).call(xAxis);
      svg.select(&quot;.y.axis&quot;).call(yAxis);

      //http://stackoverflow.com/questions/37573228
      svg.selectAll(&quot;.dot&quot;)
        //.attr(&quot;r&quot;, 3*zoom.scale())
        .attr(&quot;cx&quot;, function (d) {
            return x(+d[keys[xName]] + 1);
        })
        .attr(&quot;cy&quot;, function (d) {
            return y(+d[keys[yName]] + 1);
        });
        
        d3.selectAll('.trendline')
            .attr(&quot;x1&quot;, x(1))
            .attr(&quot;y1&quot;, y(1))
            .attr(&quot;x2&quot;, x(1e8))                         
            .attr(&quot;y2&quot;, y(1e8))   
    }

    function clicked() {
      svg.call(zoom.event); // https://github.com/mbostock/d3/issues/2387

      // Record the coordinates (in data space) of the center (in screen space).
      var center0 = zoom.center(), translate0 = zoom.translate(), coordinates0 = coordinates(center0);
      zoom.scale(zoom.scale() * Math.pow(2, +this.getAttribute(&quot;data-zoom&quot;)));

      // Translate back to the center.
      var center1 = point(coordinates0);
      zoom.translate([translate0[0] + center0[0] - center1[0], translate0[1] + center0[1] - center1[1]]);

      //svg.transition().duration(750).call(zoom.event);
      svg.transition().duration(300).call(zoom.event);

    }

    function coordinates(point) {
      var scale = zoom.scale(), translate = zoom.translate();
      return [(point[0] - translate[0]) / scale, (point[1] - translate[1]) / scale];
    }

    function point(coordinates) {
      var scale = zoom.scale(), translate = zoom.translate();
      return [coordinates[0] * scale + translate[0], coordinates[1] * scale + translate[1]];
    }

    function drawTooltip(d) {
        div.style(&quot;opacity&quot;, 1.0);
        div.html(
    &quot;<b>Location:</b> &quot; + d[keys.city] + &quot;, &quot; + d[keys.state] +
    &quot;<br><b>Women's March: </b>&quot; + fmtTh(+d[keys.march_num]) +
    &quot;<br><b>Tea Party: </b>&quot; + fmtTh(+d[keys.tea_num]) 
)
            .style(&quot;left&quot;, (d3.event.pageX) + &quot;px&quot;)
            .style(&quot;top&quot;, (d3.event.pageY ) + &quot;px&quot;);
    }

</script>
</body>
</html>
" style="width: 960px; height: 600px; display:block; width: 100%; margin: 25px auto; border: none"></iframe>

Here's a table showing the data from the scatter plot above.  Click the headers to sort it by any of the columns:


<iframe srcdoc="
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset=&quot;utf-8&quot;>
    <style>

    /*
    body {
        width: 800px;
    }*/

    table {
        font-size: 12px;
        border-collapse: collapse;
        border-top: 1px solid #ddd;
        border-right: 1px solid #ddd;
    }

    th {
        padding: 10px;
        cursor: pointer;
        background-color: #f2f2f2;
    }

    th, td {
        text-align: left;
        border-bottom: 1px solid #ddd;
        border-left: 1px solid #ddd;
    }

    td {
        padding: 5px 8px;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    tr:hover {
      background-color: #F0F8FF; /*#f9f9f9;*/
    }

    </style>
    </head>

    <body>

    <div id =&quot;tableInsert&quot;></div>

    <script>
    //http://stackoverflow.com/questions/14267781/sorting-html-table-with-javascript

    function sortTable(table, col, reverse) {
        var tb = table.tBodies[0], 
            tr = Array.prototype.slice.call(tb.rows, 0), // put rows into array
            i;

        reverse = -((+reverse) || -1);
        tr = tr.sort(function (a, b) { 
            var first = a.cells[col].textContent.trim();
            var second = b.cells[col].textContent.trim();

            if (isNumeric(first) && isNumeric(second)) {        
                return reverse * (Number(first) - Number(second));
            } else {
                return reverse * first.localeCompare(second);
            };
        });
        for(i = 0; i < tr.length; ++i) {  // append each row in order
            tb.appendChild(tr[i]);
        }
    }

    //http://stackoverflow.com/questions/18082
    function isNumeric(n) {
      return !isNaN(parseFloat(n)) && isFinite(n);
    }

    function makeSortable(table) {
        var th = table.tHead, i;
        th && (th = th.rows[0]) && (th = th.cells);
        if (th) i = th.length;
        else return; // if no `<thead>` then do nothing
        while (--i >= 0) (function (i) {
            var dir = 1;
            th[i].addEventListener('click', function () {sortTable(table, i, (dir = 1 - dir))});
        }(i));
    }

    function makeAllSortable(parent) {
        parent = parent || document.body;
        var t = parent.getElementsByTagName('table'), i = t.length;
        while (--i >= 0) makeSortable(t[i]);
    }

    function addTable() {
        var tableDiv = document.getElementById(&quot;tableInsert&quot;)
        var table = document.createElement('table')
        var tableHead = document.createElement('thead')
        var tableBody = document.createElement('tbody')

        table.appendChild(tableHead)
        table.appendChild(tableBody);

        var heading = [&quot;city&quot;, &quot;state&quot;, &quot;march_num&quot;, &quot;tea_num&quot;];
        var data = [[&quot;Washington&quot;,&quot;DC&quot;,725000.0,1000.0],[&quot;Los Angeles&quot;,&quot;CA&quot;,447500.0,0.0],[&quot;New York&quot;,&quot;NY&quot;,445000.0,3500.0],[&quot;Chicago&quot;,&quot;IL&quot;,250000.0,2000.0],[&quot;Boston&quot;,&quot;MA&quot;,175000.0,2500.0],[&quot;San Francisco&quot;,&quot;CA&quot;,154000.0,500.0],[&quot;Denver&quot;,&quot;CO&quot;,145000.0,5000.0],[&quot;Seattle&quot;,&quot;WA&quot;,133750.0,1100.0],[&quot;Oakland&quot;,&quot;CA&quot;,100000.0,50.0],[&quot;St. Paul\/Minneapolis&quot;,&quot;MN&quot;,94500.0,0.0],[&quot;Madison&quot;,&quot;WI&quot;,86250.0,5000.0],[&quot;Portland&quot;,&quot;OR&quot;,83557.5,1000.0],[&quot;Atlanta&quot;,&quot;GA&quot;,61350.0,15000.0],[&quot;Austin&quot;,&quot;TX&quot;,50550.0,1250.0],[&quot;Philadelphia&quot;,&quot;PA&quot;,50000.0,200.0],[&quot;San Diego&quot;,&quot;CA&quot;,34500.0,500.0],[&quot;San Jose&quot;,&quot;CA&quot;,31750.0,1000.0],[&quot;Sacramento&quot;,&quot;CA&quot;,28100.0,3500.0],[&quot;Des Moines&quot;,&quot;IA&quot;,26000.0,0.0],[&quot;Pittsburgh&quot;,&quot;PA&quot;,25000.0,0.0],[&quot;Charlotte&quot;,&quot;NC&quot;,24500.0,1500.0],[&quot;Phoenix&quot;,&quot;AZ&quot;,22250.0,5000.0],[&quot;Santa Ana&quot;,&quot;CA&quot;,22250.0,1000.0],[&quot;Houston&quot;,&quot;TX&quot;,21434.15,2000.0],[&quot;St. Petersburg&quot;,&quot;FL&quot;,20000.0,0.0],[&quot;Raleigh&quot;,&quot;NC&quot;,18350.0,1200.0],[&quot;Lansing&quot;,&quot;MI&quot;,17900.0,4500.0],[&quot;Montpelier&quot;,&quot;VT&quot;,17250.0,500.0],[&quot;Nashville&quot;,&quot;TN&quot;,17250.0,2900.0],[&quot;Miami&quot;,&quot;FL&quot;,16750.0,0.0],[&quot;Tallahassee&quot;,&quot;FL&quot;,15800.0,1500.0],[&quot;Cleveland&quot;,&quot;OH&quot;,15000.0,1500.0],[&quot;Tucson&quot;,&quot;AZ&quot;,15000.0,1750.0],[&quot;Omaha&quot;,&quot;NE&quot;,14700.0,150.0],[&quot;St. Louis&quot;,&quot;MO&quot;,14500.0,2000.0],[&quot;Santa Fe&quot;,&quot;NM&quot;,13150.0,0.0],[&quot;Ashland&quot;,&quot;OR&quot;,11150.0,0.0],[&quot;Santa Cruz&quot;,&quot;CA&quot;,11150.0,0.0],[&quot;Ann Arbor&quot;,&quot;MI&quot;,11000.0,200.0],[&quot;New Orleans&quot;,&quot;LA&quot;,10600.0,0.0],[&quot;Seneca Falls&quot;,&quot;NY&quot;,10000.0,0.0],[&quot;Reno&quot;,&quot;NV&quot;,10000.0,200.0],[&quot;Hartford&quot;,&quot;CT&quot;,10000.0,3000.0],[&quot;Helena&quot;,&quot;MT&quot;,10000.0,200.0],[&quot;Portland&quot;,&quot;ME&quot;,10000.0,0.0],[&quot;Olympia&quot;,&quot;WA&quot;,10000.0,4500.0],[&quot;Oklahoma City&quot;,&quot;OK&quot;,9250.0,4500.0],[&quot;Las Vegas&quot;,&quot;NV&quot;,8950.0,500.0],[&quot;Ithaca&quot;,&quot;NY&quot;,8900.0,0.0],[&quot;Salt Lake City&quot;,&quot;UT&quot;,8800.0,1500.0],[&quot;Sarasota&quot;,&quot;FL&quot;,8625.0,0.0],[&quot;Albuquerque&quot;,&quot;NM&quot;,8400.0,1000.0],[&quot;Asheville&quot;,&quot;NC&quot;,8350.0,0.0],[&quot;San Luis Obispo&quot;,&quot;CA&quot;,8350.0,0.0],[&quot;Eugene&quot;,&quot;OR&quot;,8350.0,0.0],[&quot;Cincinnati&quot;,&quot;OH&quot;,8150.0,3000.0],[&quot;Albany&quot;,&quot;NY&quot;,7900.0,1000.0],[&quot;Spokane&quot;,&quot;WA&quot;,7600.0,2300.0],[&quot;Kansas City&quot;,&quot;MO&quot;,7250.0,1000.0],[&quot;Augusta&quot;,&quot;ME&quot;,7250.0,600.0],[&quot;Birmingham&quot;,&quot;AL&quot;,7250.0,0.0],[&quot;Lexington&quot;,&quot;KY&quot;,7250.0,0.0],[&quot;Colorado Springs&quot;,&quot;CO&quot;,7000.0,2000.0],[&quot;Little Rock&quot;,&quot;AR&quot;,7000.0,500.0],[&quot;Trenton&quot;,&quot;NJ&quot;,6900.0,400.0],[&quot;Indianapolis&quot;,&quot;IN&quot;,6700.0,3625.0],[&quot;Eureka&quot;,&quot;CA&quot;,6350.0,0.0],[&quot;Dallas&quot;,&quot;TX&quot;,6350.0,4000.0],[&quot;Santa Barbara&quot;,&quot;CA&quot;,6350.0,0.0],[&quot;Park City&quot;,&quot;UT&quot;,6350.0,0.0],[&quot;San Marcos&quot;,&quot;CA&quot;,6150.0,0.0],[&quot;Walnut Creek&quot;,&quot;CA&quot;,6150.0,0.0],[&quot;Asbury Park&quot;,&quot;NJ&quot;,6000.0,0.0],[&quot;West Palm Beach&quot;,&quot;FL&quot;,5900.0,600.0],[&quot;Providence&quot;,&quot;RI&quot;,5900.0,2000.0],[&quot;Memphis&quot;,&quot;TN&quot;,5700.0,1000.0],[&quot;Poughkeepsie&quot;,&quot;NY&quot;,5672.2,0.0],[&quot;Bellingham&quot;,&quot;WA&quot;,5450.0,1500.0],[&quot;Fort Worth&quot;,&quot;TX&quot;,5450.0,3750.0],[&quot;Champaign&quot;,&quot;IL&quot;,5360.0,400.0],[&quot;Honolulu (Oahu) HI&quot;,&quot;HI&quot;,5250.0,0.0],[&quot;Orlando&quot;,&quot;FL&quot;,5250.0,0.0],[&quot;Louisville&quot;,&quot;KY&quot;,5000.0,1000.0],[&quot;Stamford&quot;,&quot;CT&quot;,5000.0,0.0],[&quot;Santa Rosa&quot;,&quot;CA&quot;,5000.0,500.0],[&quot;Boise&quot;,&quot;ID&quot;,5000.0,2500.0],[&quot;Baltimore&quot;,&quot;MD&quot;,5000.0,150.0],[&quot;Concord&quot;,&quot;NH&quot;,4900.0,600.0],[&quot;Grand Junction&quot;,&quot;CO&quot;,4725.0,2000.0],[&quot;Greensboro&quot;,&quot;NC&quot;,4350.0,0.0],[&quot;Detroit&quot;,&quot;MI&quot;,4000.0,0.0],[&quot;Riverside&quot;,&quot;CA&quot;,4000.0,0.0],[&quot;Portsmouth&quot;,&quot;NH&quot;,3900.0,200.0],[&quot;Bend&quot;,&quot;OR&quot;,3900.0,1200.0],[&quot;Laguna Beach&quot;,&quot;CA&quot;,3725.0,0.0],[&quot;Roanoke&quot;,&quot;VA&quot;,3675.0,0.0],[&quot;Naples&quot;,&quot;FL&quot;,3625.0,3000.0],[&quot;Topeka&quot;,&quot;KS&quot;,3450.0,1500.0],[&quot;Knoxville&quot;,&quot;TN&quot;,3350.0,1700.0],[&quot;Sioux Falls&quot;,&quot;SD&quot;,3300.0,3000.0],[&quot;Kona&quot;,&quot;HI&quot;,3225.0,0.0],[&quot;Key West&quot;,&quot;FL&quot;,3225.0,0.0],[&quot;Erie&quot;,&quot;PA&quot;,3175.0,0.0],[&quot;Kahului&quot;,&quot;HI&quot;,3075.0,250.0],[&quot;Traverse City&quot;,&quot;MI&quot;,3000.0,0.0],[&quot;Napa&quot;,&quot;CA&quot;,3000.0,50.0],[&quot;Dayton&quot;,&quot;OH&quot;,3000.0,0.0],[&quot;Sonoma&quot;,&quot;CA&quot;,3000.0,0.0],[&quot;Wichita&quot;,&quot;KS&quot;,3000.0,1000.0],[&quot;Anchorage&quot;,&quot;AK&quot;,2900.0,1500.0],[&quot;Lincoln&quot;,&quot;NE&quot;,2900.0,0.0],[&quot;Northampton&quot;,&quot;MA&quot;,2725.0,0.0],[&quot;Grand Rapids&quot;,&quot;MI&quot;,2725.0,0.0],[&quot;Buffalo&quot;,&quot;NY&quot;,2725.0,150.0],[&quot;Columbia&quot;,&quot;MO&quot;,2721.8,0.0],[&quot;Jackson&quot;,&quot;MS&quot;,2662.5,2500.0],[&quot;Columbus&quot;,&quot;OH&quot;,2650.0,2700.0],[&quot;Athens&quot;,&quot;GA&quot;,2635.0,0.0],[&quot;Denton&quot;,&quot;TX&quot;,2635.0,950.0],[&quot;Fort Bragg&quot;,&quot;CA&quot;,2635.0,0.0],[&quot;Redwood City&quot;,&quot;CA&quot;,2500.0,0.0],[&quot;Moscow&quot;,&quot;ID&quot;,2500.0,100.0],[&quot;Hudson&quot;,&quot;NY&quot;,2450.0,0.0],[&quot;Charleston&quot;,&quot;WV&quot;,2450.0,550.0],[&quot;Syracuse&quot;,&quot;NY&quot;,2450.0,400.0],[&quot;Binghamton&quot;,&quot;NY&quot;,2450.0,0.0],[&quot;Jacksonville&quot;,&quot;FL&quot;,2450.0,4500.0],[&quot;Columbia&quot;,&quot;SC&quot;,2450.0,2650.0],[&quot;Salem&quot;,&quot;OR&quot;,2440.0,1500.0],[&quot;Norfolk&quot;,&quot;VA&quot;,2360.0,0.0],[&quot;Ventura&quot;,&quot;CA&quot;,2285.0,1000.0],[&quot;Charlottesville&quot;,&quot;VA&quot;,2225.0,1500.0],[&quot;Walla Walla&quot;,&quot;WA&quot;,2180.0,0.0],[&quot;San Antonio&quot;,&quot;TX&quot;,2175.0,4500.0],[&quot;Richmond&quot;,&quot;VA&quot;,2000.0,3000.0],[&quot;Fairbanks&quot;,&quot;AK&quot;,2000.0,0.0],[&quot;Redondo Beach&quot;,&quot;CA&quot;,2000.0,0.0],[&quot;East Liberty&quot;,&quot;PA&quot;,2000.0,0.0],[&quot;Fresno&quot;,&quot;CA&quot;,2000.0,1000.0],[&quot;Greenfield&quot;,&quot;MA&quot;,2000.0,0.0],[&quot;Greenville&quot;,&quot;SC&quot;,2000.0,0.0],[&quot;Wenatchee&quot;,&quot;WA&quot;,2000.0,0.0],[&quot;Charleston&quot;,&quot;SC&quot;,2000.0,2500.0],[&quot;South Orange&quot;,&quot;NJ&quot;,2000.0,0.0],[&quot;Pensacola&quot;,&quot;FL&quot;,2000.0,500.0],[&quot;Gainesville&quot;,&quot;FL&quot;,2000.0,1000.0],[&quot;Port Jefferson&quot;,&quot;NY&quot;,2000.0,0.0],[&quot;Springfield&quot;,&quot;MO&quot;,2000.0,0.0],[&quot;Chico&quot;,&quot;CA&quot;,1900.0,500.0],[&quot;Wilmington&quot;,&quot;NC&quot;,1900.0,0.0],[&quot;Chattanooga&quot;,&quot;TN&quot;,1900.0,2000.0],[&quot;Fargo&quot;,&quot;ND&quot;,1900.0,0.0],[&quot;Carbondale&quot;,&quot;IL&quot;,1900.0,50.0],[&quot;Hilo&quot;,&quot;HI&quot;,1815.0,0.0],[&quot;Douglas-Saugatuck&quot;,&quot;MI&quot;,1785.0,0.0],[&quot;Peoria&quot;,&quot;IL&quot;,1725.0,500.0],[&quot;Rochester&quot;,&quot;NY&quot;,1725.0,750.0],[&quot;Ukiah&quot;,&quot;CA&quot;,1725.0,0.0],[&quot;Richland&quot;,&quot;WA&quot;,1675.0,0.0],[&quot;Annapolis&quot;,&quot;MD&quot;,1600.0,2750.0],[&quot;Duluth&quot;,&quot;MN&quot;,1590.0,600.0],[&quot;Cheyenne&quot;,&quot;WY&quot;,1560.0,300.0],[&quot;Lihue (Kauai) HI&quot;,&quot;HI&quot;,1500.0,0.0],[&quot;Pittsfield&quot;,&quot;MA&quot;,1500.0,0.0],[&quot;Newport&quot;,&quot;OR&quot;,1500.0,0.0],[&quot;Friday Harbor&quot;,&quot;WA&quot;,1500.0,0.0],[&quot;El Paso&quot;,&quot;TX&quot;,1450.0,0.0],[&quot;Westfield&quot;,&quot;NJ&quot;,1450.0,0.0],[&quot;Seaside&quot;,&quot;CA&quot;,1450.0,0.0],[&quot;South Bend&quot;,&quot;IN&quot;,1450.0,0.0],[&quot;Flagstaff&quot;,&quot;AZ&quot;,1450.0,0.0],[&quot;Doylestown&quot;,&quot;PA&quot;,1450.0,0.0],[&quot;St. Augustine&quot;,&quot;FL&quot;,1450.0,0.0],[&quot;Kalamazoo&quot;,&quot;MI&quot;,1450.0,0.0],[&quot;Rapid City&quot;,&quot;SD&quot;,1450.0,1000.0],[&quot;Astoria&quot;,&quot;OR&quot;,1435.0,100.0],[&quot;St. George&quot;,&quot;UT&quot;,1323.75,0.0],[&quot;Winchester&quot;,&quot;VA&quot;,1245.0,0.0],[&quot;Langley&quot;,&quot;WA&quot;,1245.0,0.0],[&quot;Glens Falls&quot;,&quot;NY&quot;,1225.0,0.0],[&quot;Gross Pointe&quot;,&quot;MI&quot;,1213.65,0.0],[&quot;Anacortes&quot;,&quot;WA&quot;,1200.0,0.0],[&quot;Prescott&quot;,&quot;AZ&quot;,1200.0,2000.0],[&quot;Pacifica&quot;,&quot;CA&quot;,1200.0,0.0],[&quot;Pocatello&quot;,&quot;ID&quot;,1200.0,650.0],[&quot;Ypsilanti&quot;,&quot;MI&quot;,1200.0,0.0],[&quot;Fernandina Beach&quot;,&quot;FL&quot;,1135.0,0.0],[&quot;Newark&quot;,&quot;DE&quot;,1090.0,0.0],[&quot;Ketchum&quot;,&quot;ID&quot;,1067.5,0.0],[&quot;Pasadena&quot;,&quot;CA&quot;,1040.0,0.0],[&quot;McMinnville&quot;,&quot;OR&quot;,1015.0,0.0],[&quot;Saugatuck&quot;,&quot;MI&quot;,1010.0,0.0],[&quot;Hillsborough&quot;,&quot;NC&quot;,1010.0,0.0],[&quot;Lancaster&quot;,&quot;PA&quot;,1010.0,400.0],[&quot;Amelia Island&quot;,&quot;FL&quot;,1000.15,0.0],[&quot;Jonesborough&quot;,&quot;TN&quot;,1000.0,0.0],[&quot;Jackson Hole&quot;,&quot;WY&quot;,1000.0,0.0],[&quot;Palm Desert&quot;,&quot;CA&quot;,1000.0,0.0],[&quot;Kennebunk&quot;,&quot;ME&quot;,1000.0,0.0],[&quot;Iowa City&quot;,&quot;IA&quot;,1000.0,300.0],[&quot;Juneau&quot;,&quot;AK&quot;,1000.0,0.0],[&quot;Rockford&quot;,&quot;IL&quot;,1000.0,200.0],[&quot;Newark&quot;,&quot;NJ&quot;,1000.0,50.0],[&quot;Savannah&quot;,&quot;GA&quot;,1000.0,0.0],[&quot;Fort Wayne&quot;,&quot;IN&quot;,1000.0,0.0],[&quot;New Smyrna Beach&quot;,&quot;FL&quot;,1000.0,0.0],[&quot;Tulsa&quot;,&quot;OK&quot;,1000.0,3200.0],[&quot;Springfield&quot;,&quot;IL&quot;,1000.0,400.0],[&quot;Milwaukee&quot;,&quot;WI&quot;,1000.0,80.0],[&quot;Fayetteville&quot;,&quot;AR&quot;,1000.0,700.0],[&quot;Falmouth&quot;,&quot;MA&quot;,1000.0,0.0],[&quot;Sedona&quot;,&quot;AZ&quot;,1000.0,0.0],[&quot;Steamboat Springs&quot;,&quot;CO&quot;,1000.0,0.0],[&quot;Driggs&quot;,&quot;ID&quot;,1000.0,0.0],[&quot;Chillicothe&quot;,&quot;OH&quot;,1000.0,400.0],[&quot;Woodstock&quot;,&quot;NY&quot;,1000.0,0.0],[&quot;Frederick&quot;,&quot;MD&quot;,1000.0,0.0],[&quot;Harrisburg&quot;,&quot;PA&quot;,994.05,0.0],[&quot;Modesto&quot;,&quot;CA&quot;,945.0,400.0],[&quot;Mobile&quot;,&quot;AL&quot;,945.0,1000.0],[&quot;Mount Vernon&quot;,&quot;WA&quot;,920.0,0.0],[&quot;Homer&quot;,&quot;AK&quot;,900.0,0.0],[&quot;Pequannock Township&quot;,&quot;NJ&quot;,890.0,0.0],[&quot;Lafayette&quot;,&quot;IN&quot;,890.0,0.0],[&quot;Sandpoint&quot;,&quot;ID&quot;,890.0,0.0],[&quot;Decorah&quot;,&quot;IA&quot;,890.0,0.0],[&quot;Old Saybrook&quot;,&quot;CT&quot;,890.0,0.0],[&quot;Yakima&quot;,&quot;WA&quot;,890.0,600.0],[&quot;Casper&quot;,&quot;WY&quot;,835.0,0.0],[&quot;Williamsburg&quot;,&quot;VA&quot;,835.0,0.0],[&quot;Las Cruces&quot;,&quot;NM&quot;,785.0,0.0],[&quot;Rochester&quot;,&quot;MN&quot;,780.0,0.0],[&quot;Wooster&quot;,&quot;OH&quot;,725.0,0.0],[&quot;Sharon&quot;,&quot;PA&quot;,700.0,0.0],[&quot;Murray&quot;,&quot;KY&quot;,700.0,0.0],[&quot;Sitka&quot;,&quot;AK&quot;,700.0,12.0],[&quot;Twisp&quot;,&quot;WA&quot;,690.0,0.0],[&quot;Palmer&quot;,&quot;AK&quot;,657.35,0.0],[&quot;Amarillo&quot;,&quot;TX&quot;,645.0,0.0],[&quot;Lubbock&quot;,&quot;TX&quot;,642.5,0.0],[&quot;King's Beach&quot;,&quot;CA&quot;,635.0,0.0],[&quot;Port Townsend&quot;,&quot;WA&quot;,615.0,0.0],[&quot;Fort Collins&quot;,&quot;CO&quot;,600.0,1000.0],[&quot;Augusta&quot;,&quot;GA&quot;,600.0,1700.0],[&quot;Bishop&quot;,&quot;CA&quot;,600.0,0.0],[&quot;South Lake Tahoe&quot;,&quot;CA\/NV&quot;,590.0,0.0],[&quot;Aspen&quot;,&quot;CO&quot;,560.0,0.0],[&quot;Telluride&quot;,&quot;CO&quot;,560.0,0.0],[&quot;Berkeley&quot;,&quot;CA&quot;,560.0,0.0],[&quot;Elgin&quot;,&quot;IL&quot;,560.0,0.0],[&quot;Shreveport\/Bossier&quot;,&quot;LA&quot;,560.0,0.0],[&quot;Durango&quot;,&quot;CO&quot;,560.0,0.0],[&quot;Morganton&quot;,&quot;NC&quot;,545.0,0.0],[&quot;Pendelton&quot;,&quot;OR&quot;,526.25,0.0],[&quot;Bettendorf&quot;,&quot;IA&quot;,525.0,0.0],[&quot;Bethlehem&quot;,&quot;PA&quot;,518.0,275.0],[&quot;Oneonta&quot;,&quot;NY&quot;,500.0,0.0],[&quot;Vermillion&quot;,&quot;SD&quot;,500.0,0.0],[&quot;Isla Vista&quot;,&quot;CA&quot;,500.0,0.0],[&quot;Bismarck&quot;,&quot;ND&quot;,500.0,0.0],[&quot;Melbourne\/Brevard County&quot;,&quot;FL&quot;,500.0,0.0],[&quot;Visalia&quot;,&quot;CA&quot;,500.0,0.0],[&quot;Idaho Falls&quot;,&quot;ID&quot;,500.0,0.0],[&quot;East Haddam&quot;,&quot;CT&quot;,500.0,0.0],[&quot;Silver City&quot;,&quot;NM&quot;,500.0,0.0],[&quot;Houghton&quot;,&quot;MI&quot;,500.0,0.0],[&quot;Albany&quot;,&quot;CA&quot;,500.0,0.0],[&quot;San Rafael&quot;,&quot;CA&quot;,500.0,0.0],[&quot;Clemson&quot;,&quot;SC&quot;,500.0,0.0],[&quot;Miles City&quot;,&quot;MT&quot;,500.0,0.0],[&quot;Panama City&quot;,&quot;FL&quot;,500.0,0.0],[&quot;Oak Ridge&quot;,&quot;TN&quot;,495.0,0.0],[&quot;Gulfport&quot;,&quot;MS&quot;,484.05,0.0],[&quot;New Bern&quot;,&quot;NC&quot;,480.0,1200.0],[&quot;Marquette&quot;,&quot;MI&quot;,470.0,0.0],[&quot;Green Valley&quot;,&quot;AZ&quot;,451.25,0.0],[&quot;Oxford&quot;,&quot;MS&quot;,450.0,0.0],[&quot;Cortez&quot;,&quot;CO&quot;,447.0,0.0],[&quot;Cody&quot;,&quot;WY&quot;,445.0,250.0],[&quot;Christiansted&quot;,&quot;VI&quot;,440.0,0.0],[&quot;Bentonville&quot;,&quot;AR&quot;,435.0,0.0],[&quot;Chelan&quot;,&quot;WA&quot;,431.5,0.0],[&quot;Bayfield&quot;,&quot;WI&quot;,427.0,0.0],[&quot;Carbondale&quot;,&quot;CO&quot;,425.0,0.0],[&quot;Crested Butte&quot;,&quot;CO&quot;,418.0,0.0],[&quot;Lander&quot;,&quot;WY&quot;,417.5,0.0],[&quot;Port Jervis&quot;,&quot;NY&quot;,417.5,0.0],[&quot;Plattsburgh&quot;,&quot;NY&quot;,415.1,100.0],[&quot;Women's March Online&quot;,&quot;--&quot;,415.0,0.0],[&quot;Keene&quot;,&quot;NH&quot;,404.75,0.0],[&quot;Nantucket&quot;,&quot;MA&quot;,400.0,0.0],[&quot;Midland&quot;,&quot;MI&quot;,400.0,0.0],[&quot;Woodstock&quot;,&quot;VA&quot;,400.0,0.0],[&quot;Dubuque&quot;,&quot;IA&quot;,400.0,0.0],[&quot;Mt. Shasta&quot;,&quot;CA&quot;,400.0,0.0],[&quot;Lancaster&quot;,&quot;NH&quot;,400.0,0.0],[&quot;Wyckoff&quot;,&quot;NJ&quot;,390.0,0.0],[&quot;Sequim&quot;,&quot;WA&quot;,390.0,0.0],[&quot;Sheboygan&quot;,&quot;WI&quot;,390.0,0.0],[&quot;Athens&quot;,&quot;OH&quot;,390.0,0.0],[&quot;Watsonville&quot;,&quot;CA&quot;,390.0,0.0],[&quot;Ocean City&quot;,&quot;MD&quot;,380.0,0.0],[&quot;Valparaiso&quot;,&quot;IN&quot;,368.0,0.0],[&quot;Kodiak&quot;,&quot;AK&quot;,364.25,0.0],[&quot;Bemidji&quot;,&quot;MN&quot;,362.5,0.0],[&quot;Alamosa&quot;,&quot;CO&quot;,350.0,0.0],[&quot;Cobleskill&quot;,&quot;NY&quot;,350.0,0.0],[&quot;Brunswick&quot;,&quot;ME&quot;,345.0,0.0],[&quot;Brownsville&quot;,&quot;TX&quot;,340.5,0.0],[&quot;Galesburg&quot;,&quot;IL&quot;,335.0,0.0],[&quot;State College&quot;,&quot;PA&quot;,335.0,0.0],[&quot;Esperanza&quot;,&quot;PR&quot;,322.5,0.0],[&quot;Black Mountain&quot;,&quot;NC&quot;,317.5,0.0],[&quot;Menomonie&quot;,&quot;WI&quot;,312.5,0.0],[&quot;Joseph&quot;,&quot;OR&quot;,310.0,0.0],[&quot;Salisbury&quot;,&quot;CT&quot;,305.3,0.0],[&quot;Grand Forks&quot;,&quot;ND&quot;,304.0,0.0],[&quot;Redding&quot;,&quot;CA&quot;,300.0,0.0],[&quot;Provincetown&quot;,&quot;MA&quot;,300.0,0.0],[&quot;Brighton&quot;,&quot;MI&quot;,300.0,0.0],[&quot;Burbank&quot;,&quot;CA&quot;,300.0,0.0],[&quot;Minocqua&quot;,&quot;WI&quot;,300.0,0.0],[&quot;Beaumont&quot;,&quot;TX&quot;,300.0,0.0],[&quot;Tillamook&quot;,&quot;OR&quot;,300.0,0.0],[&quot;Jackson&quot;,&quot;NH&quot;,300.0,0.0],[&quot;Florence&quot;,&quot;OR&quot;,300.0,0.0],[&quot;Lakeside&quot;,&quot;OH&quot;,300.0,0.0],[&quot;Daytona Beach&quot;,&quot;FL&quot;,300.0,0.0],[&quot;West Jefferson&quot;,&quot;NC&quot;,297.5,0.0],[&quot;Port Orford&quot;,&quot;OR&quot;,290.0,0.0],[&quot;San Juan&quot;,&quot;PR&quot;,290.0,0.0],[&quot;Red Bank&quot;,&quot;NJ&quot;,290.0,0.0],[&quot;Beaver&quot;,&quot;PA&quot;,288.0,0.0],[&quot;Beverly Hills&quot;,&quot;CA&quot;,275.0,0.0],[&quot;Brookings&quot;,&quot;OR&quot;,275.0,0.0],[&quot;Bainbridge Island&quot;,&quot;WA&quot;,267.5,0.0],[&quot;Vashon&quot;,&quot;WA&quot;,261.5,0.0],[&quot;Soldotna&quot;,&quot;AK&quot;,261.0,0.0],[&quot;Reading&quot;,&quot;PA&quot;,257.5,150.0],[&quot;Gualala&quot;,&quot;CA&quot;,251.5,0.0],[&quot;Klamath Falls&quot;,&quot;OR&quot;,250.0,0.0],[&quot;Morris&quot;,&quot;MN&quot;,250.0,0.0],[&quot;Lewes&quot;,&quot;DE&quot;,250.0,0.0],[&quot;Watertown&quot;,&quot;NY&quot;,250.0,0.0],[&quot;Ephrata&quot;,&quot;WA&quot;,250.0,0.0],[&quot;Cape Henlopen&quot;,&quot;DE&quot;,250.0,0.0],[&quot;Ajo&quot;,&quot;AZ&quot;,250.0,0.0],[&quot;Yellow Springs&quot;,&quot;OH&quot;,250.0,0.0],[&quot;Palm Springs&quot;,&quot;CA&quot;,250.0,1000.0],[&quot;Nacogdoches&quot;,&quot;TX&quot;,250.0,0.0],[&quot;Utica&quot;,&quot;NY&quot;,250.0,0.0],[&quot;St. Croix&quot;,&quot;VI&quot;,250.0,0.0],[&quot;Eastsound&quot;,&quot;WA&quot;,250.0,0.0],[&quot;Eau Claire&quot;,&quot;WI&quot;,250.0,0.0],[&quot;Sag Harbor&quot;,&quot;NY&quot;,250.0,0.0],[&quot;Ogden&quot;,&quot;UT&quot;,250.0,0.0],[&quot;Fairfax&quot;,&quot;CA&quot;,238.75,0.0],[&quot;Ellensburg&quot;,&quot;WA&quot;,237.5,0.0],[&quot;Lewis&quot;,&quot;NY&quot;,227.1,0.0],[&quot;Gloucester&quot;,&quot;NJ&quot;,225.0,0.0],[&quot;Sicklerville&quot;,&quot;NJ&quot;,225.0,0.0],[&quot;Brattleboro&quot;,&quot;VT&quot;,225.0,0.0],[&quot;Canton&quot;,&quot;NY&quot;,217.5,0.0],[&quot;Oakhurst&quot;,&quot;CA&quot;,200.5,0.0],[&quot;Statesboro&quot;,&quot;GA&quot;,200.0,0.0],[&quot;Hood River&quot;,&quot;OR&quot;,200.0,0.0],[&quot;Vieques&quot;,&quot;PR&quot;,200.0,0.0],[&quot;Harwich&quot;,&quot;MA&quot;,200.0,0.0],[&quot;Ontario&quot;,&quot;CA&quot;,200.0,0.0],[&quot;Kaunakakai (Molokai)&quot;,&quot;HI&quot;,200.0,0.0],[&quot;Fort Atkinson&quot;,&quot;WI&quot;,200.0,0.0],[&quot;Orcas Island&quot;,&quot;WA&quot;,200.0,0.0],[&quot;Fairfield&quot;,&quot;IA&quot;,200.0,0.0],[&quot;New Haven&quot;,&quot;CT&quot;,200.0,1000.0],[&quot;Cooperstown&quot;,&quot;NY&quot;,200.0,0.0],[&quot;Moab&quot;,&quot;UT&quot;,200.0,0.0],[&quot;Longview&quot;,&quot;WA&quot;,200.0,0.0],[&quot;Hagatna&quot;,&quot;GM&quot;,200.0,0.0],[&quot;Floyd&quot;,&quot;VA&quot;,200.0,0.0],[&quot;Toledo&quot;,&quot;OH&quot;,200.0,0.0],[&quot;Winters&quot;,&quot;CA&quot;,200.0,0.0],[&quot;Plymouth&quot;,&quot;WI&quot;,200.0,0.0],[&quot;Cruz Bay&quot;,&quot;VI&quot;,200.0,0.0],[&quot;Green Bay&quot;,&quot;WI&quot;,200.0,0.0],[&quot;Ocala&quot;,&quot;FL&quot;,200.0,1000.0],[&quot;Coos Bay&quot;,&quot;OR&quot;,200.0,100.0],[&quot;Kent&quot;,&quot;CT&quot;,190.0,0.0],[&quot;St. Mary of the Woods&quot;,&quot;IN&quot;,190.0,0.0],[&quot;Leonia&quot;,&quot;NJ&quot;,190.0,0.0],[&quot;Ridgecrest&quot;,&quot;CA&quot;,190.0,0.0],[&quot;Riegelsville&quot;,&quot;PA&quot;,185.0,0.0],[&quot;La Grande&quot;,&quot;OR&quot;,177.0,0.0],[&quot;West Chester&quot;,&quot;PA&quot;,175.0,0.0],[&quot;Ocean Shores&quot;,&quot;WA&quot;,175.0,0.0],[&quot;Lewisburg&quot;,&quot;PA&quot;,175.0,0.0],[&quot;Troy&quot;,&quot;OH&quot;,175.0,0.0],[&quot;Wausau&quot;,&quot;WI&quot;,175.0,0.0],[&quot;Kanab&quot;,&quot;UT&quot;,175.0,0.0],[&quot;Ketchikan&quot;,&quot;AK&quot;,175.0,0.0],[&quot;Vancouver&quot;,&quot;WA&quot;,175.0,0.0],[&quot;Haines&quot;,&quot;AK&quot;,160.0,0.0],[&quot;Truth or Consequences&quot;,&quot;NM&quot;,154.0,0.0],[&quot;Indiana&quot;,&quot;PA&quot;,150.0,0.0],[&quot;Broomfield&quot;,&quot;CO&quot;,150.0,0.0],[&quot;Vallejo&quot;,&quot;CA&quot;,150.0,0.0],[&quot;San Clemente&quot;,&quot;CA&quot;,150.0,0.0],[&quot;Greenville&quot;,&quot;NC&quot;,150.0,200.0],[&quot;Port Angeles&quot;,&quot;WA&quot;,150.0,0.0],[&quot;Adrian&quot;,&quot;MI&quot;,150.0,0.0],[&quot;Wichita Falls&quot;,&quot;TX&quot;,150.0,800.0],[&quot;Truckee&quot;,&quot;CA&quot;,150.0,0.0],[&quot;Borrego Springs&quot;,&quot;CA&quot;,145.0,0.0],[&quot;Yucca Valley&quot;,&quot;CA&quot;,138.0,0.0],[&quot;Francestown&quot;,&quot;NH&quot;,134.0,0.0],[&quot;Pierre&quot;,&quot;SD&quot;,132.5,0.0],[&quot;Tisbury&quot;,&quot;MA&quot;,130.0,0.0],[&quot;Delaware&quot;,&quot;OH&quot;,128.5,0.0],[&quot;Alliance&quot;,&quot;NE&quot;,125.0,0.0],[&quot;Loup City&quot;,&quot;NE&quot;,125.0,0.0],[&quot;Staunton&quot;,&quot;VA&quot;,125.0,100.0],[&quot;Skagway&quot;,&quot;AK&quot;,122.0,0.0],[&quot;Milford&quot;,&quot;CT&quot;,120.0,0.0],[&quot;Bakersfield&quot;,&quot;CA&quot;,119.0,2650.0],[&quot;Selingsgrove&quot;,&quot;PA&quot;,119.0,0.0],[&quot;Sanford&quot;,&quot;ME&quot;,115.0,0.0],[&quot;Valdez&quot;,&quot;AK&quot;,115.0,0.0],[&quot;Ocracoke&quot;,&quot;NC&quot;,114.0,0.0],[&quot;La Crosse&quot;,&quot;WI&quot;,113.0,0.0],[&quot;Wellfleet&quot;,&quot;MA&quot;,113.0,0.0],[&quot;Howard County&quot;,&quot;MD&quot;,112.5,0.0],[&quot;McCall&quot;,&quot;ID&quot;,112.5,0.0],[&quot;Wilton&quot;,&quot;NH&quot;,112.5,0.0],[&quot;Columbia&quot;,&quot;MD&quot;,112.5,0.0],[&quot;Eastport&quot;,&quot;ME&quot;,111.0,0.0],[&quot;Cordova&quot;,&quot;AK&quot;,111.0,0.0],[&quot;Grand Marais&quot;,&quot;MN&quot;,108.5,0.0],[&quot;Rock Springs&quot;,&quot;WY&quot;,105.0,0.0],[&quot;Gustavus&quot;,&quot;AK&quot;,105.0,0.0],[&quot;Lompoc&quot;,&quot;CA&quot;,100.0,0.0],[&quot;Glenwood Springs&quot;,&quot;CO&quot;,100.0,100.0],[&quot;Missoula&quot;,&quot;MT&quot;,100.0,500.0],[&quot;Pinedale&quot;,&quot;WY&quot;,100.0,0.0],[&quot;El Centro&quot;,&quot;CA&quot;,100.0,0.0],[&quot;Kent&quot;,&quot;OH&quot;,100.0,0.0],[&quot;Corvallis&quot;,&quot;OR&quot;,100.0,0.0],[&quot;Bennington&quot;,&quot;VT&quot;,100.0,0.0],[&quot;Taos&quot;,&quot;NM&quot;,100.0,0.0],[&quot;Ridgway&quot;,&quot;CO&quot;,100.0,0.0],[&quot;The Dalles&quot;,&quot;OR&quot;,100.0,0.0],[&quot;Nevada City&quot;,&quot;CA&quot;,100.0,0.0],[&quot;Martha's Vineyard&quot;,&quot;MA&quot;,100.0,0.0],[&quot;Pikeville&quot;,&quot;KY&quot;,100.0,0.0],[&quot;Hemet&quot;,&quot;CA&quot;,98.0,0.0],[&quot;Alpine&quot;,&quot;TX&quot;,96.0,0.0],[&quot;Huntsville&quot;,&quot;AL&quot;,95.0,2000.0],[&quot;Fairmont&quot;,&quot;WV&quot;,95.0,0.0],[&quot;Mankato&quot;,&quot;MN&quot;,95.0,200.0],[&quot;Fredonia&quot;,&quot;NY&quot;,95.0,0.0],[&quot;Lubec&quot;,&quot;ME&quot;,95.0,0.0],[&quot;Lakeville&quot;,&quot;CT&quot;,92.5,0.0],[&quot;Jerome&quot;,&quot;AZ&quot;,92.5,0.0],[&quot;Nome&quot;,&quot;AK&quot;,90.0,0.0],[&quot;Lafayette&quot;,&quot;CO&quot;,89.0,0.0],[&quot;Delhi&quot;,&quot;NY&quot;,85.0,0.0],[&quot;Unalaska (Dutch Harbor)&quot;,&quot;AK&quot;,83.0,0.0],[&quot;Clarion&quot;,&quot;PA&quot;,82.5,0.0],[&quot;Killington&quot;,&quot;VT&quot;,81.5,0.0],[&quot;Saxaphaw&quot;,&quot;NC&quot;,80.0,0.0],[&quot;Salinas&quot;,&quot;CA&quot;,80.0,0.0],[&quot;Burnsville&quot;,&quot;NC&quot;,80.0,0.0],[&quot;University Park&quot;,&quot;MD&quot;,80.0,0.0],[&quot;San Bernardino&quot;,&quot;CA&quot;,80.0,100.0],[&quot;Quincy&quot;,&quot;CA&quot;,77.5,0.0],[&quot;Vinalhaven&quot;,&quot;ME&quot;,76.0,0.0],[&quot;Marfa&quot;,&quot;TX&quot;,76.0,0.0],[&quot;Midland&quot;,&quot;TX&quot;,75.0,0.0],[&quot;Logan&quot;,&quot;UT&quot;,75.0,0.0],[&quot;Bethel&quot;,&quot;AK&quot;,70.0,0.0],[&quot;Wilmington&quot;,&quot;OH&quot;,70.0,0.0],[&quot;Bandon&quot;,&quot;OR&quot;,70.0,0.0],[&quot;Mooresville&quot;,&quot;NC&quot;,70.0,0.0],[&quot;Block Island&quot;,&quot;RI&quot;,70.0,0.0],[&quot;Longville&quot;,&quot;MN&quot;,67.0,0.0],[&quot;Paoli&quot;,&quot;IN&quot;,67.0,0.0],[&quot;Petersburg&quot;,&quot;AK&quot;,65.0,0.0],[&quot;Seward&quot;,&quot;AK&quot;,62.0,0.0],[&quot;St. Johnsbury&quot;,&quot;VT&quot;,60.0,0.0],[&quot;St. John&quot;,&quot;VI&quot;,60.0,0.0],[&quot;Kingston&quot;,&quot;WA&quot;,60.0,0.0],[&quot;St. Joseph&quot;,&quot;MI&quot;,60.0,0.0],[&quot;Ellsworth&quot;,&quot;ME&quot;,60.0,0.0],[&quot;Point Reyes Station&quot;,&quot;CA&quot;,60.0,0.0],[&quot;Mentone&quot;,&quot;AL&quot;,60.0,0.0],[&quot;Tenants Harbor&quot;,&quot;ME&quot;,57.5,0.0],[&quot;Roxbury&quot;,&quot;CT&quot;,57.5,0.0],[&quot;Union&quot;,&quot;WA&quot;,57.5,0.0],[&quot;Issaquah&quot;,&quot;WA&quot;,56.0,0.0],[&quot;Peterborough&quot;,&quot;NH&quot;,55.0,0.0],[&quot;Greensburg&quot;,&quot;IN&quot;,55.0,0.0],[&quot;Accident&quot;,&quot;MD&quot;,54.0,0.0],[&quot;Bar Harbor&quot;,&quot;ME&quot;,52.5,0.0],[&quot;Encinitas&quot;,&quot;CA&quot;,50.0,0.0],[&quot;Ely&quot;,&quot;MN&quot;,50.0,0.0],[&quot;Silverton&quot;,&quot;CO&quot;,50.0,0.0],[&quot;College Station&quot;,&quot;TX&quot;,50.0,0.0],[&quot;Bloomsburg&quot;,&quot;PA&quot;,50.0,0.0],[&quot;Southborough&quot;,&quot;MA&quot;,50.0,0.0],[&quot;Willits&quot;,&quot;CA&quot;,50.0,0.0],[&quot;Milhelm&quot;,&quot;PA&quot;,50.0,0.0],[&quot;Onley&quot;,&quot;VA&quot;,50.0,0.0],[&quot;Kawaihae&quot;,&quot;HI&quot;,50.0,0.0],[&quot;Las Vegas&quot;,&quot;NM&quot;,50.0,0.0],[&quot;Manchester&quot;,&quot;VT&quot;,50.0,0.0],[&quot;Portales&quot;,&quot;NM&quot;,50.0,0.0],[&quot;Holden Village&quot;,&quot;WA&quot;,49.5,0.0],[&quot;Clare&quot;,&quot;MI&quot;,49.5,0.0],[&quot;Bluff&quot;,&quot;UT&quot;,48.0,0.0],[&quot;Deming&quot;,&quot;NM&quot;,47.5,0.0],[&quot;Houlton&quot;,&quot;ME&quot;,47.5,0.0],[&quot;Maryville&quot;,&quot;IL&quot;,45.0,0.0],[&quot;Forks&quot;,&quot;WA&quot;,45.0,0.0],[&quot;Arden&quot;,&quot;DE&quot;,45.0,0.0],[&quot;Salida&quot;,&quot;CO&quot;,45.0,0.0],[&quot;Avalon&quot;,&quot;CA&quot;,44.0,0.0],[&quot;Angola&quot;,&quot;IN&quot;,42.0,0.0],[&quot;Seldovia&quot;,&quot;AK&quot;,41.0,0.0],[&quot;Springfield&quot;,&quot;MA&quot;,40.0,0.0],[&quot;Compton&quot;,&quot;CA&quot;,40.0,0.0],[&quot;Paonia&quot;,&quot;CO&quot;,40.0,0.0],[&quot;Romney&quot;,&quot;WV&quot;,40.0,0.0],[&quot;St. Cloud&quot;,&quot;MN&quot;,40.0,450.0],[&quot;Sault Ste Marie&quot;,&quot;MI&quot;,40.0,0.0],[&quot;Unalakleet&quot;,&quot;AK&quot;,39.0,0.0],[&quot;Kotzebue&quot;,&quot;AK&quot;,35.5,0.0],[&quot;Gouldsboro&quot;,&quot;ME&quot;,35.0,0.0],[&quot;Lake Havasu City&quot;,&quot;AZ&quot;,35.0,0.0],[&quot;Tecumseh&quot;,&quot;MI&quot;,35.0,0.0],[&quot;Zebulon&quot;,&quot;GA&quot;,35.0,0.0],[&quot;Guilford&quot;,&quot;CT&quot;,32.0,0.0],[&quot;Vienna&quot;,&quot;VA&quot;,31.5,0.0],[&quot;Halfway&quot;,&quot;OR&quot;,31.0,0.0],[&quot;Stanley&quot;,&quot;ID&quot;,30.0,0.0],[&quot;Talkeetna&quot;,&quot;AK&quot;,30.0,0.0],[&quot;Hana&quot;,&quot;HI&quot;,30.0,0.0],[&quot;Eagle Pass&quot;,&quot;TX&quot;,30.0,0.0],[&quot;Annville&quot;,&quot;PA&quot;,30.0,0.0],[&quot;El Morro&quot;,&quot;NM&quot;,30.0,0.0],[&quot;Utqiagvik (Barrow)&quot;,&quot;AK&quot;,28.5,0.0],[&quot;Copper Harbor&quot;,&quot;MI&quot;,28.0,0.0],[&quot;Nederland&quot;,&quot;CO&quot;,27.5,0.0],[&quot;Lyons&quot;,&quot;CO&quot;,27.5,0.0],[&quot;Mount Vernon&quot;,&quot;OH&quot;,25.0,0.0],[&quot;Palmdale&quot;,&quot;CA&quot;,24.0,0.0],[&quot;Lamoni&quot;,&quot;IA&quot;,24.0,0.0],[&quot;Corpus Christi&quot;,&quot;TX&quot;,24.0,500.0],[&quot;Owensboro&quot;,&quot;KY&quot;,22.5,0.0],[&quot;Monhegan Island&quot;,&quot;ME&quot;,22.0,0.0],[&quot;Cambridge&quot;,&quot;MN&quot;,22.0,0.0],[&quot;June Lake&quot;,&quot;CA&quot;,21.0,0.0],[&quot;Carmel&quot;,&quot;CA&quot;,20.0,0.0],[&quot;Beaver Island&quot;,&quot;MI&quot;,20.0,0.0],[&quot;Potsdam&quot;,&quot;NY&quot;,20.0,0.0],[&quot;Mt. Laurel&quot;,&quot;NJ&quot;,20.0,0.0],[&quot;Burns&quot;,&quot;OR&quot;,20.0,0.0],[&quot;Mitchell&quot;,&quot;IN&quot;,19.0,0.0],[&quot;Alexandria&quot;,&quot;VA&quot;,17.0,0.0],[&quot;Craftsbury&quot;,&quot;VT&quot;,15.0,0.0],[&quot;Bozeman&quot;,&quot;MT&quot;,13.0,0.0],[&quot;Huron&quot;,&quot;SD&quot;,12.0,0.0],[&quot;Bridgewater&quot;,&quot;MA&quot;,12.0,0.0],[&quot;Davis&quot;,&quot;WV&quot;,12.0,0.0],[&quot;Beaufort&quot;,&quot;NC&quot;,11.0,0.0],[&quot;St. Mary's City&quot;,&quot;MD&quot;,10.0,0.0],[&quot;Yuma&quot;,&quot;AZ&quot;,10.0,1000.0],[&quot;Adak&quot;,&quot;AK&quot;,10.0,0.0],[&quot;Skykomish&quot;,&quot;WA&quot;,8.0,0.0],[&quot;Alameda&quot;,&quot;CA&quot;,8.0,0.0],[&quot;Orford&quot;,&quot;NH&quot;,7.0,0.0],[&quot;Tuscarora&quot;,&quot;NV&quot;,7.0,0.0],[&quot;Crystal River&quot;,&quot;FL&quot;,7.0,0.0],[&quot;Westwood&quot;,&quot;CA&quot;,7.0,0.0],[&quot;Jefferson City&quot;,&quot;MO&quot;,6.5,200.0],[&quot;Minturn&quot;,&quot;CO&quot;,6.0,0.0],[&quot;Troy&quot;,&quot;PA&quot;,6.0,0.0],[&quot;Midway Atoll&quot;,&quot;--&quot;,6.0,0.0],[&quot;Bailey&quot;,&quot;CO&quot;,5.0,0.0],[&quot;Harrisville&quot;,&quot;MI&quot;,5.0,0.0],[&quot;Tupper Lake&quot;,&quot;NY&quot;,5.0,0.0],[&quot;Hospital Ward&quot;,&quot;CA&quot;,5.0,0.0],[&quot;Inverness&quot;,&quot;CA&quot;,5.0,0.0],[&quot;Lovettsville&quot;,&quot;VA&quot;,5.0,0.0],[&quot;Springfield&quot;,&quot;OH&quot;,5.0,0.0],[&quot;San Anselmo&quot;,&quot;CA&quot;,4.0,0.0],[&quot;Lilly&quot;,&quot;PA&quot;,4.0,0.0],[&quot;East Millinocket&quot;,&quot;ME&quot;,4.0,0.0],[&quot;Almanor West&quot;,&quot;CA&quot;,4.0,0.0],[&quot;Nebraska City&quot;,&quot;NE&quot;,3.0,0.0],[&quot;Sausalito&quot;,&quot;CA&quot;,3.0,0.0],[&quot;Appleton&quot;,&quot;WI&quot;,3.0,0.0],[&quot;Paradox&quot;,&quot;NY&quot;,3.0,0.0],[&quot;Lansdale&quot;,&quot;PA&quot;,3.0,0.0],[&quot;Helena&quot;,&quot;AR&quot;,2.0,0.0],[&quot;Salem&quot;,&quot;WI&quot;,2.0,0.0],[&quot;Pentwater&quot;,&quot;MI&quot;,2.0,0.0],[&quot;Bethlehem&quot;,&quot;CT&quot;,2.0,0.0],[&quot;Lovell&quot;,&quot;ME&quot;,2.0,0.0],[&quot;Cathlamet&quot;,&quot;WA&quot;,2.0,0.0],[&quot;Marshall&quot;,&quot;MN&quot;,2.0,0.0],[&quot;Cobb&quot;,&quot;CA&quot;,2.0,0.0],[&quot;Roswell&quot;,&quot;NM&quot;,2.0,0.0],[&quot;West Lima&quot;,&quot;WI&quot;,1.0,0.0],[&quot;Woods Hole&quot;,&quot;MA&quot;,1.0,0.0],[&quot;Pence&quot;,&quot;WI&quot;,1.0,0.0],[&quot;Evanston&quot;,&quot;WY&quot;,1.0,0.0],[&quot;Mora&quot;,&quot;NM&quot;,1.0,0.0],[&quot;Show Low&quot;,&quot;AZ&quot;,1.0,0.0],[&quot;Breen&quot;,&quot;CO&quot;,1.0,0.0],[&quot;Gila&quot;,&quot;NM&quot;,1.0,0.0],[&quot;Crestone&quot;,&quot;CO&quot;,1.0,0.0],[&quot;Grants Pass&quot;,&quot;OR&quot;,1.0,0.0],[&quot;Chesapeake Bay&quot;,&quot;MD&quot;,1.0,0.0],[&quot;Conover&quot;,&quot;WI&quot;,1.0,0.0],[&quot;Hilldale&quot;,&quot;UT&quot;,1.0,0.0],[&quot;Meridian&quot;,&quot;MS&quot;,0.0,100.0],[&quot;Merced&quot;,&quot;CA&quot;,0.0,200.0],[&quot;Medina&quot;,&quot;OH&quot;,0.0,1000.0],[&quot;Matamoras&quot;,&quot;PA&quot;,0.0,600.0],[&quot;Minden&quot;,&quot;LA&quot;,0.0,300.0],[&quot;Massapequa&quot;,&quot;NY&quot;,0.0,300.0],[&quot;Martinsburg&quot;,&quot;WV&quot;,0.0,300.0],[&quot;Marion&quot;,&quot;IL&quot;,0.0,100.0],[&quot;Marietta&quot;,&quot;WV&quot;,0.0,500.0],[&quot;Miami&quot;,&quot;OK&quot;,0.0,250.0],[&quot;Terre Haute&quot;,&quot;IN&quot;,0.0,0.0],[&quot;Monterey&quot;,&quot;CA&quot;,0.0,600.0],[&quot;Marble Falls&quot;,&quot;TX&quot;,0.0,1000.0],[&quot;Norwalk&quot;,&quot;OH&quot;,0.0,250.0],[&quot;North Platte&quot;,&quot;NE&quot;,0.0,50.0],[&quot;Nobelsville&quot;,&quot;IN&quot;,0.0,35.0],[&quot;Nicholson&quot;,&quot;GA&quot;,0.0,50.0],[&quot;Nicholasville&quot;,&quot;KY&quot;,0.0,250.0],[&quot;Newport News&quot;,&quot;VA&quot;,0.0,250.0],[&quot;New Richmond&quot;,&quot;WI&quot;,0.0,80.0],[&quot;New Braunfels&quot;,&quot;TX&quot;,0.0,300.0],[&quot;Neunan&quot;,&quot;GA&quot;,0.0,200.0],[&quot;Natrona&quot;,&quot;WY&quot;,0.0,1000.0],[&quot;Natchez&quot;,&quot;MS&quot;,0.0,75.0],[&quot;Naperville&quot;,&quot;IL&quot;,0.0,500.0],[&quot;Myrtle Beach&quot;,&quot;SC&quot;,0.0,500.0],[&quot;Muskegon&quot;,&quot;MI&quot;,0.0,300.0],[&quot;Morristown&quot;,&quot;NJ&quot;,0.0,600.0],[&quot;Montgomery&quot;,&quot;AL&quot;,0.0,1000.0],[&quot;Lynchburg&quot;,&quot;VA&quot;,0.0,1200.0],[&quot;Manchester&quot;,&quot;NH&quot;,0.0,1000.0],[&quot;Oceanside&quot;,&quot;CA&quot;,0.0,1000.0],[&quot;Gilmer&quot;,&quot;TX&quot;,0.0,250.0],[&quot;Glendale&quot;,&quot;CA&quot;,0.0,275.0],[&quot;Goldsboro&quot;,&quot;NC&quot;,0.0,300.0],[&quot;Green Cove Springs&quot;,&quot;FL&quot;,0.0,30.0],[&quot;Greensboro&quot;,&quot;NC 1000&quot;,0.0,0.0],[&quot;Greenville&quot;,&quot;TN&quot;,0.0,100.0],[&quot;Hannibal&quot;,&quot;MO&quot;,0.0,200.0],[&quot;Harrisburg&quot;,&quot;IL&quot;,0.0,300.0],[&quot;Harrison&quot;,&quot;AR&quot;,0.0,300.0],[&quot;Havasu&quot;,&quot;AZ&quot;,0.0,2250.0],[&quot;Herrin&quot;,&quot;IL&quot;,0.0,65.0],[&quot;Hollidaysburg&quot;,&quot;PA&quot;,0.0,450.0],[&quot;Honolulu&quot;,&quot;HI&quot;,0.0,400.0],[&quot;Houma&quot;,&quot;LA&quot;,0.0,600.0],[&quot;Hudsonville&quot;,&quot;MI&quot;,0.0,1000.0],[&quot;Hyannis&quot;,&quot;MA&quot;,0.0,600.0],[&quot;Jackson&quot;,&quot;MI&quot;,0.0,450.0],[&quot;Joliet&quot;,&quot;IL&quot;,0.0,300.0],[&quot;Joplin&quot;,&quot;MO&quot;,0.0,1000.0],[&quot;Kalispell&quot;,&quot;MT&quot;,0.0,150.0],[&quot;Kingston&quot;,&quot;NY&quot;,0.0,100.0],[&quot;Lake City&quot;,&quot;WA&quot;,0.0,24.0],[&quot;Lakewood Ranch&quot;,&quot;FL&quot;,0.0,300.0],[&quot;Lexington&quot;,&quot;NE&quot;,0.0,400.0],[&quot;Lisbon&quot;,&quot;OH&quot;,0.0,500.0],[&quot;Lisle&quot;,&quot;IL&quot;,0.0,1000.0],[&quot;Livonia&quot;,&quot;MI&quot;,0.0,400.0],[&quot;Longview&quot;,&quot;TX&quot;,0.0,650.0],[&quot;Loveland&quot;,&quot;CO&quot;,0.0,1000.0],[&quot;Oak Harbor&quot;,&quot;WA&quot;,0.0,100.0],[&quot;Parkersburg&quot;,&quot;WV&quot;,0.0,300.0],[&quot;Opelousas&quot;,&quot;AL&quot;,0.0,50.0],[&quot;Shelton&quot;,&quot;CT&quot;,0.0,100.0],[&quot;South Kitsap&quot;,&quot;WA&quot;,0.0,150.0],[&quot;Southlake&quot;,&quot;TX&quot;,0.0,500.0],[&quot;St. Paul&quot;,&quot;MN&quot;,0.0,2000.0],[&quot;St. Simons Island&quot;,&quot;FL&quot;,0.0,500.0],[&quot;Stockton&quot;,&quot;CA&quot;,0.0,200.0],[&quot;Stuart&quot;,&quot;FL&quot;,0.0,2000.0],[&quot;Superior&quot;,&quot;WI&quot;,0.0,200.0],[&quot;Tampa&quot;,&quot;FL&quot;,0.0,500.0],[&quot;Temecula&quot;,&quot;CA&quot;,0.0,1000.0],[&quot;Thousand Oaks&quot;,&quot;CA&quot;,0.0,338.0],[&quot;Troy&quot;,&quot;MI&quot;,0.0,2000.0],[&quot;Tuscaloosa&quot;,&quot;AL&quot;,0.0,600.0],[&quot;Tyler&quot;,&quot;TX&quot;,0.0,1500.0],[&quot;Valdosta&quot;,&quot;GA&quot;,0.0,400.0],[&quot;Vero Beach&quot;,&quot;FL&quot;,0.0,3500.0],[&quot;Vineland&quot;,&quot;NJ&quot;,0.0,100.0],[&quot;Virginia Beach&quot;,&quot;VA&quot;,0.0,650.0],[&quot;Waco&quot;,&quot;TX&quot;,0.0,1100.0],[&quot;Walton&quot;,&quot;FL&quot;,0.0,200.0],[&quot;Wasilla&quot;,&quot;AK&quot;,0.0,850.0],[&quot;Watkinsville&quot;,&quot;GA&quot;,0.0,150.0],[&quot;West Covina&quot;,&quot;CA&quot;,0.0,60.0],[&quot;Westerville&quot;,&quot;OH&quot;,0.0,50.0],[&quot;Wheeling&quot;,&quot;WV&quot;,0.0,2000.0],[&quot;Wilmington&quot;,&quot;DE&quot;,0.0,1000.0],[&quot;York&quot;,&quot;SC&quot;,0.0,300.0],[&quot;Youngstown&quot;,&quot;OH&quot;,0.0,200.0],[&quot;Simi Valley&quot;,&quot;CA&quot;,0.0,150.0],[&quot;Sevierville&quot;,&quot;TN&quot;,0.0,40.0],[&quot;Oswego&quot;,&quot;IL&quot;,0.0,200.0],[&quot;Selma&quot;,&quot;AL&quot;,0.0,30.0],[&quot;Palmer Township&quot;,&quot;PA&quot;,0.0,200.0],[&quot;Pappilon&quot;,&quot;NE&quot;,0.0,200.0],[&quot;Gastonia&quot;,&quot;NC&quot;,0.0,100.0],[&quot;Pataskala&quot;,&quot;OH&quot;,0.0,30.0],[&quot;Pearland&quot;,&quot;TX&quot;,0.0,450.0],[&quot;Piscataway&quot;,&quot;NJ&quot;,0.0,500.0],[&quot;Pismo Beach&quot;,&quot;CA&quot;,0.0,200.0],[&quot;Pittsburg\/Antoich&quot;,&quot;CA&quot;,0.0,50.0],[&quot;Pittsfield&quot;,&quot;NY&quot;,0.0,100.0],[&quot;Plainville&quot;,&quot;CT&quot;,0.0,13.0],[&quot;Pleasanton&quot;,&quot;CA&quot;,0.0,2000.0],[&quot;Plymouth&quot;,&quot;MI&quot;,0.0,1000.0],[&quot;Port St. Lucie&quot;,&quot;FL&quot;,0.0,500.0],[&quot;Pullman&quot;,&quot;WA&quot;,0.0,150.0],[&quot;Redlands&quot;,&quot;CA&quot;,0.0,500.0],[&quot;Richmond&quot;,&quot;CA&quot;,0.0,30.0],[&quot;Richmond Hill&quot;,&quot;GA&quot;,0.0,60.0],[&quot;Rochester&quot;,&quot;NH&quot;,0.0,200.0],[&quot;Roseburg&quot;,&quot;OR&quot;,0.0,750.0],[&quot;Rowlett&quot;,&quot;TX&quot;,0.0,200.0],[&quot;Rutland&quot;,&quot;VT&quot;,0.0,300.0],[&quot;San Marcos&quot;,&quot;TX&quot;,0.0,90.0],[&quot;San Mateo&quot;,&quot;CA&quot;,0.0,250.0],[&quot;Sandusky&quot;,&quot;OH&quot;,0.0,300.0],[&quot;Scranton&quot;,&quot;PA&quot;,0.0,200.0],[&quot;Seal Beach&quot;,&quot;CA&quot;,0.0,1000.0],[&quot;Seguin&quot;,&quot;TX&quot;,0.0,200.0],[&quot;Gilbert&quot;,&quot;AZ&quot;,0.0,1000.0],[&quot;Frankfort&quot;,&quot;KY&quot;,0.0,250.0],[&quot;Gardiner&quot;,&quot;NY&quot;,0.0,400.0],[&quot;Anderson&quot;,&quot;IN&quot;,0.0,100.0],[&quot;Enterprise&quot;,&quot;OR&quot;,0.0,0.0],[&quot;Elkton&quot;,&quot;OR&quot;,0.0,0.0],[&quot;Elizabethtown&quot;,&quot;NY&quot;,0.0,0.0],[&quot;Eau Gallie&quot;,&quot;FL&quot;,0.0,0.0],[&quot;Worcester&quot;,&quot;MA&quot;,0.0,0.0],[&quot;Conway&quot;,&quot;NH&quot;,0.0,0.0],[&quot;Cedaredge&quot;,&quot;CO&quot;,0.0,0.0],[&quot;Arlington&quot;,&quot;VA&quot;,0.0,0.0],[&quot;Altoona&quot;,&quot;PA&quot;,0.0,0.0],[&quot;Abilene&quot;,&quot;TX&quot;,0.0,800.0],[&quot;Abingdon&quot;,&quot;VA&quot;,0.0,400.0],[&quot;Ada&quot;,&quot;OK&quot;,0.0,200.0],[&quot;Albany&quot;,&quot;OR&quot;,0.0,140.0],[&quot;Ashland&quot;,&quot;OH&quot;,0.0,600.0],[&quot;Gadsden&quot;,&quot;AL&quot;,0.0,35.0],[&quot;Ashtabula&quot;,&quot;OH&quot;,0.0,275.0],[&quot;Astacadero&quot;,&quot;CA&quot;,0.0,850.0],[&quot;Bad Axe&quot;,&quot;MI&quot;,0.0,100.0],[&quot;Bangor&quot;,&quot;ME&quot;,0.0,300.0],[&quot;Bartow&quot;,&quot;FL&quot;,0.0,200.0],[&quot;Baton Rouge&quot;,&quot;LA&quot;,0.0,1000.0],[&quot;Baxter&quot;,&quot;AR&quot;,0.0,1000.0],[&quot;Beaumount&quot;,&quot;TX&quot;,0.0,1000.0],[&quot;Bellevue&quot;,&quot;WA&quot;,0.0,200.0],[&quot;Belton&quot;,&quot;TX&quot;,0.0,2000.0],[&quot;Billings&quot;,&quot;MT&quot;,0.0,500.0],[&quot;Bloomington&quot;,&quot;IN&quot;,0.0,200.0],[&quot;Boiling Springs&quot;,&quot;SC&quot;,0.0,120.0],[&quot;Winston-Salem&quot;,&quot;NC&quot;,0.0,900.0],[&quot;Evansville&quot;,&quot;IN&quot;,0.0,150.0],[&quot;Fort Sumner&quot;,&quot;NM&quot;,0.0,0.0],[&quot;Gold Canyon&quot;,&quot;AZ&quot;,0.0,0.0],[&quot;St. Thomas&quot;,&quot;VI&quot;,0.0,0.0],[&quot;St. John&quot;,&quot;VA&quot;,0.0,0.0],[&quot;Santurce&quot;,&quot;PR&quot;,0.0,0.0],[&quot;Sandy&quot;,&quot;OR&quot;,0.0,0.0],[&quot;San Leandro&quot;,&quot;CA&quot;,0.0,0.0],[&quot;Vineyard Haven&quot;,&quot;MA&quot;,0.0,0.0],[&quot;San Juan Island&quot;,&quot;WA&quot;,0.0,0.0],[&quot;Pompton Plains&quot;,&quot;NJ&quot;,0.0,0.0],[&quot;Orange County&quot;,&quot;CA&quot;,0.0,0.0],[&quot;Murfreesboro&quot;,&quot;TN&quot;,0.0,0.0],[&quot;Monterey Bay&quot;,&quot;CA&quot;,0.0,0.0],[&quot;Minneapolis&quot;,&quot;MN&quot;,0.0,0.0],[&quot;Welches&quot;,&quot;OR&quot;,0.0,0.0],[&quot;Miami Beach&quot;,&quot;FL&quot;,0.0,0.0],[&quot;Merrill&quot;,&quot;MI&quot;,0.0,0.0],[&quot;Mayaguez&quot;,&quot;PR&quot;,0.0,0.0],[&quot;Marina&quot;,&quot;CA&quot;,0.0,0.0],[&quot;Laramie&quot;,&quot;WY&quot;,0.0,0.0],[&quot;West Orange&quot;,&quot;NJ&quot;,0.0,0.0],[&quot;Kauai&quot;,&quot;HI&quot;,0.0,0.0],[&quot;West Plains&quot;,&quot;MO&quot;,0.0,0.0],[&quot;Idyllwild&quot;,&quot;CA&quot;,0.0,0.0],[&quot;Hillsboro&quot;,&quot;WI&quot;,0.0,0.0],[&quot;Whitefish&quot;,&quot;MT&quot;,0.0,0.0],[&quot;Hattiesburg&quot;,&quot;MS&quot;,0.0,0.0],[&quot;Greenwood&quot;,&quot;IN&quot;,0.0,0.0],[&quot;Willow Springs&quot;,&quot;MO&quot;,0.0,0.0],[&quot;Borger&quot;,&quot;TX&quot;,0.0,275.0],[&quot;Bossier City&quot;,&quot;LA&quot;,0.0,5000.0],[&quot;Bound Book&quot;,&quot;NJ&quot;,0.0,20.0],[&quot;Deland&quot;,&quot;FL&quot;,0.0,1500.0],[&quot;Dickinson&quot;,&quot;ND&quot;,0.0,200.0],[&quot;Doral&quot;,&quot;FL&quot;,0.0,800.0],[&quot;Dover&quot;,&quot;NH&quot;,0.0,125.0],[&quot;Edenton&quot;,&quot;NC&quot;,0.0,400.0],[&quot;El Dorado&quot;,&quot;AR&quot;,0.0,300.0],[&quot;Elba&quot;,&quot;AL&quot;,0.0,400.0],[&quot;Elizabeth City&quot;,&quot;NC&quot;,0.0,150.0],[&quot;Elizabethtown&quot;,&quot;KY&quot;,0.0,275.0],[&quot;Emporia&quot;,&quot;KS&quot;,0.0,150.0],[&quot;Escondido&quot;,&quot;CA&quot;,0.0,2000.0],[&quot;Farmington&quot;,&quot;NM&quot;,0.0,600.0],[&quot;Fayetteville&quot;,&quot;GA&quot;,0.0,200.0],[&quot;Fayetteville&quot;,&quot;NC&quot;,0.0,300.0],[&quot;Fishersville&quot;,&quot;VA&quot;,0.0,500.0],[&quot;Flemington&quot;,&quot;NJ&quot;,0.0,200.0],[&quot;Florence&quot;,&quot;AL&quot;,0.0,350.0],[&quot;Fon du Lac&quot;,&quot;WI&quot;,0.0,300.0],[&quot;Fort Lauderdale&quot;,&quot;FL&quot;,0.0,1750.0],[&quot;Fort Mill&quot;,&quot;SC&quot;,0.0,80.0],[&quot;Fort Myers&quot;,&quot;FL&quot;,0.0,4000.0],[&quot;Fort Plain&quot;,&quot;NY&quot;,0.0,12.0],[&quot;Fort Scott&quot;,&quot;KS&quot;,0.0,200.0],[&quot;Fort Smith&quot;,&quot;AR&quot;,0.0,500.0],[&quot;Surry&quot;,&quot;ME&quot;,0.0,0.0],[&quot;Fremont&quot;,&quot;OH&quot;,0.0,100.0],[&quot;Friendswood&quot;,&quot;TX&quot;,0.0,300.0],[&quot;Frisco&quot;,&quot;CO&quot;,0.0,50.0],[&quot;Des Monies&quot;,&quot;IA&quot;,0.0,5000.0],[&quot;Dekalb&quot;,&quot;AL&quot;,0.0,200.0],[&quot;Bradenton&quot;,&quot;FL&quot;,0.0,75.0],[&quot;Defiance&quot;,&quot;OH&quot;,0.0,175.0],[&quot;Bremerton&quot;,&quot;WA&quot;,0.0,100.0],[&quot;Bristol&quot;,&quot;TN&quot;,0.0,100.0],[&quot;Burleson&quot;,&quot;TX&quot;,0.0,500.0],[&quot;Camden&quot;,&quot;NY&quot;,0.0,100.0],[&quot;Camdenton&quot;,&quot;MO&quot;,0.0,300.0],[&quot;Canton&quot;,&quot;OH&quot;,0.0,2500.0],[&quot;Carmel Mountain Ranch&quot;,&quot;CA&quot;,0.0,1000.0],[&quot;Carson City&quot;,&quot;NV&quot;,0.0,2000.0],[&quot;Carterville&quot;,&quot;IL&quot;,0.0,40.0],[&quot;Cedar Rapids&quot;,&quot;IA&quot;,0.0,600.0],[&quot;Chelsea&quot;,&quot;MI&quot;,0.0,250.0],[&quot;Chester&quot;,&quot;NY&quot;,0.0,80.0],[&quot;Chico&quot;,&quot;WA&quot;,0.0,100.0],[&quot;Clarksville&quot;,&quot;TN&quot;,0.0,500.0],[&quot;Cleveland&quot;,&quot;TN&quot;,0.0,200.0],[&quot;Coldwater&quot;,&quot;MI&quot;,0.0,200.0],[&quot;Columbus&quot;,&quot;GA&quot;,0.0,300.0],[&quot;Columbus&quot;,&quot;IN&quot;,0.0,2000.0],[&quot;Columbus&quot;,&quot;MS&quot;,0.0,400.0],[&quot;Corona&quot;,&quot;CA&quot;,0.0,65.0],[&quot;Cotulla&quot;,&quot;TX&quot;,0.0,80.0],[&quot;Council Bluffs&quot;,&quot;IA&quot;,0.0,150.0],[&quot;Craig&quot;,&quot;CO&quot;,0.0,221.0],[&quot;Crown Point&quot;,&quot;IN- 100&quot;,0.0,0.0],[&quot;Crystal Lake&quot;,&quot;IL&quot;,0.0,200.0],[&quot;Cullman&quot;,&quot;AL&quot;,0.0,1000.0],[&quot;Currituck&quot;,&quot;NC&quot;,0.0,150.0],[&quot;Yucaipa&quot;,&quot;CA&quot;,0.0,200.0]];

        //TABLE HEAD
        var tr = document.createElement('tr');
        tableHead.appendChild(tr);
        for (i = 0; i < heading.length; i++) {
            var th = document.createElement('th')
            //th.width = '75';
            th.appendChild(document.createTextNode(heading[i]));
            tr.appendChild(th);
        }

        //TABLE ROWS
        for (i = 0; i < data.length; i++) {
            var tr = document.createElement('TR');
            for (j = 0; j < data[i].length; j++) {
                var td = document.createElement('TD')
                td.appendChild(document.createTextNode(data[i][j]));
                tr.appendChild(td)
            }
            tableBody.appendChild(tr);
        }  
        tableDiv.appendChild(table)

    }

    window.onload = function () {addTable(); makeAllSortable(); };
    // use callback makeAllSortable(); at end?
    // window.onload = function () {addTable(makeAllSortable);  };  

    </script>

    </body>
    </html>" style="width: 450px; height: 500px; 
            display:block; margin: 25px auto; border: none"></iframe>



## Binned and Counted

This next plot groups the marches by size and counts them.  It's clear that the majority of both protests took place in groups of 200,000 or less, and that the Women's March dwarfed the Tea Party in size.  


<figure>
	<a href="{{ site.baseurl }}/images/march/output_13_0.png"><img src="{{ site.baseurl }}/images/march/output_13_0.png"></a>
</figure>


## Marchers by State

Next, I look at the marchers grouped by state.  Every state except West Virginia had a larger percentage participate in the Women's March, with Colorado leading with **2.9%** of their population.  California had the largest total number of protesters, at **910,830**. 

<figure>
	<a href="{{ site.baseurl }}/images/march/output_17_0.png"><img src="{{ site.baseurl }}/images/march/output_17_0.png"></a>
</figure>


<iframe srcdoc="
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset=&quot;utf-8&quot;>
    <style>

    /*
    body {
        width: 800px;
    }*/

    table {
        font-size: 12px;
        border-collapse: collapse;
        border-top: 1px solid #ddd;
        border-right: 1px solid #ddd;
    }

    th {
        padding: 10px;
        cursor: pointer;
        background-color: #f2f2f2;
    }

    th, td {
        text-align: left;
        border-bottom: 1px solid #ddd;
        border-left: 1px solid #ddd;
    }

    td {
        padding: 5px 8px;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    tr:hover {
      background-color: #F0F8FF; /*#f9f9f9;*/
    }

    </style>
    </head>

    <body>

    <div id =&quot;tableInsert&quot;></div>

    <script>
    //http://stackoverflow.com/questions/14267781/sorting-html-table-with-javascript

    function sortTable(table, col, reverse) {
        var tb = table.tBodies[0], 
            tr = Array.prototype.slice.call(tb.rows, 0), // put rows into array
            i;

        reverse = -((+reverse) || -1);
        tr = tr.sort(function (a, b) { 
            var first = a.cells[col].textContent.trim();
            var second = b.cells[col].textContent.trim();

            if (isNumeric(first) && isNumeric(second)) {        
                return reverse * (Number(first) - Number(second));
            } else {
                return reverse * first.localeCompare(second);
            };
        });
        for(i = 0; i < tr.length; ++i) {  // append each row in order
            tb.appendChild(tr[i]);
        }
    }

    //http://stackoverflow.com/questions/18082
    function isNumeric(n) {
      return !isNaN(parseFloat(n)) && isFinite(n);
    }

    function makeSortable(table) {
        var th = table.tHead, i;
        th && (th = th.rows[0]) && (th = th.cells);
        if (th) i = th.length;
        else return; // if no `<thead>` then do nothing
        while (--i >= 0) (function (i) {
            var dir = 1;
            th[i].addEventListener('click', function () {sortTable(table, i, (dir = 1 - dir))});
        }(i));
    }

    function makeAllSortable(parent) {
        parent = parent || document.body;
        var t = parent.getElementsByTagName('table'), i = t.length;
        while (--i >= 0) makeSortable(t[i]);
    }

    function addTable() {
        var tableDiv = document.getElementById(&quot;tableInsert&quot;)
        var table = document.createElement('table')
        var tableHead = document.createElement('thead')
        var tableBody = document.createElement('tbody')

        table.appendChild(tableHead)
        table.appendChild(tableBody);

        var heading = [&quot;state&quot;, &quot;march_num&quot;, &quot;tea_num&quot;, &quot;margin2016&quot;, &quot;pop2016&quot;, &quot;tea_pct&quot;, &quot;march_pct&quot;];
        var data = [[&quot;CO&quot;,162287.0,11371.0,4.9,5540545,0.2052325177,2.9290800815],[&quot;VT&quot;,17781.5,800.0,26.4,624594,0.1280832028,2.8468893393],[&quot;OR&quot;,116497.75,4790.0,11.0,4093465,0.11701578,2.8459446948],[&quot;MA&quot;,183571.0,3100.0,27.2,6811779,0.0455094036,2.6949053984],[&quot;NY&quot;,496782.4,6992.0,22.5,19745289,0.0354109783,2.5159540587],[&quot;WA&quot;,172981.0,10824.0,15.5,7288000,0.148518112,2.3735043908],[&quot;CA&quot;,910830.25,25718.0,30.1,39250017,0.0655235385,2.3205856191],[&quot;IL&quot;,261925.0,6255.0,17.1,12801539,0.0488613127,2.0460430578],[&quot;MN&quot;,97867.0,3250.0,1.5,5519952,0.0588773236,1.7729683157],[&quot;WI&quot;,89825.5,5660.0,-0.8,5778708,0.0979457692,1.5544218535],[&quot;ME&quot;,19272.5,900.0,3.0,1331479,0.0675940064,1.4474505418],[&quot;AK&quot;,10124.6,2362.0,-14.7,741894,0.318374323,1.3646963043],[&quot;NM&quot;,23270.5,1600.0,8.2,2081015,0.0768855582,1.1182283645],[&quot;HI&quot;,15145.0,650.0,32.2,1428557,0.0455004596,1.0601607076],[&quot;MT&quot;,10613.0,1350.0,-20.4,1042520,0.1294939186,1.0180140429],[&quot;NE&quot;,17853.0,800.0,-25.0,1907116,0.0419481563,0.9361255424],[&quot;IA&quot;,29039.0,6050.0,-9.4,3134693,0.1930013561,0.9263746083],[&quot;NH&quot;,10213.25,2125.0,0.4,1334795,0.1592004765,0.7651549489],[&quot;WY&quot;,4463.5,1550.0,-46.3,585501,0.264730547,0.7623385784],[&quot;ID&quot;,12300.0,3250.0,-31.8,1683140,0.1930914838,0.7307770001],[&quot;PA&quot;,86757.05,2475.0,-0.7,12784227,0.0193597939,0.6786257002],[&quot;NV&quot;,18957.0,2700.0,2.4,2940058,0.091834923,0.6447831982],[&quot;GA&quot;,65820.0,18060.0,-5.2,10310371,0.175163435,0.6383863393],[&quot;SD&quot;,5394.5,4000.0,-29.8,865454,0.4621851652,0.6233144685],[&quot;AZ&quot;,41739.75,13000.0,-3.5,6931071,0.1875612009,0.6022121257],[&quot;NC&quot;,60605.0,6400.0,-3.7,10146788,0.0630741472,0.5972826081],[&quot;RI&quot;,5970.0,2000.0,15.5,1056426,0.189317567,0.5651129374],[&quot;UT&quot;,17222.75,1500.0,-18.1,3051217,0.0491607119,0.564455101],[&quot;CT&quot;,17389.3,4113.0,13.6,3576452,0.1150022424,0.4862165073],[&quot;MI&quot;,47343.15,10400.0,-0.2,9928300,0.1047510651,0.4768505182],[&quot;TN&quot;,29695.0,8540.0,-26.0,6651194,0.1283979989,0.4464611918],[&quot;FL&quot;,91717.15,27955.0,-1.2,20612439,0.1356219902,0.444960201],[&quot;MO&quot;,26478.3,4700.0,-18.6,6093000,0.077137699,0.4345691777],[&quot;ND&quot;,2704.0,200.0,-35.7,757952,0.0263868952,0.3567508233],[&quot;TX&quot;,92723.15,28945.0,-9.0,27862596,0.1038847924,0.332787189],[&quot;KY&quot;,13072.5,1775.0,-29.8,4436974,0.040004742,0.2946264729],[&quot;AR&quot;,8437.0,3300.0,-26.9,2988248,0.1104326013,0.2823393507],[&quot;OH&quot;,32168.5,13580.0,-8.1,11614373,0.1169240905,0.2769714732],[&quot;OK&quot;,10250.0,8150.0,-36.4,3923561,0.2077194671,0.2612422746],[&quot;LA&quot;,11160.0,6900.0,-19.6,4681666,0.1473834315,0.2383766804],[&quot;KS&quot;,6450.0,2850.0,-20.6,2907289,0.0980294701,0.2218561691],[&quot;NJ&quot;,19580.0,1870.0,14.1,8944469,0.0209067749,0.2189062313],[&quot;DE&quot;,1635.0,1000.0,11.4,952065,0.1050348453,0.1717319721],[&quot;AL&quot;,8350.0,6665.0,-27.7,4863300,0.1370468612,0.1716941172],[&quot;IN&quot;,10781.0,6110.0,-19.2,6633053,0.0921144456,0.1625345071],[&quot;VA&quot;,13168.5,7600.0,5.3,8411808,0.0903491853,0.1565477957],[&quot;WV&quot;,2597.0,3650.0,-42.2,1831102,0.1993335161,0.141827162],[&quot;SC&quot;,6950.0,6150.0,-14.3,4961119,0.1239639686,0.1400893629],[&quot;MD&quot;,8350.0,2900.0,26.4,6016447,0.0482012058,0.1387862305],[&quot;MS&quot;,3596.55,3075.0,-17.8,2988726,0.102886648,0.1203372273]];

        //TABLE HEAD
        var tr = document.createElement('tr');
        tableHead.appendChild(tr);
        for (i = 0; i < heading.length; i++) {
            var th = document.createElement('th')
            //th.width = '75';
            th.appendChild(document.createTextNode(heading[i]));
            tr.appendChild(th);
        }

        //TABLE ROWS
        for (i = 0; i < data.length; i++) {
            var tr = document.createElement('TR');
            for (j = 0; j < data[i].length; j++) {
                var td = document.createElement('TD')
                td.appendChild(document.createTextNode(data[i][j]));
                tr.appendChild(td)
            }
            tableBody.appendChild(tr);
        }  
        tableDiv.appendChild(table)

    }

    window.onload = function () {addTable(); makeAllSortable(); };
    // use callback makeAllSortable(); at end?
    // window.onload = function () {addTable(makeAllSortable);  };  

    </script>

    </body>
    </html>" style="width: 600px; height: 500px; 
            display:block; margin: 25px auto; border: none"></iframe>
            


## Did blue states have more marchers?

The Democratic margin for president is a fairly good indicator for the Women's March participation.  Some states overperformed (CA, OR, MA, VT, WA, IL) or underperformed the linear regression line, although some of the underperformers are states adjacent to DC.   

<figure>
	<a href="{{ site.baseurl }}/images/march/output_19_0.png"><img src="{{ site.baseurl }}/images/march/output_19_0.png"></a>
</figure>

## Conclusion

Overall, this is pretty encouraging for Democrats.  The main challenge now is to harness this energy for political change.  Recent attendance at town halls and activism from grassroots organizations suggests this might already be happening.  