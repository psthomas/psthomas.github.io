---
layout: post
title: "The Social Returns to Risk Taking"
excerpt: "A meta-analysis looking at the relationship between intervention uncertainty and impact."
#modified:
tags: [Python, Jupyter notebook, risk, return, meta-analysis, DALYs, cost-effectiveness, altair]
comments: true
share: false

---

If you're trying to improve the world, should you avoid uncertainty or embrace it?  Is it better to spend money on a temporary health intervention or fund research to eventually find a cure?  I tried to answer these questions in a [previous post](https://pstblog.com/2017/12/02/risk-return)  by looking at standalone data from a variety of sources. Some of the sources shared similar enough units that they could be combined, so I try to do so below. 

<figure style="text-align:center;">
	<a href="{{ site.baseurl }}/images/metareturns/output_18_0.png">
	<img style="max-width:600px;" src="{{ site.baseurl }}/images/metareturns/lognormal-returns.png"></a>
</figure>

<!--<iframe id="vis" src="{{ site.baseurl }}/vis/meta-returns.html"-->
<!--    style="width: 100%; height:500px; border: none; position: relative; scrolling:no;">-->
<!--</iframe>-->

All the code and data for this project are available on GitHub [here](https://github.com/psthomas/risk-return).  

## Data Wrangling

Because both the GiveWell and Future of Humanity Institute (FHI) data share the same units, I can combine them to get a sense of the scale. Also, if I lazily assume that I can estimate the standard deviation of the Disease Control Priorities (DCP2) and National Institute for Health and Care Excellence (NICE) estimates by dividing the [range of the estimates by two](https://stats.stackexchange.com/questions/69575/relationship-between-the-range-and-the-standard-deviation), those can be included as well.  Note also that the NICE estimates are median results while Givewell and FHI are mean results, so this might need to be changed. There are more in-depth descriptions of the sources for these data in my [previous post](https://pstblog.com/2017/12/02/risk-return).

All the other conversions are pretty straightforward, but the [Global Health Cost Effectiveness Analysis Registry](http://healtheconomics.tuftsmedicalcenter.org/ghcearegistry/) (GHCEA) data required more wrangling. I back-calculated the standard deviations from the confidence interval widths using the figures defined on Wolfram [here](https://mathworld.wolfram.com/ConfidenceInterval.html), assuming the confidence intervals follow a normal distribution. In addition to the calculations above, I filter out any GHCEA studies that were rated below 4.5 by reviewers on a 1-7 quality scale. The end result is 653 interventions with standard deviations and cost effectiveness estimates.  

One final thing to consider: the Givewell numbers are estimates of the [marginal](https://en.wikipedia.org/wiki/Marginal_value) impact of donating to existing charities, while many of the other sources measure impact against a counterfactual using an [Incremental Cost Effectiveness Ratio](https://en.wikipedia.org/wiki/Incremental_cost-effectiveness_ratio) without a clear avenue for donors to make that change happen.  Instead, many of these interventions probably need to be implemented at the hospital, insurer, or government policy level rather than through a charity (although a charity could lobby for these changes). So the GiveWell numbers might be more rigorous because they're estimates of the current scaled-up impact of an intervention, while some of the other estimates might be too optimistic because they come from experiments implemented under ideal circumstances at a certain point in time.

## Putting It All Together

Below is a table of the combined 761 estimates and some histograms to get an idea of their distributions (mostly lognormal). Next, I fit some curves, run the portfolio optimization, and visualize the results. 

<div>
<table >
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>intervention</th>
      <th>cost_effectiveness</th>
      <th>stdev</th>
      <th>source</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Research - Diarrhoeal diseases</td>
      <td>3549.783221</td>
      <td>80857.231707</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Research - Meningititis</td>
      <td>1732.527683</td>
      <td>41075.262076</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Research - Leishmaniasis</td>
      <td>1703.723172</td>
      <td>8363.477589</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Routine measles-containing vaccine followed by...</td>
      <td>1000.000000</td>
      <td>728.877849</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Aspirin alone (325 mg initial dose &amp; subsequen...</td>
      <td>1000.000000</td>
      <td>1645.853207</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Preventive treatment of malaria in pregnancy w...</td>
      <td>1000.000000</td>
      <td>13.391457</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Preventive treatment of malaria in pregnancy w...</td>
      <td>1000.000000</td>
      <td>334.566881</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>7</th>
      <td>New tuberculosis vaccine (40% efficacy)</td>
      <td>1000.000000</td>
      <td>944.841656</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Research - Leprosy</td>
      <td>824.521890</td>
      <td>71250.250787</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Research - Trypanosomiasis</td>
      <td>802.785665</td>
      <td>110366.393439</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Research - Malaria</td>
      <td>801.655755</td>
      <td>7066.975304</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Research - Multiple salmonella infections</td>
      <td>753.616047</td>
      <td>16466.171159</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Research - Typhoid and paratyphoid fever</td>
      <td>709.092672</td>
      <td>30713.464549</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Research - Chagas disease</td>
      <td>534.967344</td>
      <td>6210.949437</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Syphilis screening before third trimester + tr...</td>
      <td>500.000000</td>
      <td>303.979086</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Brief smoking cessation advice + Bupropion</td>
      <td>333.333333</td>
      <td>0.058923</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Syphilis screening before third trimester + tr...</td>
      <td>333.333333</td>
      <td>204.085798</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Intermittent preventive treatment in infants (...</td>
      <td>333.333333</td>
      <td>255.746614</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Syphilis screening before third trimester + tr...</td>
      <td>333.333333</td>
      <td>173.702335</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Intermittent preventive treatment in infants (...</td>
      <td>333.333333</td>
      <td>330.235919</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Research - HIV</td>
      <td>303.678832</td>
      <td>2132.474086</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Research - Trichuriasis</td>
      <td>251.336051</td>
      <td>13978.148011</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>22</th>
      <td>New tuberculosis vaccine (40% efficacy)</td>
      <td>250.000000</td>
      <td>132.695577</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Syphilis screening before third trimester + tr...</td>
      <td>250.000000</td>
      <td>127.553624</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>24</th>
      <td>Syphilis screening before third trimester + tr...</td>
      <td>250.000000</td>
      <td>151.989543</td>
      <td>GHCEA</td>
    </tr>
  </tbody>
</table>
</div>

A histogram of all the results together:

<figure style="text-align:center;">
	<a href="{{ site.baseurl }}/images/metareturns/hist.png"><img src="{{ site.baseurl }}/images/metareturns/hist.png"></a>
</figure>

And here are histograms of the individual sources:

<figure style="text-align:center;">
	<a href="{{ site.baseurl }}/images/metareturns/facet-hists.png"><img src="{{ site.baseurl }}/images/metareturns/facet-hists.png"></a>
</figure>

## Fitting Some Curves

So how do I determine if there is a **return to risk taking**?  One approach would be to run a linear regression through the data and see if it has a positive slope.  This is what I do first below, but there's a problem with this approach.  To see why, imagine calculating the cost effectiveness of every possible action, including bogus things like lighting $1000 on fire.  You'd end up with a lot of useless interventions that would mess up the slope of the linear regression.  

So my second approach is to just see if the frontier that encloses the top end of the estimates has a positive slope.  In Modern Portfolio Theory, this frontier is called the [efficient frontier](https://en.wikipedia.org/wiki/Efficient_frontier), which I've written about [before](https://github.com/psthomas/efficient-frontier).  I didn't have enough data to test out this theory in the past, but the combination of all these sources makes it possible to do so now. 


<figure style="text-align:center" >
	<a href="{{ site.baseurl }}/images/metareturns/frontier.jpg"><img src="{{ site.baseurl }}/images/metareturns/frontier.jpg"></a>
	<figcaption>An example of an efficient frontier.</figcaption>
</figure>

Below, I fit a linear regression and a power law to the results.  The power law doesn't have an r-squared value because this [isn't really](http://blog.minitab.com/blog/adventures-in-statistics-2/why-is-there-no-r-squared-for-nonlinear-regression) a valid measure of goodness of fit for nonlinear curves.  The first plot uses standard axes to get a sense of the scale:

<figure style="text-align:center;">
	<a href="{{ site.baseurl }}/images/metareturns/linear-returns.png"><img src="{{ site.baseurl }}/images/metareturns/linear-returns.png"></a>
</figure>

Here's the same plot with log-log axes to get a better view the data:

<figure style="text-align:center;">
	<a href="{{ site.baseurl }}/images/metareturns/lognormal-returns.png"><img src="{{ site.baseurl }}/images/metareturns/lognormal-returns.png"></a>
</figure>

## The Efficient Frontier

Finally, I use a modified version of an algorithm [described on Quantopian](https://blog.quantopian.com/markowitz-portfolio-optimization-2/) to generate an efficient frontier.  Each point along the curve represents a portfolio of interventions with the highest expected impact for the level of risk.  The covariance matrix I used as input is all zeros except for the variances, although this could be changed if you have some reason to think intervention outcomes are correlated in some way.  

Note that the plot below is interactive with tooltips and scroll-to-zoom enabled.  

<iframe id="vis" src="{{ site.baseurl }}/vis/meta-returns.html"
    style="width: 100%; height:550px; border: none; position: relative; scrolling:no;">
</iframe>

## Conclusion

* It seems like there are returns to risk taking for both the individual and combined estimates. This is useful to know because it means a a large error bound on a cost effectiveness estimate shouldn’t be disqualifying on it’s own.
* Plots like these could be useful for identifying promising interventions, especially when many independent estimates point in the same direction.  This seems to be the case for many malaria, HIV, and smoking cessation interventions in the plot above.  
* This framework could also provide a useful sanity check for future estimates.  For example, if an estimate is far above the existing frontier, it might be worth reviewing it for an incorrect calculation or poor assumption.  But it's important to be careful when doing this because these estimates only cover a small fraction of the possible actions one could take in the world.    
* The intervention with the highest expected impact (and highest uncertainty) is research into diarrheal disease.  This suggests that research can be very beneficial even if it's more uncertain.  This relationship might be even more clear if we were to add estimates from more esoteric forms of basic research, although some forms of research might not be amenable to this type of analysis.

## References

[1] *Are there returns to risk taking in science, philanthropy, or public policy?* [https://pstblog.com/2017/12/02/risk-return](https://pstblog.com/2017/12/02/risk-return)

[2] *Efficient Frontier.*  Wikipedia. [https://en.wikipedia.org/wiki/Efficient_frontier](https://en.wikipedia.org/wiki/Efficient_frontier)

[3] *psthomas: efficient-frontier*.  GitHub.  [https://github.com/psthomas/efficient-frontier](https://github.com/psthomas/efficient-frontier)

[4] *Global Health Cost Effectiveness Analysis Registry.* Tufts University.  [http://healtheconomics.tuftsmedicalcenter.org/ghcearegistry/](http://healtheconomics.tuftsmedicalcenter.org/ghcearegistry/)

[5] *Confidence Interval*. Wolfram. [https://mathworld.wolfram.com/ConfidenceInterval.html](https://mathworld.wolfram.com/ConfidenceInterval.html)

[6] *Relationship between the range and the standard deviation.* Stack Exchange. 
[https://stats.stackexchange.com/questions/69575/relationship-between-the-range-and-the-standard-deviation](https://stats.stackexchange.com/questions/69575/relationship-between-the-range-and-the-standard-deviation)

[7] *The Efficient Frontier: Markowitz portfolio optimization in Python.* Quantopian.  
[https://blog.quantopian.com/markowitz-portfolio-optimization-2/](https://blog.quantopian.com/markowitz-portfolio-optimization-2/) 

[8] *Why Is There No R-Squared for Nonlinear Regression?* [http://blog.minitab.com/blog/adventures-in-statistics-2/why-is-there-no-r-squared-for-nonlinear-regression](http://blog.minitab.com/blog/adventures-in-statistics-2/why-is-there-no-r-squared-for-nonlinear-regression)