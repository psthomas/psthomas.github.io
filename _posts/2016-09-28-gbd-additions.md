---
layout: post
title: "Potential Additions to the Global Burden of Disease Study"
excerpt: "I look at the potential impact of including pandemic disease and a longer life expectancy into the GBD estimates."
#modified: 2016-02-22
tags: [IHME, GBD, Global Burden of Disease, DALY, Python, Pandas]
comments: true
share: false

---

<style type="text/css">
svg {
  font: 10px sans-serif;
  shape-rendering: crispEdges;
}
.axis path,
.axis line {
  fill: none;
  stroke: #000;
}

path.domain {
  stroke: none;
}

.y .tick line {
  stroke: #ddd;
}
div.tooltip {   
  position: absolute;           
  text-align: left;           
  width: 200px;                  
  height: 40px;                 
  padding: 6px;              
  font: 12px sans-serif;        
  background: #EEEEEE; 
  border: 2px solid #b8b8b8; /*#FC9272;*/      
  border-radius: 5px;          
  pointer-events: none;         
}
</style>


The Global Burden of Disease (GBD) study is a comprehensive look at the magnitude and causes of lost life years globally.  This [project began](http://www.who.int/healthinfo/global_burden_disease/about/en/) as a World Health Organization (WHO) initiative in 1990, and went through a major update in 2010.  The [Institute for Health Metrics and Evaluation](http://www.healthdata.org/gbd) (IHME) played a leading role in the most recent update, organizing over 1600 GBD collaborators from 16 countries.  

One interesting tool that they built is the [GBD Compare](http://www.healthdata.org/data-visualization/gbd-compare) visualization for viewing and interacting with the data.  This tool is especially helpful for comparing the scale of different public health problems, and how they relate to one another.  For example, here is a re-creation of one of their [visualizations](http://ihmeuw.org/3wfa) using D3.js, showing the total Disability Adjusted Life Years (DALY) burden by year for the world population:

<div id="chart"></div>

The rest of this post looks at a few other disease burdens that it might make sense to add to the GBD analysis.

**First**, I think they should add the annualized burden of potential pandemic disease to the study.  **Second**, it might make sense to increase the reference life expectancy so that years of life lost due to future increases in the life expectancy are incorporated into the estimates.  I provide the computations and graphics to visualize the scale of each one of these new burdens below.  All of the code for this post is available in an IPython notebook [here](https://gist.github.com/psthomas/fbda754b145dbdcf3c7c266228db51af).


<br/>

# Importing the Data

All of the data for this post can be accessed by visiting the [visualization](http://ihmeuw.org/3wfa) and clicking the download button in the upper right corner.  I obtained the life table that I use later from the Web Table 6 of the supplementary appendix: [PDF](http://www.thelancet.com/cms/attachment/2017336178/2037711222/mmc1.pdf).  The CSVs are also available as a zipped file [here](https://www.dropbox.com/s/9mn545f8kz4bmgf/gbd_data.zip?dl=1).

The initial data shows global DALY burden by cause for a number of years between 1990 and 2013.   


{% highlight python %}
gbd_df = pd.read_csv('./GBD_global_data.csv')
gbd_df.head()
{% endhighlight %}




<div>
<table>
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>﻿Location</th>
      <th>Year</th>
      <th>Age</th>
      <th>Sex</th>
      <th>Cause of death or injury</th>
      <th>Measure</th>
      <th>Value</th>
      <th>Lower bound</th>
      <th>Upper bound</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Global</td>
      <td>1990</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Forces of nature, war, and legal intervention</td>
      <td>DALYs</td>
      <td>13650843.806051</td>
      <td>8198677.494192</td>
      <td>23356495.474653</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Global</td>
      <td>1995</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Forces of nature, war, and legal intervention</td>
      <td>DALYs</td>
      <td>11243358.692292</td>
      <td>6430940.583227</td>
      <td>20036013.689167</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Global</td>
      <td>2000</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Forces of nature, war, and legal intervention</td>
      <td>DALYs</td>
      <td>13874813.144494</td>
      <td>8648476.130667</td>
      <td>23398335.472656</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Global</td>
      <td>2005</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Forces of nature, war, and legal intervention</td>
      <td>DALYs</td>
      <td>11121526.833311</td>
      <td>6687655.473904</td>
      <td>18862473.121176</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Global</td>
      <td>2010</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Forces of nature, war, and legal intervention</td>
      <td>DALYs</td>
      <td>18568961.216457</td>
      <td>11665386.215099</td>
      <td>33760218.249876</td>
    </tr>
  </tbody>
</table>
</div>

<br/>

# The Plotting Function

Below, I create a plotting function to re-create a view of the GBD Compare tool, showing the total DALY burden per year, separated into cause areas.  Note that you can see a general trend downwards, and the red area of infectious disease is shrinking with time.  

As the burden of infectious disease is declining, chronic diseases often associated with old age in high income countries are increasing.  Note that this plot is showing absolute numbers, so the fact that the overall DALY burden is declining even as the population is growing is pretty encouraging.  


{% highlight python %}
colors = ["#006D2C", "#31A354","#74C476", "#BAE4B3", "#54278F", "#756BB1",
          "#9E9AC8", "#BCBDDC", "#DADAEB", "#08519C", "#3182BD",
          "#6BAED6", "#9ECAE1", "#C6DBEF", "#99000D", "#CB181D", 
          "#EF3B2C", "#FB6A4A", "#FC9272", "#FCBBA1", "#FEE0D2",
          '#ffff80','#ffffcc']

def stacked_plot(gbd_df, width, ylim, colors):

    fig, ax = plt.subplots(figsize=(17,10))  #(20,12)

    causes = gbd_df['Cause of death or injury'].drop_duplicates()

    # http://stackoverflow.com/questions/19060144
    # Keep track of bottom margin for each stack row/year
    margin_bottom = np.zeros(len(gbd_df['Year'].drop_duplicates()))

    for num, cause in enumerate(causes):
        values = list(gbd_df[gbd_df['Cause of death or injury'] == cause].loc[:, 'Value'])
        label = textwrap.fill(cause, 30)

        gbd_df[gbd_df['Cause of death or injury'] == cause].plot.bar(
                x='Year',y='Value', ax=ax, stacked=True, color=colors[num], label=label, 
                bottom = margin_bottom, width=width)

        margin_bottom += values

    #http://stackoverflow.com/questions/4700614/how-to-put-the-legend-out-of-the-plot
    #Shrink current axis by 20%
    box = ax.get_position()
    ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])

    #Put a legend to the right of the current axis
    ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))

    ax.set_ylabel('DALYs, Global (billions)')
    ax.set_ylim([0, ylim])

    plt.show()

stacked_plot(gbd_df, 0.85, 3.0e9, colors)

{% endhighlight %}


![png]({{ site.baseurl }}/images/gbd_images/output_5_0.png)

<br/>

# How would including pandemic disease risk change the picture?


I recently read a paper called *The Neglected Dimension of Global Security: A Framework to Counter Infectious Disease Crises* [1], which looked at the risk of a global pandemic disease and called for a number of policy changes to increase our preparedness.  It's pretty surprising how little emphasis we put on pandemic disease risk, given the potential health and economic costs.  So I was interested in adding an annualized `DALY (YLL only)` burden to the plot to get a feel for the relative scale of the problem.  

First, I obtained an annual risk of pandemic outbreak from the paper [1], which they put at `3 percent` per year (Appendix C).  This is based on the `20th century` rate, which had pandemic outbreaks in `1918, 1957 and 1968`.  The authors also make the point that the risk of a pandemic is increasing with time, so this `3 percent` may be an underestimate.  I obtained a mean age of death from a study that looked at the 2009 the A/H1N1 outbreak [2], and found an estimate from the `1918-20` spanish flu pandemic to use as the excess mortality figure [3].  

As you can see in the table at the end, pandemic disease has a similar annual burden to that of *Neglected tropical diseases and malaria*, at `92 million DALY/year`.  This isn't as large as I thought it would be, but it's important to keep in mind that pandemics happen all at once, which would essentially double the global mortality figures in a single year [2].  Pandemics also cause massive social, economic, and political disruption resulting in other costs beyond human health.  One estimate puts the annualized economic cost of a pandemic disease outbreak at `$60 billion` [1].  


{% highlight python %}
# Pandemic disease annualized burden

annual_probability = 0.03  
life_table_37 = 49.58 #Years remaining in life, from GBD life table below
excess_mortality = 62000000

#Use life table, don't incorporate potential years up to 100, etc.
pandemic_yll = life_table_37 * excess_mortality * annual_probability
#Annualized years of life lost due to pandemics (billions):  0.0922188

print 'Annualized years of life lost due to pandemics (billions): ', pandemic_yll/ 1e9

gbd2013_df = gbd_df[gbd_df['Year'] == 2013]
pandemic_df = gbd2013_df.copy()
pand_dict = [{'Cause of death or injury': 'Pandemic disease', 'Year': 2013, 'Value': pandemic_yll}]
pandemic_df = pandemic_df.append(pand_dict, ignore_index=True)  

stacked_plot(pandemic_df, 0.1, 3.0e9, colors)
{% endhighlight %}

    Annualized years of life lost due to pandemics (billions):  0.0922188



![png]({{ site.baseurl }}/images/gbd_images/output_7_1.png)

<br/>

# What if we use a longer life expectancy as the reference?


In order to calculate DALYs, you need two numbers: the years of life lost (YLL) and the years lived with disability (YLD).  In order to calculate YLL for an individual, you need to know their age at death and their life expectancy at that age.  

But which life expectancy should you use?  In past studies, the life expectancy of a male or female within the individual's country at that age was used.  In my view, this most recent study is an ethical improvement because it uses Japanese women, who have the longest life expectancy at `86`, as the standard to compare everyone against [4].  By doing this, the authors are saying that every person should have the longest possible life expectancy regardless of their location or sex.  

But do Japanese women really have the longest life expectancy?  As a group with a population that is over `5 million`, they do.  But we certainly know that it is [biologically possible](https://en.wikipedia.org/wiki/List_of_the_verified_oldest_people) to live much longer than this.  Why not set the upper limit at what is currently biologically possible?  

One reason might be that a substantial portion of longevity could be due to genetic predisposition.  Some estimates put the genetic  portion at `20-30%` but this might be complicated by epigenetics and gene-environment interactions and might increase in cases of extreme longevity [5].  But at the end of the day, genetic predisposition results in some type of gene expression in the body that we could mimic if we had a better understanding of the aging process.  Also, note that the study authors are already ignoring genetic predisposition by using Japanese women as the comparison group.  

Another argument against the extended life expectancy is that people are expressing their preference to live a shorter life by choosing a less healthy lifestyle (this often comes up when people express a love for bacon).  I think this is a stronger criticism, but it's important to note that people aren't always rational when it comes to long term decision making.  Also, plenty of other disease burdens that are due to conscious decisions (e.g. smoking) are included in the DALY estimates.       

Anyways, the purpose of this article isn't to hash out every ethical consideration -- I just want to get a sense of the scale of the potential disease burden.  So how would using a life expectancy of, say, `100` change the analysis?  Below I use two methods, one a simple estimate, and a second more in-depth estimate using life tables and global deaths by age.  The end result is that using a life expectancy of `100` would result in an extra disease burden of around `500 million YLL` due to premature aging each year.  

# Simple Estimate

{% highlight python %}
# Aging annualized burden, simple estimate
annual_death_rate = 765.73/100000 #GBD 2013
potential_expectancy = 100
global_population = 7125000000  #2013, World Bank
gbd_expectancy = 86


#Annual potential years of life lost, estimate
aging_yll_est = (potential_expectancy - gbd_expectancy) * annual_death_rate * global_population

print 'Years lost due to premature aging, simple estimate (billions): ', aging_yll_est / 1e9
#Note it ignores any YLDs

{% endhighlight %}

    Years lost due to premature aging, simple estimate (billions):  0.763815675

<br/>

# Life Table Estimate

The second approach accounts for the fact that after you've lived through younger age cohorts, your current life expectancy actually exceeds your life expectancy at birth.  This is why someone at age 105 in the `life_table` below can still expect to live `1.63` more years even if this exceeds their life expectancy at birth.  *Of the people that reach that age, the average length of life afterwards is `1.63` years.*  Ok, so how do we take that into account?  

The GBD already used the age in the life table plus the remaining years of life when they calculated YLL \[6\].  So I need to subtract this sum from the new upper limit of 100 years for each age cohort, and multiply that result times the number of deaths in each age cohort in 2013.  The deaths by age group data from [IHME's site](http://ihmeuw.org/3wgb) comes grouped by five year increments, so I use the mean life table value for the five year cohorts to do the analysis.  


{% highlight python %}
# Aging annualized burden, life table estimate

# Comprehensive Systematic Analysis of Global Epidemiology: Definitions, Methods, 
# Simplification of DALYs, and Comparative Results from the Global Burden of Disease 2010 Study
# Web Table 6: Single year standard lifetable
life_table = {0: 86.02, 1: 85.21, 2: 84.22, 3: 83.23, 4: 82.24, 5: 81.25, 6: 80.25, 7: 79.26, 
             8: 78.26, 9: 77.27, 10: 76.27, 11: 75.28, 12: 74.28, 13: 73.29, 14: 72.29, 15: 71.29, 
             16: 70.3, 17: 69.32, 18: 68.33, 19: 67.34, 20: 66.35, 21: 65.36, 22: 64.37, 23: 63.38, 
             24: 62.39, 25: 61.4, 26: 60.41, 27: 59.43, 28: 58.44, 29: 57.45, 30: 56.46, 31: 55.48, 
             32: 54.49, 33: 53.5, 34: 52.52, 35: 51.53, 36: 50.56, 37: 49.58, 38: 48.6, 39: 47.62, 40: 
             46.64, 41: 45.67, 42: 44.71, 43: 43.74, 44: 42.77, 45: 41.8, 46: 40.85, 47: 39.9, 48: 38.95, 
             49: 38.0, 50: 37.05, 51: 36.12, 52: 35.19, 53: 34.25, 54: 33.32, 55: 32.38, 56: 31.47, 
             57: 30.55, 58: 29.64, 59: 28.73, 60: 27.81, 61: 26.91, 62: 26.0, 63: 25.1, 64: 24.2, 65: 23.29, 
             66: 22.42, 67: 21.55, 68: 20.68, 69: 19.8, 70: 18.93, 71: 18.1, 72: 17.28, 73: 16.45, 74: 15.62, 
             75: 14.8, 76: 14.04, 77: 13.27, 78: 12.51, 79: 11.75, 80: 10.99, 81: 10.32, 82: 9.65, 83: 8.98, 
             84: 8.31, 85: 7.64, 86: 7.12, 87: 6.61, 88: 6.09, 89: 5.57, 90: 5.05, 91: 4.7, 92: 4.35, 93: 4.0, 
             94: 3.66, 95: 3.31, 96: 3.09, 97: 2.88, 98: 2.66, 99: 2.44, 100: 2.23, 101: 2.11, 102: 1.99,
             103: 1.87, 104: 1.75, 105: 1.63}

#The mean of life_table for each year range
life_table_5yr = {'60-64': 26.0, '25-29': 59.43, '50-54': 35.19, '90-94': 4.35, '100-104': 1.99, 
                  '75-79': 13.27, '10-14': 74.28, '95-99': 2.88, '15-19': 69.32, '20-24': 64.37, 
                  '1-4': 83.725, '65-69': 21.55, '55-59': 30.55, '40-44': 44.71, '45-49': 39.9, 
                  '30-34': 54.49, '35-39': 49.58, '5-9': 79.26, '70-74': 17.28, '0-1': 86.02,
                  '80-84': 9.65, '85-89': 6.61, '80-105': 4.96}

years = life_table_5yr.keys()
values= life_table_5yr.values()
life_df = pd.DataFrame({'Age': years, 'avg_lost_years': values })


deaths_df = pd.read_csv('./gbd_deaths_age_2013.csv')
deaths_df = deaths_df[['Age', 'Value']]
deaths_df.replace([' years', ' days', '\+'], ['','','-105'], regex=True, inplace=True)
deaths_df = deaths_df.append({'Age': '0-1', 'Value': np.sum(deaths_df.ix[0:2,'Value'])}, ignore_index=True)
deaths_df.drop(deaths_df.index[[0,1,2]], inplace=True)
deaths_df['lower_age'], deaths_df['upper_age'] = deaths_df['Age'].str.split('-').str
deaths_df[['lower_age','upper_age']] = deaths_df[['lower_age','upper_age']].apply(pd.to_numeric)
deaths_df['avg_age'] = (deaths_df['upper_age'] + deaths_df['lower_age']) / 2
deaths_df.rename(columns={'Value':'num_deaths'}, inplace=True)

deaths_df = deaths_df.merge(life_df, on='Age')
deaths_df['age_cohort_lifeexp'] = deaths_df['avg_age'] + deaths_df['avg_lost_years']


# Potential_expectancy is from simple estimate:
deaths_df['aging_yll'] = (potential_expectancy - deaths_df['age_cohort_lifeexp']) * deaths_df['num_deaths']

aging_yll = np.sum(deaths_df['aging_yll'])  

# Add on additional potential years from pandemics, based on new potential expectancy:
# No pandemics: 0.527058402523, with: 0.552019602523
aging_yll += (potential_expectancy - (mean_age + life_table_37)) * excess_mortality * annual_probability

print 'Years lost due to premature aging, life table estimate (billions): ', aging_yll / 1e9

deaths_df.sort_values(by='lower_age')     
{% endhighlight %}

    Years lost due to premature aging, life table estimate (billions):  0.552019602523





<div>
<table >
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Age</th>
      <th>num_deaths</th>
      <th>lower_age</th>
      <th>upper_age</th>
      <th>avg_age</th>
      <th>avg_lost_years</th>
      <th>age_cohort_lifeexp</th>
      <th>aging_yll</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>17</th>
      <td>0-1</td>
      <td>4463724.165644</td>
      <td>0</td>
      <td>1</td>
      <td>0.5</td>
      <td>86.020</td>
      <td>86.520</td>
      <td>60171001.752885</td>
    </tr>
    <tr>
      <th>0</th>
      <td>1-4</td>
      <td>1816195.614709</td>
      <td>1</td>
      <td>4</td>
      <td>2.5</td>
      <td>83.725</td>
      <td>86.225</td>
      <td>25018094.592611</td>
    </tr>
    <tr>
      <th>1</th>
      <td>5-9</td>
      <td>476742.274921</td>
      <td>5</td>
      <td>9</td>
      <td>7.0</td>
      <td>79.260</td>
      <td>86.260</td>
      <td>6550438.857416</td>
    </tr>
    <tr>
      <th>2</th>
      <td>10-14</td>
      <td>365474.428165</td>
      <td>10</td>
      <td>14</td>
      <td>12.0</td>
      <td>74.280</td>
      <td>86.280</td>
      <td>5014309.154428</td>
    </tr>
    <tr>
      <th>3</th>
      <td>15-19</td>
      <td>600613.932945</td>
      <td>15</td>
      <td>19</td>
      <td>17.0</td>
      <td>69.320</td>
      <td>86.320</td>
      <td>8216398.602691</td>
    </tr>
    <tr>
      <th>4</th>
      <td>20-24</td>
      <td>900540.161535</td>
      <td>20</td>
      <td>24</td>
      <td>22.0</td>
      <td>64.370</td>
      <td>86.370</td>
      <td>12274362.401721</td>
    </tr>
    <tr>
      <th>5</th>
      <td>25-29</td>
      <td>1075687.420244</td>
      <td>25</td>
      <td>29</td>
      <td>27.0</td>
      <td>59.430</td>
      <td>86.430</td>
      <td>14597078.292715</td>
    </tr>
    <tr>
      <th>6</th>
      <td>30-34</td>
      <td>1175301.526232</td>
      <td>30</td>
      <td>34</td>
      <td>32.0</td>
      <td>54.490</td>
      <td>86.490</td>
      <td>15878323.619396</td>
    </tr>
    <tr>
      <th>7</th>
      <td>35-39</td>
      <td>1329198.871632</td>
      <td>35</td>
      <td>39</td>
      <td>37.0</td>
      <td>49.580</td>
      <td>86.580</td>
      <td>17837848.857304</td>
    </tr>
    <tr>
      <th>8</th>
      <td>40-44</td>
      <td>1571115.297667</td>
      <td>40</td>
      <td>44</td>
      <td>42.0</td>
      <td>44.710</td>
      <td>86.710</td>
      <td>20880122.305997</td>
    </tr>
    <tr>
      <th>9</th>
      <td>45-49</td>
      <td>1992295.351683</td>
      <td>45</td>
      <td>49</td>
      <td>47.0</td>
      <td>39.900</td>
      <td>86.900</td>
      <td>26099069.107050</td>
    </tr>
    <tr>
      <th>10</th>
      <td>50-54</td>
      <td>2527296.211479</td>
      <td>50</td>
      <td>54</td>
      <td>52.0</td>
      <td>35.190</td>
      <td>87.190</td>
      <td>32374664.469052</td>
    </tr>
    <tr>
      <th>11</th>
      <td>55-59</td>
      <td>3186138.279997</td>
      <td>55</td>
      <td>59</td>
      <td>57.0</td>
      <td>30.550</td>
      <td>87.550</td>
      <td>39667421.585968</td>
    </tr>
    <tr>
      <th>12</th>
      <td>60-64</td>
      <td>4097604.891095</td>
      <td>60</td>
      <td>64</td>
      <td>62.0</td>
      <td>26.000</td>
      <td>88.000</td>
      <td>49171258.693144</td>
    </tr>
    <tr>
      <th>13</th>
      <td>65-69</td>
      <td>4174311.206536</td>
      <td>65</td>
      <td>69</td>
      <td>67.0</td>
      <td>21.550</td>
      <td>88.550</td>
      <td>47795863.314839</td>
    </tr>
    <tr>
      <th>14</th>
      <td>70-74</td>
      <td>5155833.993336</td>
      <td>70</td>
      <td>74</td>
      <td>72.0</td>
      <td>17.280</td>
      <td>89.280</td>
      <td>55270540.408560</td>
    </tr>
    <tr>
      <th>15</th>
      <td>75-79</td>
      <td>5501272.621034</td>
      <td>75</td>
      <td>79</td>
      <td>77.0</td>
      <td>13.270</td>
      <td>90.270</td>
      <td>53527382.602658</td>
    </tr>
    <tr>
      <th>16</th>
      <td>80-105</td>
      <td>14454418.859887</td>
      <td>80</td>
      <td>105</td>
      <td>92.5</td>
      <td>4.960</td>
      <td>97.460</td>
      <td>36714223.904113</td>
    </tr>
  </tbody>
</table>
</div>

<br/>

# What's the relative scale?

Finally, here is an updated visualization and table showing the added YLL due to premature aging.  The premature aging column turns out to be quite large.  In reality, this burden would be split up among all the different causes of death, but it's interesting to see it as a stand-alone category. 

The final table below shows that the Pandemic disease burden is in the middle, with a similar value to that of *Neglected tropical diseases and malaria*.  The premature aging category has the largest burden of any single category, although it really should be split up among each of the diseases.  


{% highlight python %}
#colors_update = colors[:]
#colors_update.extend(['#ffff80','#ffffcc'])  #['#ffff80','#ffffcc']  [ '#A9A9A9', '#BFBFBF']
        
dicts = [{'Cause of death or injury': 'Premature aging', 'Year': 2013, 'Value': aging_yll},
         {'Cause of death or injury': 'Pandemic disease', 'Year': 2013, 'Value': pandemic_yll}]
  
gbd2013add_df = gbd2013_df.copy()
gbd2013add_df = gbd2013add_df.append(dicts, ignore_index=True)  
        
stacked_plot(gbd2013add_df, 0.1, 3.5e9, colors)

gbd2013add_df.sort_values(by='Value')
        
{% endhighlight %}


![png]({{ site.baseurl }}/images/gbd_images/output_13_0.png)





<div>
<table >
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>﻿Location</th>
      <th>Year</th>
      <th>Age</th>
      <th>Sex</th>
      <th>Cause of death or injury</th>
      <th>Measure</th>
      <th>Value</th>
      <th>Lower bound</th>
      <th>Upper bound</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Forces of nature, war, and legal intervention</td>
      <td>DALYs</td>
      <td>6.113613e+06</td>
      <td>3.504764e+06</td>
      <td>1.106874e+07</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Maternal disorders</td>
      <td>DALYs</td>
      <td>1.802781e+07</td>
      <td>1.605184e+07</td>
      <td>1.998946e+07</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Other communicable, maternal, neonatal, and nutritional diseases</td>
      <td>DALYs</td>
      <td>2.711404e+07</td>
      <td>2.168406e+07</td>
      <td>3.397773e+07</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Cirrhosis</td>
      <td>DALYs</td>
      <td>3.685807e+07</td>
      <td>3.505394e+07</td>
      <td>3.902250e+07</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Digestive diseases</td>
      <td>DALYs</td>
      <td>3.734117e+07</td>
      <td>3.367044e+07</td>
      <td>4.145244e+07</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Self-harm and interpersonal violence</td>
      <td>DALYs</td>
      <td>5.657462e+07</td>
      <td>4.867773e+07</td>
      <td>6.325653e+07</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Nutritional deficiencies</td>
      <td>DALYs</td>
      <td>7.483442e+07</td>
      <td>5.940201e+07</td>
      <td>9.408409e+07</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Transport injuries</td>
      <td>DALYs</td>
      <td>7.895289e+07</td>
      <td>7.212276e+07</td>
      <td>8.511561e+07</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Neurological disorders</td>
      <td>DALYs</td>
      <td>8.404802e+07</td>
      <td>6.569416e+07</td>
      <td>1.056925e+08</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Neglected tropical diseases and malaria</td>
      <td>DALYs</td>
      <td>9.067684e+07</td>
      <td>7.574893e+07</td>
      <td>1.077376e+08</td>
    </tr>
    <tr>
      <th>22</th>
      <td>NaN</td>
      <td>2013</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>Pandemic disease</td>
      <td>NaN</td>
      <td>9.221880e+07</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Unintentional injuries</td>
      <td>DALYs</td>
      <td>1.059413e+08</td>
      <td>9.699608e+07</td>
      <td>1.172652e+08</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Chronic respiratory diseases</td>
      <td>DALYs</td>
      <td>1.127107e+08</td>
      <td>9.887194e+07</td>
      <td>1.281478e+08</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>HIV/AIDS and tuberculosis</td>
      <td>DALYs</td>
      <td>1.191796e+08</td>
      <td>1.124977e+08</td>
      <td>1.275849e+08</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Diabetes, urogenital, blood, and endocrine diseases</td>
      <td>DALYs</td>
      <td>1.416209e+08</td>
      <td>1.187134e+08</td>
      <td>1.681583e+08</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Musculoskeletal disorders</td>
      <td>DALYs</td>
      <td>1.494357e+08</td>
      <td>1.068885e+08</td>
      <td>1.975651e+08</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Other non-communicable diseases</td>
      <td>DALYs</td>
      <td>1.709479e+08</td>
      <td>1.309229e+08</td>
      <td>2.234843e+08</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Mental and substance use disorders</td>
      <td>DALYs</td>
      <td>1.731774e+08</td>
      <td>1.274265e+08</td>
      <td>2.217341e+08</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Neonatal disorders</td>
      <td>DALYs</td>
      <td>1.896010e+08</td>
      <td>1.790241e+08</td>
      <td>2.000440e+08</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Neoplasms</td>
      <td>DALYs</td>
      <td>1.970935e+08</td>
      <td>1.892370e+08</td>
      <td>2.062585e+08</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Diarrhea, lower respiratory, and other common infectious diseases</td>
      <td>DALYs</td>
      <td>2.498551e+08</td>
      <td>2.312221e+08</td>
      <td>2.696253e+08</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Global</td>
      <td>2013</td>
      <td>All ages</td>
      <td>Both</td>
      <td>Cardiovascular diseases</td>
      <td>DALYs</td>
      <td>3.297056e+08</td>
      <td>3.111888e+08</td>
      <td>3.482062e+08</td>
    </tr>
    <tr>
      <th>21</th>
      <td>NaN</td>
      <td>2013</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>Premature aging</td>
      <td>NaN</td>
      <td>5.520196e+08</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>

<script src="//d3js.org/d3.v3.min.js" charset="utf-8"></script>


<br />

# References

[1] "The Neglected Dimension of Global Security: A Framework to Counter Infectious Disease Crises." Commission on a Global Health Risk Framework for the Future.  [https://nam.edu/initiatives/global-health-risk-framework/](https://nam.edu/initiatives/global-health-risk-framework/)

[2] "Preliminary Estimates of Mortality and Years of Life Lost Associated with the 2009 A/H1N1 Pandemic in the US and Comparison with Past Influenza Seasons." [http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2843747/](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2843747/)

[3] "Estimation of potential global pandemic influenza mortality on the basis of vital registry data from the 1918-20 pandemic: a quantitative analysis." [http://www.ncbi.nlm.nih.gov/pubmed/17189032](http://www.ncbi.nlm.nih.gov/pubmed/17189032)

[4] "Global and regional mortality from 235 causes of death for 20 age groups in 1990 and 2010: a systematic analysis for the Global Burden of Disease Study 2010."  The Lancet.  [http://www.thelancet.com/journals/lancet/article/PIIS0140-6736(12)61728-0/abstract](http://www.thelancet.com/journals/lancet/article/PIIS0140-6736(12)61728-0/abstract)

[5] "Genetic influence on human lifespan and longevity." Human Genetics. [https://www.ncbi.nlm.nih.gov/pubmed/16463022/](https://www.ncbi.nlm.nih.gov/pubmed/16463022/)

[6] "Comprehensive Systematic Analysis of Global Epidemiology: Definitions, Methods, Simplification of DALYs, and Comparative Results from the Global Burden of Disease 2010 Study." Web Table 6: Single year standard lifetable.  [http://www.thelancet.com/cms/attachment/2017336178/2037711222/mmc1.pdf](http://www.thelancet.com/cms/attachment/2017336178/2037711222/mmc1.pdf)


<script type="text/javascript">
  // Original stacked graph source: https://gist.github.com/mstanaland/6100713

  // Setup svg using Bostock's margin convention
  var margin = {top: 20, right: 210, bottom: 35, left: 25};  //left: 60  
  var width = 850 - margin.left - margin.right,  //1100
      height = 450 - margin.top - margin.bottom;  //500
  var svg = d3.select("#chart")
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


   var conditions = ['Forces of nature, war, and legal intervention', 'Self-harm and interpersonal violence','Unintentional injuries','Transport injuries', 'Other non-communicable diseases', 'Musculoskeletal disorders','Diabetes, urogenital, blood, and endocrine diseases', 'Mental and substance use disorders',  'Neurological disorders', 'Digestive diseases', 'Cirrhosis', 'Chronic respiratory diseases', 'Cardiovascular diseases', 'Neoplasms', 'Other communicable, maternal, neonatal, and nutritional diseases', 'Nutritional deficiencies', 'Neonatal disorders', 'Maternal disorders', 'Neglected tropical diseases and malaria', 'Diarrhea, lower respiratory, and other common infectious diseases','HIV/AIDS and tuberculosis'];
  
  var colors = ["#006D2C", "#31A354","#74C476", "#BAE4B3", "#54278F", "#756BB1","#9E9AC8", "#BCBDDC", "#DADAEB", "#08519C", "#3182BD",
                "#6BAED6", "#9ECAE1", "#C6DBEF", "#99000D", "#CB181D", "#EF3B2C", "#FB6A4A", "#FC9272", "#FCBBA1", "#FEE0D2"];


  var parse = d3.time.format("%Y").parse;

  // Load data from CSV, Parse & Build Plot in callback
  d3.csv( "{{ site.baseurl }}/rawdata/gbd_data.csv", function(d) {    //http://pstblog.com/data/gbd_data.csv" "{{ site.baseurl }}/data/gbd_data.csv" {{site.data.gbd_data}} "https://dl.dropboxusercontent.com/u/44331453/gbd_data.csv"

    data_csv = d;

    data = parse_data(data_csv);  

    // Transpose the data into layers, add conditions to each for tooltip
    var dataset = d3.layout.stack()(conditions.map(function(dalys,i) {
      return data.map(function(d) {
        return {c:conditions[i], x: parse(d.year), y: +d[dalys] };
      });
    }));

    //Tooltip using divs:
    //src: http://www.d3noob.org/2013/01/adding-tooltips-to-d3js-graph.html
    var div = d3.select("body").append("div")   
        .attr("class", "tooltip")               
        .style("opacity", 0);

    // Set x, y and colors
    var x = d3.scale.ordinal()
      .domain(dataset[0].map(function(d) { return d.x; }))
      .rangeRoundBands([10, width-10], 0.02);
    var y = d3.scale.linear()
      .domain([0, d3.max(dataset, function(d) {  return d3.max(d, function(d) { return d.y0 + d.y; });  })])
      .range([height, 0]);

    // Define and draw axes
    var yAxis = d3.svg.axis()
      .scale(y)
      .orient("left")
      .ticks(5)
      .tickSize(-width, 0, 0)
      .tickFormat( function(d) { return d/1000000000 + "B"} );
    var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom")
      .tickFormat(d3.time.format("%Y"));
    svg.append("g")
      .attr("class", "y axis")
      .call(yAxis);
    svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

    // Create groups for each series, rects for each segment 
    var groups = svg.selectAll("g.cost")
      .data(dataset)
      .enter().append("g")
      .attr("class", "cost")
      .style("fill", function(d, i) { return colors[i]; });
    var rect = groups.selectAll("rect")
      .data(function(d) { return d; })
      .enter()
      .append("rect")
      .attr("x", function(d) { return x(d.x); })
      .attr("y", function(d) { return y(d.y0 + d.y); })
      .attr("height", function(d) { return y(d.y0) - y(d.y0 + d.y); })
      .attr("width", x.rangeBand())
      .on("mouseover", function(d) {
        //http://stackoverflow.com/questions/21153074/d3-positioning-tooltip-on-svg-element-not-working
        var xPosition = d3.event.pageX
        var yPosition = d3.event.pageY
        // var xPosition = d3.mouse(this)[0];
        // var yPosition = d3.mouse(this)[1];      
        div.transition()        
            .duration(10)      
            .style("opacity", 1.0);      
        div .html(d.c + ":" +"</br>"+ Math.round(d3.round(d.y, -2)) + " (DALYs)")   //Math.round(d3.round(d.y, -6))
            .style("left", (xPosition - 100) + "px")   //xPosition
            .style("top", (yPosition - 65) + "px") //20
            //.style("border-color", colors[colors.length-1-i] )   
      })
      .on("mousemove", function(d) {
        var xPosition = d3.event.pageX
        var yPosition = d3.event.pageY
        // var xPosition = d3.mouse(this)[0];
        // var yPosition = d3.mouse(this)[1]; 
        div.attr("transform", "translate(" + xPosition + "," + yPosition + ")");
        div .html(d.c + ":" +"</br>"+ Math.round(d3.round(d.y, -2)) + " (DALYs)") //Math.round(d3.round(d.y, -6))
            .style("left", (xPosition - 100) + "px")  //35
            .style("top", (yPosition - 65) + "px")
            //.style("border-color", colors[colors.length-1-i] ) possible to set colors based on mouseover box?
            .attr("transform", "translate(" + xPosition + "," + yPosition + ")");
      })                  
      .on("mouseout", function(d) {       
            div.transition()        
                .duration(500)      
                .style("opacity", 0);   
      });


    //Axes labels
    svg.append("text")
      .attr("class", "x label")
      .attr("text-anchor", "end")
      .attr("x", width - 10)
      .attr("y", height + 15)
      .text("Year");

    svg.append("text")
      .attr("class", "y label")
      .attr("text-anchor", "end")
      .attr("y", 1)
      .attr("x", -20)
      .attr("dy", ".75em")
      .attr("transform", "rotate(-90)")
      .text("DALYs");

    //Draw legend
    var legend = svg.selectAll(".legend")
      .data(colors)
      .enter().append("g")
      .attr("class", "legend")
      .attr("transform", function(d, i) { return "translate(30," + i * 19 + ")"; });  //19 expands it
     
    legend.append("rect")
      .attr("x", width - 25)  // 18 originally
      .attr("width", 13)  //18 originally
      .attr("height", 18)
      .style("fill", function(d, i) {return colors.slice().reverse()[i];});
     
    legend.append("text")
      .attr("x", width - 5) // 5 moves text left
      .attr("y", 9)
      .attr("dy", ".35em")  // .35em
      .style("text-anchor", "start")
      .text(function(d,i) {
        return conditions[conditions.length - 1 - i].split(",")[0]; //shorten text
      });

    // Wrapping legend text works, but not legible
    // Shortened instead ^^ 
    // legend.selectAll("text")
    //       .call(wrap, x.rangeBand());

  //End callback
  });

  //Helper function to parse data
  function parse_data(data_csv) {    
    var parsed = [{"year":"1990"},{"year":"1995"},{"year":"2000"},{"year":"2005"},{"year":"2010"},{"year":"2013"}];
    for (i = 0; i < data_csv.length; i++) {
      var current_year = data_csv[i].Year;
      var cause = data_csv[i]["Cause of death or injury"];
      var value = data_csv[i].Value;
      for (b = 0; b < parsed.length; b++){
        if (parsed[b]["year"] === current_year) { 
          parsed[b][cause] = value;
        };
      };
    };
  return parsed
  };
  


  // Modified text wrap function
  // source: http://bl.ocks.org/mbostock/7555321  
  function wrap(text, width) {
    text.each(function() {
      var text = d3.select(this),
          words = text.text().split(/\s+/).reverse(),
          word,
          line = [],
          lineNumber = 0,
          lineHeight = 1.1, // ems
          y = text.attr("y"),
          x = text.attr("x"),  //modified to take initial x pos
          dy = parseFloat(text.attr("dy")),
          tspan = text.text(null).append("tspan").attr("x", x).attr("y", y).attr("dy", dy + "em"); //attr("x", 0) >> x to take x pos
      while (word = words.pop()) {
        line.push(word);
        tspan.text(line.join(" "));
        if (tspan.node().getComputedTextLength() > width) {
          line.pop();
          tspan.text(line.join(" "));
          line = [word];
          tspan = text.append("tspan").attr("x", x).attr("y", y).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word); //.attr("x", 0)
        }
      }
    });

  }
  </script>
