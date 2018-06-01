---
layout: post
title: "Exploring the IGM Experts Panel Data: Confidence and Consensus"
excerpt: "I explore the data from the economics expert panel, focusing on the confidence and consensus among the responses."
#modified: 2016-02-22
tags: [projects, IGM Forum, scraping, data analysis, Python, Pandas]
comments: true
share: false

---

This post explores some of the the data I collected from the [IGM Experts Forum](http://www.igmchicago.org/igm-economic-experts-panel), which surveys a group of leading economists on a variety of policy questions.  A CSV of all the data is available [here](https://www.dropbox.com/s/ouuqg7occ6o37ao/output_all.csv?dl=1), as are separate datasets of the [questions](https://www.dropbox.com/s/n407kk704fvdvno/igm_questions.csv?dl=1) and [responses](https://www.dropbox.com/s/lg3y056owry3inh/igm_responses.csv?dl=1).  An IPython notebook with all of the code from this analysis is available [here](https://gist.github.com/psthomas/663b75d178eeb0e6bc0aff69e0ad7208).        

I'm especially interested in how confidence changes with the scale of a claim, so I use a few different techniques to look at that relationship.  First, I look at confidence by vote type and find that economists seem to be more confident when they `strongly agree` or `strongly disagree`.  Second, I find that confidence actually increases the further a view is from the median, although this is relationship is mainly driven by `25` votes out of a `7024` vote sample.      

![png]({{ site.baseurl }}/images/igmimages/output_6_1.png)

An earlier paper [[1, PDF]](http://econweb.ucsd.edu/~gdahl/papers/views-among-economists.pdf) by Gordon and Dahl found that male economists and economists that were educated at the University of Chicago and MIT seemed to be more confident.  I find less evidence of this in the newer data, although I lack the knowledge of statistics to say whether any of these differences are significant.   

The main takeaway from this analysis is the amazing amount of consensus among leading economists.  The mean and median distance away from the consensus responses are `0.63` and `0.45` points on a five point scale.  Roughly `90 percent` of the responses are within `1.5` units of the consensus for all questions.  These results are consistend with Gordon and Dahl's earlier findings [[2, URL]](http://voxeu.org/article/views-among-economists-are-economists-really-so-divided).   

**Update:** A recent study [[2]](https://www.sociologicalscience.com/articles-v3-45-1028/) took a look at these data and they make a few important points.  First, if the intention of the forum is to show consensus in the economics profession, this might introduce a selection bias towards non-controversial questions. Second, they do find evidence of institutional and political bias but suggest it is a result of the hiring process rather than the educational process.

## Descriptive Statistics

First, let's look at some descriptive statistics for the responses:


{% highlight python %}

%matplotlib inline

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib
matplotlib.style.use('ggplot')

#pd.set_option('max_colwidth', 30)
pd.set_option('max_colwidth', 400)

matplotlib.rcParams['figure.figsize'] = (10.0, 8.0)
df_responses = pd.read_csv('output_all.csv')

cols = ['name', 'institution', 'qtitle','subquestion',
     'qtext','vote', 'comments', 'median_vote']

# Summary of the string columns
df_responses.describe(include = ['O'])[cols]

{% endhighlight %}




<div>
<!-- border="1" class="dataframe"-->
<table >
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>name</th>
      <th>institution</th>
      <th>qtitle</th>
      <th>subquestion</th>
      <th style="width:300px">qtext</th>
      <th>vote</th>
      <th>comments</th>
      <th>median_vote</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>8402</td>
      <td>8402</td>
      <td>8402</td>
      <td>8402</td>
      <td>8402</td>
      <td>8402</td>
      <td>2921</td>
      <td>8402</td>
    </tr>
    <tr>
      <th>unique</th>
      <td>51</td>
      <td>7</td>
      <td>134</td>
      <td>3</td>
      <td>199</td>
      <td>9</td>
      <td>2816</td>
      <td>5</td>
    </tr>
    <tr>
      <th>freq</th>
      <td>199</td>
      <td>1466</td>
      <td>162</td>
      <td>5686</td>
      <td>51</td>
      <td>2902</td>
      <td>92</td>
      <td>3877</td>
    </tr>
  </tbody>
</table>
</div>

<br/>

## Confidence Grouped by Vote Type

Next, I use the Pandas dataframe grouping function to look at confidence by vote type.  Note that the `Disagree` and `Strongly Disagree` votes are much less common.  `Agree` is the most common vote, followed by `Uncertain` and `Strongly Agree`.  `Uncertain` has the lowest mean confidence at `4.3`, possibly because it's weird to say that you're 'confidently uncertain'.    

Overall, `Strongly Agree` and `Strongly Disagree` have higher mean and median confidences.  One possible explanation is that economists are unwilling to step into the `Strongly` categories unless they feel that they have very good evidence.  Another possibility is that this is an issue with the survey -- it's weird to say that you 'unconfidently strongly agree'.    


{% highlight python %}
# Initial grouping, just by vote.  

r_list = ['Strongly Disagree', 'Disagree', 'Uncertain', 'Agree', 'Strongly Agree']

filtered_vote = df_responses[df_responses['vote'].isin(r_list)]

filtered_vote.boxplot(column='confidence', by='vote', whis=[5.0,95.0])

df_responses[df_responses['vote'].isin(r_list)].groupby('vote').agg(
                                {'confidence': 
                                 {'mean': 'mean', 
                                  'std': 'std', 
                                  'count': 'count',
                                  'median': 'median'}})

{% endhighlight %}




<div>
<table>
  <thead>
    <tr>
      <th></th>
      <th colspan="4" halign="left">confidence</th>
    </tr>
    <tr>
      <th></th>
      <th>std</th>
      <th>count</th>
      <th>median</th>
      <th>mean</th>
    </tr>
    <tr>
      <th>vote</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Agree</th>
      <td>2.044886</td>
      <td>2902</td>
      <td>6</td>
      <td>5.560992</td>
    </tr>
    <tr>
      <th>Disagree</th>
      <td>2.006320</td>
      <td>992</td>
      <td>6</td>
      <td>5.530242</td>
    </tr>
    <tr>
      <th>Strongly Agree</th>
      <td>1.764728</td>
      <td>1347</td>
      <td>8</td>
      <td>8.152190</td>
    </tr>
    <tr>
      <th>Strongly Disagree</th>
      <td>1.886012</td>
      <td>314</td>
      <td>8</td>
      <td>7.843949</td>
    </tr>
    <tr>
      <th>Uncertain</th>
      <td>2.405343</td>
      <td>1469</td>
      <td>5</td>
      <td>4.304969</td>
    </tr>
  </tbody>
</table>
</div>



![png]({{ site.baseurl }}/images/igmimages/output_4_1.png)

<br/>

## Vote Distance from the Median 

The above results are interesting, but what I'm more interested in is confidence as a claim becomes more controversial.  Below, I construct a measure of vote distance from the median vote, then look at confidence grouped by distance from that median.  I use the Pandas `apply` function below to assign a value ranging from 0 (`Strongly Disagree`) to 4 (`Strongly Agree`) to both the vote and median_vote columns.  I then take the absolute value of the difference between each vote and the median_vote for each question to calculate the distance.   

Confidence does increase the further the vote is from the median view, but relationship this is driven by `385` votes two points away, and `25` votes three points away out of a `7024` vote sample.  It's possible that these confident yet controversial votes are from subject matter experts and have more information about a topic than the rest.  


{% highlight python %}

def indicator(x):
  if x in r_list:
    return r_list.index(x)
  else:
    return None

df_responses['vote_num'] = df_responses['vote'].apply(indicator)
df_responses['median_num'] = df_responses['median_vote'].apply(indicator)
df_responses['vote_distance'] = abs(df_responses['median_num'] - df_responses['vote_num'])

grouped = df_responses.groupby('vote_distance').agg({'confidence':{'mean': 'mean', 
                                                                  'std': 'std', 
                                                                  'count':'count'}})


df_responses.boxplot(column='confidence', by='vote_distance', whis=[5.0,95.0]) #bootstrap=1000

grouped

{% endhighlight %}




<div>
<table>
  <thead>
    <tr>
      <th></th>
      <th colspan="3" halign="left">confidence</th>
    </tr>
    <tr>
      <th></th>
      <th>std</th>
      <th>count</th>
      <th>mean</th>
    </tr>
    <tr>
      <th>vote_distance</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2.375436</td>
      <td>3539</td>
      <td>5.663747</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2.507784</td>
      <td>3075</td>
      <td>6.103089</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2.429312</td>
      <td>385</td>
      <td>6.202597</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2.406934</td>
      <td>25</td>
      <td>7.720000</td>
    </tr>
  </tbody>
</table>
</div>




![png]({{ site.baseurl }}/images/igmimages/output_6_1.png)

<br/>

## Making a Continuous Vote Column

To add some granularity to the above data, I combine the vote number column and the confidence column into one incremental column called `incr_votenum`.  So a vote of `Agree` (vote_num = 3) at a confidence of `5` leads to a `incr_votenum` of `3.454` (`3 + 5/11`).  The assumption I am making here is that confidence is a continuous measure between two votes, with an `Agree` vote of confidence `10` measuring less than a `Strongly Agree` vote at confidence `0`.  I'm not sure if this is a safe assumption to make, but I'm going to run with it. 

I then calculate the median incr_votenum for each question, and the distance away from the median for each vote.  A few example results are shown in the table below.     


{% highlight python %}

# Construct a continuous column, incorporating confidence into vote_num
# Divide by 11 so 10 confidence of agree > 0 confidence of strongly agree
df_responses['incr_votenum'] = df_responses['vote_num'] + df_responses['confidence'] / 11.0

# Median incr_votenum for each question:
df_responses['median_incrvotenum'] = df_responses.groupby(
    ['qtitle','subquestion'])['incr_votenum'].transform('median')

# Calculate distance from median for each econ vote, less biased by outliers.  
df_responses['distance_median'] = abs(df_responses['median_incrvotenum'] - \
                                           df_responses['incr_votenum'])

df_responses[df_responses['qtitle'] == 'Brexit II'][
    ['qtitle','subquestion','vote_num','confidence', 
     'incr_votenum', 'median_incrvotenum', 'distance_median']].head()

{% endhighlight %}




<div>
<table>
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>qtitle</th>
      <th>subquestion</th>
      <th>vote_num</th>
      <th>confidence</th>
      <th>incr_votenum</th>
      <th>median_incrvotenum</th>
      <th>distance_median</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Brexit II</td>
      <td>Question A</td>
      <td>2</td>
      <td>4</td>
      <td>2.363636</td>
      <td>3.363636</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Brexit II</td>
      <td>Question B</td>
      <td>3</td>
      <td>5</td>
      <td>3.454545</td>
      <td>3.272727</td>
      <td>0.181818</td>
    </tr>
    <tr>
      <th>198</th>
      <td>Brexit II</td>
      <td>Question A</td>
      <td>3</td>
      <td>5</td>
      <td>3.454545</td>
      <td>3.363636</td>
      <td>0.090909</td>
    </tr>
    <tr>
      <th>199</th>
      <td>Brexit II</td>
      <td>Question B</td>
      <td>3</td>
      <td>5</td>
      <td>3.454545</td>
      <td>3.272727</td>
      <td>0.181818</td>
    </tr>
    <tr>
      <th>397</th>
      <td>Brexit II</td>
      <td>Question A</td>
      <td>3</td>
      <td>3</td>
      <td>3.272727</td>
      <td>3.363636</td>
      <td>0.090909</td>
    </tr>
  </tbody>
</table>
</div>

<br/>

## Visualizing the Spread of the Votes

The following boxplot shows the distance from the median for all votes, using the new incremental vote measure.  It's pretty amazing that the mean and median distance away from the consensus are only `0.454` and `0.628` respectively.  That's an impressive amount of consensus.  The whiskers on the boxplot cover the 90 percent of the data that fall within roughly 1.6 points of the consensus vote on a scale from 0 to 5.   

The histogram also shows a suprising amount of consensus, although it also shows a second peak around a difference of 1.0, which is the difference between two bordering answers, e.g. the distance from `Uncertain` to `Agree`. 


{% highlight python %}

# Boxplot, showing all vote distances from median  
df_responses.boxplot(column='distance_median', whis=[5.0,95.0], return_type='dict')

df_responses.hist(column='distance_median', bins=40)

print 'Median: ' + str(df_responses['distance_median'].median())
print 'Mean: ' + str(df_responses['distance_median'].mean())
print 'Stdev: ' + str(df_responses['distance_median'].std())

{% endhighlight %}

    Median: 0.454545454545
    Mean: 0.628856906192
    Stdev: 0.556692286667



![png]({{ site.baseurl }}/images/igmimages/output_10_1.png)

![png]({{ site.baseurl }}/images/igmimages/output_10_2.png)

<br/>

## Which questions are most controversial?

As a measure of how controversial a question is, I take the standard deviation of the incremental vote number (incr_votenum).  I include the final boxplot below, showing the spread of the votes by question.  


{% highlight python %}
# Which questions are most controversial?

# Calculating standard deviation, grouped by each question:
grouped_incrvotenum = df_responses.groupby(['qtitle', 'subquestion','qtext'], as_index = False) \
                                        .agg({'incr_votenum': {'std': 'std'}})

# Visualize the spread of responses using a boxplot
qs = grouped_incrvotenum[grouped_incrvotenum.loc[:, ('incr_votenum', 'std')] > 1.05][['qtitle','subquestion']]
qs_most = pd.merge(qs, df_responses, on=['qtitle', 'subquestion'], how='inner')
qs_most.boxplot(column='incr_votenum',by=['qtitle','subquestion'], whis=[5.0,95.0], rot=90)  

{% endhighlight %}



![png]({{ site.baseurl }}/images/igmimages/output_14_1.png)

<br/>

## Which questions are least controversial?


{% highlight python %}
# Which questions are least controversial?

# Select all data for questions with qtitle and subquestion by merging 
qs_least = grouped_incrvotenum[grouped_incrvotenum.loc[:, ('incr_votenum', 'std')] < 0.6][['qtitle','subquestion']]
qs_least_df = pd.merge(qs_least, df_responses, on=['qtitle', 'subquestion'], how='inner')

# Visualize boxplot and table
qs_least_df.boxplot(column='incr_votenum',by=['qtitle','subquestion'], rot=90, whis=[5.0,95.0]) 

{% endhighlight %}


![png]({{ site.baseurl }}/images/igmimages/output_16_1.png)

<br/>

## Which economists give more controversial responses? 


{% highlight python %}

# Group by economist, calcluate mean distance from median
grouped_econstd = df_responses.groupby(['name', 'institution']).agg({'distance_median': {'mean': 'mean'}})

grouped_econstd[grouped_econstd.loc[:, ('distance_median', 'mean')] > 0.75].sort_values(
                                                                        by=('distance_median','mean'),
                                                                        ascending=False)
{% endhighlight %}




<div>
<table>
  <thead>
    <tr>
      <th></th>
      <th></th>
      <th>distance_median</th>
    </tr>
    <tr>
      <th></th>
      <th></th>
      <th>mean</th>
    </tr>
    <tr>
      <th>name</th>
      <th>institution</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Alberto Alesina</th>
      <th>Harvard</th>
      <td>0.904429</td>
    </tr>
    <tr>
      <th>Angus Deaton</th>
      <th>Princeton</th>
      <td>0.891251</td>
    </tr>
    <tr>
      <th>Caroline Hoxby</th>
      <th>Stanford</th>
      <td>0.889181</td>
    </tr>
    <tr>
      <th>Austan Goolsbee</th>
      <th>Chicago</th>
      <td>0.791797</td>
    </tr>
    <tr>
      <th>Luigi Zingales</th>
      <th>Chicago</th>
      <td>0.770085</td>
    </tr>
  </tbody>
</table>
</div>

<br/>

## Which economists give the least controversial responses? 


{% highlight python %}

# Which economists give the least controversial responses? 

grouped_econstd[grouped_econstd.loc[:, ('distance_median', 'mean')] < 0.50].sort_values(
                                                                        by=('distance_median','mean'),
                                                                        ascending=True)
{% endhighlight %}




<div>
<table>
  <thead>
    <tr>
      <th></th>
      <th></th>
      <th>distance_median</th>
    </tr>
    <tr>
      <th></th>
      <th></th>
      <th>mean</th>
    </tr>
    <tr>
      <th>name</th>
      <th>institution</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>James Stock</th>
      <th>Harvard</th>
      <td>0.431818</td>
    </tr>
    <tr>
      <th>Amy Finkelstein</th>
      <th>MIT</th>
      <td>0.462121</td>
    </tr>
    <tr>
      <th>Eric Maskin</th>
      <th>Harvard</th>
      <td>0.471361</td>
    </tr>
    <tr>
      <th>Raj Chetty</th>
      <th>Harvard</th>
      <td>0.474530</td>
    </tr>
  </tbody>
</table>
</div>

<br/>

## Do any institutions give more controversial responses?

Here's what Gordon and Dahl had to say about differences between institutions using the 2012 question sample [[1, PDF]](http://econweb.ucsd.edu/~gdahl/papers/views-among-economists.pdf): 

> Respondents are dramatically more confident when the academic literature on the topic is large. Not surprisingly, experts on a subject are much more confident about their answers. The middle-aged cohort (the one closest to the current literature) is the most confident, while the oldest (and wisest) cohort is the least confident. Men and those who have worked in Washington do show some tendency to be more confident. Respondents who got their degrees at Chicago are far more confident than the other respondents, with almost as strong an effect for respondents with PhDs from MIT and to a lesser extent from Harvard. Respondents now employed at Yale and to a lesser degree Princeton, MIT, and Stanford seem to be more confident.

It doesn't seem like any institution sticks out based on this newer data, but maybe with more advanced statistical techniques it might be possible to find something significant.  


{% highlight python %}
 
# Group by institution, calculate mean and stdev of the distance from median response
grouped_inststd = df_responses.groupby(['institution']).agg({'distance_median':
                                                             {'mean': 'mean', 
                                                              'std':'std'}}).sort_values(
                                                                        by=('distance_median','mean'),
                                                                        ascending=False)

df_responses.boxplot(column='distance_median', by='institution', whis=[5.0,95.0])

grouped_inststd

{% endhighlight %}




<div>
<table>
  <thead>
    <tr>
      <th></th>
      <th colspan="2" halign="left">distance_median</th>
    </tr>
    <tr>
      <th></th>
      <th>std</th>
      <th>mean</th>
    </tr>
    <tr>
      <th>institution</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Stanford</th>
      <td>0.572456</td>
      <td>0.673072</td>
    </tr>
    <tr>
      <th>Chicago</th>
      <td>0.561737</td>
      <td>0.666043</td>
    </tr>
    <tr>
      <th>Princeton</th>
      <td>0.586784</td>
      <td>0.662991</td>
    </tr>
    <tr>
      <th>MIT</th>
      <td>0.554587</td>
      <td>0.621699</td>
    </tr>
    <tr>
      <th>Harvard</th>
      <td>0.558052</td>
      <td>0.596441</td>
    </tr>
    <tr>
      <th>Yale</th>
      <td>0.537219</td>
      <td>0.593209</td>
    </tr>
    <tr>
      <th>Berkeley</th>
      <td>0.526592</td>
      <td>0.584685</td>
    </tr>
  </tbody>
</table>
</div>




![png]({{ site.baseurl }}/images/igmimages/output_22_1.png)

<br/>

## Are any institutions more confident than others?

Again, although there are differences in the mean distance from the consensus view, all the standard deviations overlap, so I don't think there is anything significant here.  Note that Gordon and Dahl also looked at where economists where educated, rather than just where they were employed, and found differences in confidence based on that metric.   


{% highlight python %}

#Are any institutions more confident than others?
df_responses.boxplot(column='confidence', by='institution', whis=[5.0,95.0]) 

grouped_conf = df_responses.groupby(['institution']).agg(
                    {'confidence': 
                     {'mean': 'mean',
                      'median':'median',
                      'std':'std'}}).sort_values(by=('confidence','mean'),
                                                     ascending=False)

grouped_conf

{% endhighlight %}




<div>
<table >
  <thead>
    <tr>
      <th></th>
      <th colspan="3" halign="left">confidence</th>
    </tr>
    <tr>
      <th></th>
      <th>std</th>
      <th>median</th>
      <th>mean</th>
    </tr>
    <tr>
      <th>institution</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Princeton</th>
      <td>2.168625</td>
      <td>7</td>
      <td>6.363905</td>
    </tr>
    <tr>
      <th>Berkeley</th>
      <td>2.360717</td>
      <td>6</td>
      <td>6.019286</td>
    </tr>
    <tr>
      <th>Yale</th>
      <td>2.457948</td>
      <td>6</td>
      <td>6.009033</td>
    </tr>
    <tr>
      <th>MIT</th>
      <td>2.094831</td>
      <td>6</td>
      <td>5.909300</td>
    </tr>
    <tr>
      <th>Stanford</th>
      <td>2.555858</td>
      <td>6</td>
      <td>5.859665</td>
    </tr>
    <tr>
      <th>Harvard</th>
      <td>2.330881</td>
      <td>6</td>
      <td>5.725877</td>
    </tr>
    <tr>
      <th>Chicago</th>
      <td>2.789926</td>
      <td>6</td>
      <td>5.580745</td>
    </tr>
  </tbody>
</table>
</div>




![png]({{ site.baseurl }}/images/igmimages/output_24_1.png)

<br/>

## Are male economists more confident? 

Gordon and Dahl (2012) noted more confidence among male economists: 

> The only statistically significant deviation from homogeneous views, therefore, is less caution among men in expressing an opinion, perhaps due to a greater “expert bias.” Personality differences rather than different readings of the existing evidence would then explain these gender effects.

This relationship seems to be less obvious with this expanded dataset.  I'm not re-creating their analysis, though, so the difference might still be there if I were to use the controls that they do.   



{% highlight python %}

women = ['Amy Finkelstein', 'Hilary Hoynes', 'Pinelopi Goldberg', 
         'Judith Chevalier', 'Caroline Hoxby', 'Nancy Stokey', 
        'Marianne Bertrand', 'Cecilia Rouse', 'Janet Currie', 
         'Claudia Goldin', 'Katherine Baicker']

# Set true/false column based on sex
df_responses['female'] = df_responses['name'].isin(women)

# Boxplot grouped by sex 
df_responses.boxplot(column='confidence', by='female', whis=[5.0,95.0])

# Table, stats grouped by sex
df_responses.groupby(['female']).agg({'confidence': {'mean': 'mean', 'std':'std', 'median':'median'}})

{% endhighlight %}




<div>
<table>
  <thead>
    <tr>
      <th></th>
      <th colspan="3" halign="left">confidence</th>
    </tr>
    <tr>
      <th></th>
      <th>std</th>
      <th>median</th>
      <th>mean</th>
    </tr>
    <tr>
      <th>female</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>False</th>
      <td>2.398254</td>
      <td>6</td>
      <td>5.929568</td>
    </tr>
    <tr>
      <th>True</th>
      <td>2.661413</td>
      <td>6</td>
      <td>5.729814</td>
    </tr>
  </tbody>
</table>
</div>


![png]({{ site.baseurl }}/images/igmimages/output_26_1.png)


## Conclusion

This is just a first look at the data, and overall there seem to be some pretty interesting patterns.  There are probably some other interesting ways to augment this data with other information, like which institution an economist studied at, so I might do that in the future.  

Feel free to use the data, let me know what you find!

## Sources

[1] *Views among Economists: Professional Consensus or Point-Counterpoint?* Roger Gordon and Gordon B. Dahl.  [http://econweb.ucsd.edu/~gdahl/papers/views-among-economists.pdf](http://econweb.ucsd.edu/~gdahl/papers/views-among-economists.pdf)

[2] *Consensus, Polarization, and Alignment in the Economics Profession.* Tod S. Van Gunten, John Levi Martin, Misha Teplitskiy. [https://www.sociologicalscience.com/articles-v3-45-1028/](https://www.sociologicalscience.com/articles-v3-45-1028/)