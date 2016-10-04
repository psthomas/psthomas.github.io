---
layout: post
title: "Easy Stacked Charts with Matplotlib and Pandas"
excerpt: "I show a technique for making a stacked chart using the Pandas pivot function"
#modified: 2016-02-22
tags: [Pivot, Stacked Chart, Charts, Plots, Python, Pandas]
comments: true
share: false

---


Creating stacked bar charts using Matplotlib can be difficult.  Often the data you need to stack is oriented in columns, while the default Pandas bar plotting function requires the data to be oriented in rows with a unique column for each layer.   

Below is an example dataframe, with the data oriented in columns.  In this case, we want to create a stacked plot using the `Year` column as the x-axis tick mark, the `Month` column as the layers, and the `Value` column as the height of each month band.  


{% highlight python %}
%matplotlib inline

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib

matplotlib.style.use('ggplot')


data = [[2000, 2000, 2000, 2001, 2001, 2001, 2002, 2002, 2002],
        ['Jan', 'Feb', 'Mar', 'Jan', 'Feb', 'Mar', 'Jan', 'Feb', 'Mar'],
        [1, 2, 3, 4, 5, 6, 7, 8, 9]]

rows = zip(data[0], data[1], data[2])
headers = ['Year', 'Month', 'Value']
df = pd.DataFrame(rows, columns=headers)

df
{% endhighlight %}




<div>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Year</th>
      <th>Month</th>
      <th>Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2000</td>
      <td>Jan</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2000</td>
      <td>Feb</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2000</td>
      <td>Mar</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2001</td>
      <td>Jan</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2001</td>
      <td>Feb</td>
      <td>5</td>
    </tr>
    <tr>
      <th>5</th>
      <td>2001</td>
      <td>Mar</td>
      <td>6</td>
    </tr>
    <tr>
      <th>6</th>
      <td>2002</td>
      <td>Jan</td>
      <td>7</td>
    </tr>
    <tr>
      <th>7</th>
      <td>2002</td>
      <td>Feb</td>
      <td>8</td>
    </tr>
    <tr>
      <th>8</th>
      <td>2002</td>
      <td>Mar</td>
      <td>9</td>
    </tr>
  </tbody>
</table>
</div>

<br/>

# Iterative Solution

I have seen a [few](http://chrisalbon.com/python/matplotlib_stacked_bar_plot.html) [solutions](http://stackoverflow.com/questions/19060144/more-efficient-matplotlib-stacked-bar-chart-how-to-calculate-bottom-values) that take a more iterative approach, creating a new layer in the stack for each category.  This is accomplished by using the same axis object `ax` to append each band, and keeping track of the next bar location by cumulatively summing up the previous heights with a `margin_bottom` array.    


{% highlight python %}
fig, ax = plt.subplots(figsize=(10,7))  

months = df['Month'].drop_duplicates()
margin_bottom = np.zeros(len(df['Year'].drop_duplicates()))
colors = ["#006D2C", "#31A354","#74C476"]

for num, month in enumerate(months):
    values = list(df[df['Month'] == month].loc[:, 'Value'])

    df[df['Month'] == month].plot.bar(x='Year',y='Value', ax=ax, stacked=True, 
                                    bottom = margin_bottom, color=colors[num], label=month)
    margin_bottom += values

plt.show()
{% endhighlight %}


![png]({{ site.baseurl }}/images/stacked_charts/output_3_0.png)

<br/>

# Using a Pivot

The above approach works pretty well, but there has to be a better way.  After a little bit of digging, I found a better solution using the Pandas [pivot function](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.pivot.html).  

The pivot function takes arguments of `index` (what you want on the x-axis), `columns` (what you want as the layers in the stack), and `values` (the value to use as the height of each layer).  Note that there needs to be a unique combination of your `index` and `column` values for each number in the `values` column in order for this to work.  

The end result is a new dataframe with the data oriented so the default Pandas stacked plot works perfectly.   



{% highlight python %}
pivot_df = df.pivot(index='Year', columns='Month', values='Value')
pivot_df
{% endhighlight %}




<div>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>Month</th>
      <th>Feb</th>
      <th>Jan</th>
      <th>Mar</th>
    </tr>
    <tr>
      <th>Year</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2000</th>
      <td>2</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>2001</th>
      <td>5</td>
      <td>4</td>
      <td>6</td>
    </tr>
    <tr>
      <th>2002</th>
      <td>8</td>
      <td>7</td>
      <td>9</td>
    </tr>
  </tbody>
</table>
</div>




{% highlight python %}
#Note: .loc[:,['Jan','Feb', 'Mar']] is used here to rearrange the layer ordering
pivot_df.loc[:,['Jan','Feb', 'Mar']].plot.bar(stacked=True, color=colors, figsize=(10,7))
{% endhighlight %}



![png]({{ site.baseurl }}/images/stacked_charts/output_6_1.png)

