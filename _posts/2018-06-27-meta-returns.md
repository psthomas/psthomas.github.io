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
	<img style="max-width:500px;" src="{{ site.baseurl }}/images/metareturns/output_18_0.png"></a>
	<!--<figcaption>One of the results from below.</figcaption>-->
</figure>

All the code and data for this project are available on GitHub [here](https://github.com/psthomas/risk-return).  

## Data Wrangling

Because both the GiveWell and Future of Humanity Institute (FHI) data share the same units, I can combine them to get a sense of the scale. Also, if I lazily assume that I can estimate the standard deviation of the Disease Control Priorities (DCP2) and National Institute for Health and Care Excellence (NICE) estimates by dividing the [range of the estimates by two](https://stats.stackexchange.com/questions/69575/relationship-between-the-range-and-the-standard-deviation), those can be included as well.  Note also that the NICE estimates are median results while Givewell and FHI are mean results, so this might need to be changed.  There are more in-depth descriptions of the sources for these data in my [previous post](https://pstblog.com/2017/12/02/risk-return).

All the other conversions are pretty straightforward, but the [Global Health Cost Effectiveness Analysis Registry](http://healtheconomics.tuftsmedicalcenter.org/ghcearegistry/) (GHCEA) data required more wrangling.  First, I needed to convert the confidence intervals to standard deviations, which requires making a bunch of assumptions.  Here's what the Cochrane Review [has to say](http://handbook-5-1.cochrane.org/chapter_7/7_7_3_2_obtaining_standard_deviations_from_standard_errors_and.htm) about this process: 

> Confidence intervals for means can also be used to calculate standard deviations . . . Most confidence intervals are 95% confidence intervals. If the sample size is large (say bigger than 100 in each group), the 95% confidence interval is 3.92 standard errors wide (3.92 = 2 × 1.96). The standard deviation for each group is obtained by dividing the length of the confidence interval by 3.92, and then multiplying by the square root of the sample size:  
> &emsp; &emsp; `SD = np.sqrt(N) * (upper_limit - lower_limit)/3.92`  
> For 90% confidence intervals 3.92 should be replaced by 3.29, and for 99% confidence intervals it should be replaced by 5.15.

So if I assume a 95% confidence intervals unless otherwise stated, N=1000 simulations for their monte carlo analyses, and simulated samples that follow a normal distribution, I can back-calculate the standard deviation.  This assumes quite a lot (especially the N=1000 simulations part), so I'd be open to advice on how to better handle this.  In addition to the calculations above, I filter out any GHCEA studies that were rated below 4.5 by reviewers on a 1-7 quality scale.  The end result is 653 interventions with standard deviations and cost effectiveness estimates.  

One final thing to consider: the Givewell estimates are from shovel-ready charities accepting donations, while many of the others measure impact against a counterfactual using an [Incremental Cost Effectiveness Ratio](https://en.wikipedia.org/wiki/Incremental_cost-effectiveness_ratio) without a clear avenue for donors to make that change happen.  Instead, many of these interventions probably need to be implemented at the hospital, insurer, or government policy level rather than through a charity.  

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
      <th>3</th>
      <td>Research - Diarrhoeal diseases</td>
      <td>3549.783221</td>
      <td>286578.696559</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Research - Meningititis</td>
      <td>1732.527683</td>
      <td>150346.122518</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Research - Leishmaniasis</td>
      <td>1703.723172</td>
      <td>191421.556624</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>846</th>
      <td>Routine measles-containing vaccine followed by...</td>
      <td>1000.000000</td>
      <td>5703.964033</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>413</th>
      <td>Aspirin alone (325 mg initial dose &amp; subsequen...</td>
      <td>1000.000000</td>
      <td>12879.918785</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>571</th>
      <td>Preventive treatment of malaria in pregnancy w...</td>
      <td>1000.000000</td>
      <td>104.797239</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>564</th>
      <td>Preventive treatment of malaria in pregnancy w...</td>
      <td>1000.000000</td>
      <td>2618.212999</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>921</th>
      <td>New tuberculosis vaccine (40% efficacy)</td>
      <td>1000.000000</td>
      <td>7394.027451</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Research - Leprosy</td>
      <td>824.521890</td>
      <td>104639.483899</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Research - Trypanosomiasis</td>
      <td>802.785665</td>
      <td>107344.569326</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Research - Malaria</td>
      <td>801.655755</td>
      <td>67817.253156</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Research - Multiple salmonella infections</td>
      <td>753.616047</td>
      <td>46757.225910</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Research - Typhoid and paratyphoid fever</td>
      <td>709.092672</td>
      <td>53697.852674</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Research - Chagas disease</td>
      <td>534.967344</td>
      <td>61260.904879</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>514</th>
      <td>Syphilis screening before third trimester + tr...</td>
      <td>500.000000</td>
      <td>2402.946550</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>887</th>
      <td>Brief smoking cessation advice + Bupropion</td>
      <td>333.333333</td>
      <td>0.461113</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>912</th>
      <td>Syphilis screening before third trimester + tr...</td>
      <td>333.333333</td>
      <td>1597.109929</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>338</th>
      <td>Intermittent preventive treatment in infants (...</td>
      <td>333.333333</td>
      <td>2001.390889</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>523</th>
      <td>Syphilis screening before third trimester + tr...</td>
      <td>333.333333</td>
      <td>1373.112314</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>786</th>
      <td>Intermittent preventive treatment in infants (...</td>
      <td>333.333333</td>
      <td>2584.320274</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>0</th>
      <td>Research - HIV</td>
      <td>303.678832</td>
      <td>23736.173393</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Research - Trichuriasis</td>
      <td>251.336051</td>
      <td>11972.794952</td>
      <td>FHI</td>
    </tr>
    <tr>
      <th>918</th>
      <td>New tuberculosis vaccine (40% efficacy)</td>
      <td>250.000000</td>
      <td>1038.432984</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>572</th>
      <td>Syphilis screening before third trimester + tr...</td>
      <td>250.000000</td>
      <td>998.193706</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>771</th>
      <td>Syphilis screening before third trimester + tr...</td>
      <td>250.000000</td>
      <td>1201.473275</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>294</th>
      <td>Syphilis screening before third trimester + tr...</td>
      <td>250.000000</td>
      <td>1373.112314</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>789</th>
      <td>Malaria intermittent preventive treatment in i...</td>
      <td>250.000000</td>
      <td>753.353740</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>327</th>
      <td>Syphilis screening before third trimester + tr...</td>
      <td>250.000000</td>
      <td>1201.473275</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>634</th>
      <td>Magnesium sulfate</td>
      <td>250.000000</td>
      <td>5703.964033</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>332</th>
      <td>Intermittent preventive treatment in infants (...</td>
      <td>250.000000</td>
      <td>1786.476431</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Risperidone (5 mg/day)</td>
      <td>0.025000</td>
      <td>96.211442</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>230</th>
      <td>Universal hearing screening using otoacoustic ...</td>
      <td>0.024390</td>
      <td>0.185710</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>169</th>
      <td>Cochlear implant</td>
      <td>0.023810</td>
      <td>0.222216</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>41</th>
      <td>HMG-CoA reductase inhibitors (statins) via mai...</td>
      <td>0.019608</td>
      <td>0.362980</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>47</th>
      <td>Treatment of Kaposi's sarcoma</td>
      <td>0.019066</td>
      <td>0.014301</td>
      <td>DCP2</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Active After-school Communities Program (AASC)...</td>
      <td>0.016949</td>
      <td>0.063884</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>232</th>
      <td>Pulse oximetry + clinical assessment</td>
      <td>0.016949</td>
      <td>0.457310</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>126</th>
      <td>General practitioner referral to exercise phys...</td>
      <td>0.015385</td>
      <td>0.070669</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>60</th>
      <td>Pre-diabetes screen plus Metformin, diet and e...</td>
      <td>0.014286</td>
      <td>0.068841</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Therapy with Bupropion for Tobacco Cessation</td>
      <td>0.014286</td>
      <td>2.586740</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>80</th>
      <td>Olanzapine (15 mg/day)</td>
      <td>0.013158</td>
      <td>0.068253</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>233</th>
      <td>Colonoscopy screening every 10 years</td>
      <td>0.012987</td>
      <td>0.964205</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>73</th>
      <td>Pre-diabetes screen plus Orlistat to prevent o...</td>
      <td>0.011494</td>
      <td>0.221821</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Residential treatment + naltrexone</td>
      <td>0.010000</td>
      <td>0.092855</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>246</th>
      <td>Cochlear implant</td>
      <td>0.010000</td>
      <td>0.364138</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>274</th>
      <td>Longer individual intervention by telephone fo...</td>
      <td>0.010000</td>
      <td>0.313466</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>111</th>
      <td>Optimal treatment with antipsychotic medicatio...</td>
      <td>0.010000</td>
      <td>0.054807</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>107</th>
      <td>Cognitive dissonance – school based bulimia an...</td>
      <td>0.009091</td>
      <td>0.084410</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>87</th>
      <td>Sibutramine treatment</td>
      <td>0.008333</td>
      <td>0.088728</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>681</th>
      <td>Cochlear implant</td>
      <td>0.008333</td>
      <td>0.182431</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>352</th>
      <td>Cochlear implant</td>
      <td>0.006250</td>
      <td>0.249892</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>217</th>
      <td>Human papilloma virus (HPV) vaccine; 70% coverage</td>
      <td>0.006250</td>
      <td>0.063415</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>59</th>
      <td>Residential treatment - alcohol</td>
      <td>0.005882</td>
      <td>0.058717</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>43</th>
      <td>Looma Healthy Lifestyle- community based inter...</td>
      <td>0.005556</td>
      <td>0.038026</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>289</th>
      <td>Cochlear implant</td>
      <td>0.005556</td>
      <td>0.333370</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>63</th>
      <td>Current treatment: all patients receiving anti...</td>
      <td>0.005263</td>
      <td>0.045976</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>369</th>
      <td>Creatinine test conducted at baseline (asympto...</td>
      <td>0.005263</td>
      <td>0.012386</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>44</th>
      <td>Orlistat treatment</td>
      <td>0.004762</td>
      <td>0.046974</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>875</th>
      <td>Cochlear implants</td>
      <td>0.004167</td>
      <td>0.269500</td>
      <td>GHCEA</td>
    </tr>
    <tr>
      <th>50</th>
      <td>Walking School Bus (WSB) program to increase t...</td>
      <td>0.001852</td>
      <td>0.002584</td>
      <td>GHCEA</td>
    </tr>
  </tbody>
</table>
<p>761 rows × 4 columns</p>
</div>


A histogram of all the results together: 

<figure>
	<a href="{{ site.baseurl }}/images/metareturns/output_14_0.png"><img src="{{ site.baseurl }}/images/metareturns/output_14_0.png"></a>
</figure>

And here are histograms of the individual sources:

<figure>
	<a href="{{ site.baseurl }}/images/metareturns/output_15_1.png"><img src="{{ site.baseurl }}/images/metareturns/output_15_1.png"></a>
</figure>

## Fitting Some Curves

So how do I determine if there is a **return to risk taking**?  One approach would be to run a linear regression through the data and see if it has a positive slope.  This is what I do first below, but there's a problem with this approach.  To see why, imagine calculating the cost effectiveness of every possible action, including bogus things like lighting $1000 on fire.  You'd end up with a lot of useless interventions that would mess up the slope of the linear regression.  

So my second approach is to just see if the frontier that encloses the top end of the estimates has a positive slope.  In Modern Portfolio Theory, this frontier is called the [efficient frontier](https://en.wikipedia.org/wiki/Efficient_frontier), which I've written about [before](https://github.com/psthomas/efficient-frontier).  I didn't have enough data to test out this theory in the past, but the combination of all these sources makes it possible to do so now. 

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/metareturns/frontier.jpg"><img src="{{ site.baseurl }}/images/metareturns/frontier.jpg"></a>
	<figcaption>An example of an efficient frontier.</figcaption>
</figure>

Below, I fit a linear regression and a power law to the results.  The power law has a slightly higher r-squared value, but this [isn't really](http://blog.minitab.com/blog/adventures-in-statistics-2/why-is-there-no-r-squared-for-nonlinear-regression) a valid measure of goodness of fit for nonlinear curves.  The first plot uses standard axes to get a sense of the scale:

<figure>
	<a href="{{ site.baseurl }}/images/metareturns/output_17_0.png"><img src="{{ site.baseurl }}/images/metareturns/output_17_0.png"></a>
</figure>

Here's the same plot with log-log axes to get a better view the data:

<figure>
	<a href="{{ site.baseurl }}/images/metareturns/output_18_0.png"><img src="{{ site.baseurl }}/images/metareturns/output_18_0.png"></a>
</figure>

## The Efficient Frontier

Finally, I use a modified version of an algorithm [described on Quantopian](https://blog.quantopian.com/markowitz-portfolio-optimization-2/) to generate an efficient frontier.  Each point along the curve represents a portfolio of interventions with the highest expected impact for the level of risk.  The covariance matrix I used as input is all zeros except for the variances, although this could be changed if you have some reason to think intervention outcomes are correlated in some way.  

Note that the plot below is interactive with tooltips and scroll-to-zoom enabled.  

<iframe id="vis" src="{{ site.baseurl }}/vis/meta-returns.html"
    style="width: 100%; height:500px; border: none; position: relative; scrolling:no;">
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

[5] The Cochrane Review Handbook. [http://handbook-5-1.cochrane.org/chapter_7/7_7_3_2_obtaining_standard_deviations_from_standard_errors_and.htm](http://handbook-5-1.cochrane.org/chapter_7/7_7_3_2_obtaining_standard_deviations_from_standard_errors_and.htm)

[6] *Relationship between the range and the standard deviation.* Stack Exchange. 
[https://stats.stackexchange.com/questions/69575/relationship-between-the-range-and-the-standard-deviation](https://stats.stackexchange.com/questions/69575/relationship-between-the-range-and-the-standard-deviation)

[7] *The Efficient Frontier: Markowitz portfolio optimization in Python.* Quantopian.  
[https://blog.quantopian.com/markowitz-portfolio-optimization-2/](https://blog.quantopian.com/markowitz-portfolio-optimization-2/) 


[8] *Why Is There No R-Squared for Nonlinear Regression?* [http://blog.minitab.com/blog/adventures-in-statistics-2/why-is-there-no-r-squared-for-nonlinear-regression](http://blog.minitab.com/blog/adventures-in-statistics-2/why-is-there-no-r-squared-for-nonlinear-regression)