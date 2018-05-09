---
layout: post
title: "Are there returns to risk taking in science, philanthropy, or public policy?"
excerpt: "I look at the relationship between risk and expected return in a number of datasets."
#modified:
tags: [Python, Jupyter notebook, altruism, risk, social impact]
comments: true
share: false

---

If you're hoping to do good in the world, it makes sense to ask where your efforts will make the biggest impact.  Some have claimed that high risk, high return projects are most promising because those areas are less crowded.  For example, here's a quote from Robert Reich's [essay](http://bostonreview.net/forum/foundations-philanthropy-democracy) on the role of philanthropic foundations in society: 

> When it comes to the ongoing work of experimentation, foundations have a structural advantage over market and state institutions: a longer time horizon. Once more, the lack of accountability may be a surprising advantage. . . foundations are not subject to earnings reports, impatient investors or stockholders, or short-term election cycles.  Foundations, answerable only to the diverse preferences and ideas of their donors, with a protected endowment permitted to exist in perpetuity, may be uniquely situated to engage in the sort of high-risk, long-run policy innovation and experimentation that is healthy in a democratic society.

The Open Philanthropy Project outlines a similar approach in [a post](https://www.openphilanthropy.org/blog/hits-based-giving) about their giving philosophy: 

> One of our core values is our tolerance for philanthropic “risk.” Our overarching goal is to do as much good as we can, and as part of that, we’re open to supporting work that has a high risk of failing to accomplish its goals. We’re even open to supporting work that is more than 90% likely to fail, as long as the overall expected value is high enough.

It seems [intuitive](https://blog.givewell.org/2013/05/02/broad-market-efficiency/) that there are returns to risk taking but I was wondering if there were any datasets out there that would support this idea.  Below I attempt to answer this question by looking at evidence from science, philanthropy, and public policy.   


## Definitions

Before I continue, I think it makes sense to define the terms **risk** and **return**.  By **return**, I mean the impact of an intervention using units like [disability adjusted life years](https://en.wikipedia.org/wiki/Disability-adjusted_life_year) per dollar, benefit to cost ratios, or research citation counts.  While some of these estimates are more complicated to construct than others, they all require making judgements about things like the value of a human life, the amount of suffering caused by different conditions, or the benefits from a highly cited paper.  

The definition of the term **risk** is tricky to pin down.  To some, it's just a measure of the noisiness of an estimate and is measured using something like the [standard deviation](https://en.wikipedia.org/wiki/Standard_deviation).  To others, an intervention is only risky when it could potentially underperform some target (e.g. [downside risk](https://en.wikipedia.org/wiki/Downside_risk)) or cause harm.  The best [definition](https://medium.com/guesstimate-blog/the-confusion-of-risk-vs-uncertainty-1c6cd512aa69) that I have found is that risk is the subset of uncertainty that underperforms a target outcome.  Because people seem to use risk and uncertainty interchangeably, and I think both are useful, I include both in my analysis where possible. 

The uncertainty and risk values are useful for answering two separate but related questions: **(1)** Do we tend to be more uncertain about actions with high expected value?;  **(2)** Do actions with large expected value also have more potential to cause harm (or underperform the mean action)?  If **(1)** is correct, I think this is useful to know because we can be more confident in taking actions even if they have a high error around the estimated impact.   If **(2)** is correct, it might be ok to take actions that often perform poorly or have the potential to cause harm if they still have a high expected impact.   

Here are how the values are calculated:

* `standard deviation = np.stdev(series)`  
* `downside risk (semideviation) = np.sqrt((np.minimum(0.0, series - t)**2).sum()/series.size)`, where `t` is the mean intervention outcome  


## Data Sources 

It's pretty difficult to find datasets that quantify their uncertainty while also using a cross-intervention measure of impact, so it's taken me awhile to stumble across enough data to complete this analysis.  The `scrape.py` file included in [the repo](https://github.com/psthomas/risk-return) for this projects outlines how I accessed and cleaned data from each source.  

All the code and data for this post are available [here](https://github.com/psthomas/risk-return).  
  

## Evidence from Public Policy

First, I look at a dataset from the [Washington State Institute for Public Policy](http://www.wsipp.wa.gov/BenefitCost) (WSIPP).  The WSIPP evaluates evidence based public policies and completes detailed benefit-cost analyses using monte carlo methods.  The end result is a list of benefit-cost ratios along with metrics like the chance that the benefit-cost ratio is positive. 

The measure of risk I'm using here (`the chance costs exceed benefits`) sets a really low bar.  This ignores the upside of an intervention and much of the downside until the benefit cost ratio is below one.  It also counts a project with a very low downside the same of one with only a marginally low downside because they're just counting up benefit-cost ratios > 1 and [dividing by the total number of monte carlo runs](http://www.wsipp.wa.gov/TechnicalDocumentation/WsippBenefitCostTechnicalDocumentation.pdf).  The upside of this metric is that it is easy to interpret, but I wish they would include a standard deviation as well.         


<div>

<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>program_name</th>
      <th>benefit_cost_ratio</th>
      <th>chance_costs_exceed_benefits</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Educator professional development: Use of data...</td>
      <td>-174.30</td>
      <td>69</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Scared Straight</td>
      <td>-101.25</td>
      <td>98</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Behavioral self-control training -BSCT</td>
      <td>-80.03</td>
      <td>77</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Alcohol Literacy Challenge -for college students</td>
      <td>-34.25</td>
      <td>51</td>
    </tr>
    <tr>
      <th>4</th>
      <td>InShape</td>
      <td>-29.59</td>
      <td>53</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Drug Abuse Resistance Education -D.A.R.E.</td>
      <td>-7.71</td>
      <td>51</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Youth advocacy/empowerment programs for tobacc...</td>
      <td>-7.13</td>
      <td>64</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Sex offender registration and community notifi...</td>
      <td>-5.14</td>
      <td>67</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Interventions to prevent excessive gestational...</td>
      <td>-5.03</td>
      <td>64</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Interventions to prevent excessive gestational...</td>
      <td>-3.71</td>
      <td>53</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Police diversion for individuals with mental i...</td>
      <td>-2.94</td>
      <td>99</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Treatment for juveniles convicted of sex offen...</td>
      <td>-2.59</td>
      <td>82</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Project SUCCESS</td>
      <td>-1.84</td>
      <td>61</td>
    </tr>
    <tr>
      <th>13</th>
      <td>"Check-in" behavior interventions</td>
      <td>-1.71</td>
      <td>54</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Opening Doors advising in community college</td>
      <td>-1.70</td>
      <td>78</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Multicomponent environmental interventions to ...</td>
      <td>-1.64</td>
      <td>73</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Inpatient or intensive outpatient drug treatme...</td>
      <td>-1.51</td>
      <td>66</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Domestic violence perpetrator treatment -Dulut...</td>
      <td>-1.50</td>
      <td>77</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Other Family Preservation Services -non-HOMEBU...</td>
      <td>-1.40</td>
      <td>100</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Life skills education</td>
      <td>-1.33</td>
      <td>65</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Intensive supervision -probation</td>
      <td>-1.32</td>
      <td>100</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Even Start</td>
      <td>-1.15</td>
      <td>69</td>
    </tr>
    <tr>
      <th>22</th>
      <td>Family dependency treatment court</td>
      <td>-1.11</td>
      <td>93</td>
    </tr>
    <tr>
      <th>23</th>
      <td>CASASTART</td>
      <td>-1.04</td>
      <td>77</td>
    </tr>
    <tr>
      <th>24</th>
      <td>Cognitive behavioral therapy -CBT for children...</td>
      <td>-1.01</td>
      <td>92</td>
    </tr>
    <tr>
      <th>25</th>
      <td>Cognitive-behavioral coping-skills therapy for...</td>
      <td>-0.99</td>
      <td>58</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Primary care in behavioral health settings -co...</td>
      <td>-0.96</td>
      <td>75</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Community-based correctional facilities -halfw...</td>
      <td>-0.71</td>
      <td>100</td>
    </tr>
    <tr>
      <th>28</th>
      <td>Early Start -New Zealand</td>
      <td>-0.49</td>
      <td>98</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Interventions to reduce unnecessary emergency ...</td>
      <td>-0.48</td>
      <td>52</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>294</th>
      <td>Project EX</td>
      <td>41.71</td>
      <td>12</td>
    </tr>
    <tr>
      <th>295</th>
      <td>Education and Employment Training -EET King Co...</td>
      <td>41.84</td>
      <td>0</td>
    </tr>
    <tr>
      <th>296</th>
      <td>Seeking Safety</td>
      <td>42.40</td>
      <td>12</td>
    </tr>
    <tr>
      <th>297</th>
      <td>Smoking cessation programs for pregnant women:...</td>
      <td>47.61</td>
      <td>2</td>
    </tr>
    <tr>
      <th>298</th>
      <td>Acceptance and Commitment Therapy for adult an...</td>
      <td>48.55</td>
      <td>15</td>
    </tr>
    <tr>
      <th>299</th>
      <td>Cognitive behavioral therapy -CBT for adult de...</td>
      <td>49.09</td>
      <td>0</td>
    </tr>
    <tr>
      <th>300</th>
      <td>Cognitive behavioral therapy -CBT for adult an...</td>
      <td>54.01</td>
      <td>0</td>
    </tr>
    <tr>
      <th>301</th>
      <td>Anti-smoking media campaigns adult effect</td>
      <td>57.07</td>
      <td>13</td>
    </tr>
    <tr>
      <th>302</th>
      <td>Consultant teachers: Online coaching</td>
      <td>61.94</td>
      <td>8</td>
    </tr>
    <tr>
      <th>303</th>
      <td>Summer book programs: Multi-year intervention</td>
      <td>63.90</td>
      <td>30</td>
    </tr>
    <tr>
      <th>304</th>
      <td>Case management in schools</td>
      <td>64.07</td>
      <td>4</td>
    </tr>
    <tr>
      <th>305</th>
      <td>Good Behavior Game</td>
      <td>65.47</td>
      <td>30</td>
    </tr>
    <tr>
      <th>306</th>
      <td>Teacher performance pay programs</td>
      <td>65.55</td>
      <td>12</td>
    </tr>
    <tr>
      <th>307</th>
      <td>Teacher professional development: Induction/me...</td>
      <td>70.72</td>
      <td>36</td>
    </tr>
    <tr>
      <th>308</th>
      <td>More intensive tobacco quitlines -compared to ...</td>
      <td>73.51</td>
      <td>0</td>
    </tr>
    <tr>
      <th>309</th>
      <td>College advising provided by counselors -for h...</td>
      <td>74.56</td>
      <td>0</td>
    </tr>
    <tr>
      <th>310</th>
      <td>School-based tobacco prevention programs</td>
      <td>75.10</td>
      <td>1</td>
    </tr>
    <tr>
      <th>311</th>
      <td>Cognitive behavioral therapy -CBT for adult po...</td>
      <td>88.11</td>
      <td>0</td>
    </tr>
    <tr>
      <th>312</th>
      <td>Model Smoking Prevention Program</td>
      <td>89.83</td>
      <td>9</td>
    </tr>
    <tr>
      <th>313</th>
      <td>Access to tobacco quitlines</td>
      <td>95.85</td>
      <td>5</td>
    </tr>
    <tr>
      <th>314</th>
      <td>Teacher professional development: Use of data ...</td>
      <td>122.55</td>
      <td>2</td>
    </tr>
    <tr>
      <th>315</th>
      <td>Tutoring: By peers</td>
      <td>133.59</td>
      <td>17</td>
    </tr>
    <tr>
      <th>316</th>
      <td>Text message reminders -for high school graduates</td>
      <td>135.71</td>
      <td>47</td>
    </tr>
    <tr>
      <th>317</th>
      <td>Anti-smoking media campaign youth effect</td>
      <td>147.33</td>
      <td>0</td>
    </tr>
    <tr>
      <th>318</th>
      <td>Consultant teachers: Content-Focused Coaching</td>
      <td>173.17</td>
      <td>6</td>
    </tr>
    <tr>
      <th>319</th>
      <td>Summer outreach counseling -for high school gr...</td>
      <td>195.39</td>
      <td>10</td>
    </tr>
    <tr>
      <th>320</th>
      <td>Alcohol Literacy Challenge -for high school st...</td>
      <td>259.46</td>
      <td>42</td>
    </tr>
    <tr>
      <th>321</th>
      <td>Text messaging programs for smoking cessation</td>
      <td>363.46</td>
      <td>0</td>
    </tr>
    <tr>
      <th>322</th>
      <td>Eye Movement Desensitization and Reprocessing ...</td>
      <td>598.94</td>
      <td>0</td>
    </tr>
    <tr>
      <th>323</th>
      <td>Computer-based programs for smoking cessation</td>
      <td>794.18</td>
      <td>0</td>
    </tr>
  </tbody>
</table>

</div>

Below is a plot of the intervention rank and the benefit-cost ratio.  It's clear that some interventions outperform others by a few orders of magnitude.  Another interesting finding is that the distribution might be two tailed, with some outlying performers on the bad end as well.   

<figure>
	<a href="{{ site.baseurl }}/images/returns/output_5_0.png"><img src="{{ site.baseurl }}/images/returns/output_5_0.png"></a>
</figure>


Next, I plot the chance costs exceed benefits (an imperfect proxy for downside risk) against the benefit-cost ratio.  I derive the `chance costs exceed benefits` from WSIPP's `chance benefits exceed costs`  value, which they calculate by counting results from their monte carlo simulations.  This measure doesn't take into account the scale of good/poor performance, but it's the best we can get without access to their models.

The end result is that there doesn't seem to be much of a return to this measure of risk.    


<figure>
	<a href="{{ site.baseurl }}/images/returns/output_7_0.png"><img src="{{ site.baseurl }}/images/returns/output_7_0.png"></a>
</figure>


## Evidence from Public Health

The next dataset I look it is from the [Disease Control Priorities Project](http://www.dcp-3.org/dcp2) (DCP2), which comes up with comprehensive estimates of the cost effectiveness of different treatments in developing countries.  The original source is a table in the DCP2 report, which Jeff Kaufmann made into a [CSV](https://www.jefftk.com/dcp2.csv).  I selected the interventions with `$/DALY` units, eliminated any with zero or near zero spread (because they likely came from the same estimate), and only selected the estimates from sub-saharan Africa. Finally I converted `$/DALY` units to `DALY/1000USD` so a bigger number has a higher impact.  

Using the spread isn't very rigorous and might bias the results towards understudied areas with few estimates (e.g. an intervention with only a single estimate has spread of 0), but it's the only measure of uncertainty available here.  


<div>

<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>condition</th>
      <th>intervention</th>
      <th>cost_effectiveness</th>
      <th>spread</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>29</th>
      <td>Malaria</td>
      <td>Intermittent preventive treatment in pregnancy...</td>
      <td>142.857143</td>
      <td>111.111111</td>
    </tr>
    <tr>
      <th>28</th>
      <td>Malaria</td>
      <td>Insecticidetreated bednets</td>
      <td>90.909091</td>
      <td>83.333333</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Lymphatic filariasis</td>
      <td>Annual mass drug administration</td>
      <td>66.666667</td>
      <td>43.478261</td>
    </tr>
    <tr>
      <th>41</th>
      <td>Malaria</td>
      <td>Residual household spraying</td>
      <td>58.823529</td>
      <td>66.666667</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Malaria</td>
      <td>Intermittent preventive treatment in pregnancy...</td>
      <td>52.631579</td>
      <td>90.909091</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Traffic accidents</td>
      <td>Increased speeding penalties, enforcement, med...</td>
      <td>47.619048</td>
      <td>28.571429</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Lymphatic filariasis</td>
      <td>Diethyl carbamazine salt</td>
      <td>45.454545</td>
      <td>23.809524</td>
    </tr>
    <tr>
      <th>39</th>
      <td>HIV/AIDS</td>
      <td>Peer and education programs for high-risk groups</td>
      <td>27.027027</td>
      <td>16.129032</td>
    </tr>
    <tr>
      <th>52</th>
      <td>HIV/AIDS</td>
      <td>Voluntary counseling and testing</td>
      <td>21.276596</td>
      <td>13.333333</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Tuberculosis (endemic)</td>
      <td>BCG vaccine</td>
      <td>14.705882</td>
      <td>37.037037</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Stroke (recurrent)</td>
      <td>Aspirin and dipyridamole</td>
      <td>12.345679</td>
      <td>43.478261</td>
    </tr>
    <tr>
      <th>14</th>
      <td>HIV/AIDS</td>
      <td>Condom promotion and distribution</td>
      <td>12.195122</td>
      <td>16.666667</td>
    </tr>
    <tr>
      <th>10</th>
      <td>HIV/AIDS</td>
      <td>Blood and needle safety</td>
      <td>11.904762</td>
      <td>18.518519</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Tuberculosis (epidemic, infectious)</td>
      <td>Directly observed short-course chemotherapy</td>
      <td>9.803922</td>
      <td>5.747126</td>
    </tr>
    <tr>
      <th>43</th>
      <td>Emergency medical care</td>
      <td>Staffed community ambulance</td>
      <td>8.333333</td>
      <td>8.403361</td>
    </tr>
    <tr>
      <th>49</th>
      <td>HIV/AIDS</td>
      <td>Tuberculosis coinfection prevention and treatment</td>
      <td>8.264463</td>
      <td>34.482759</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Lower acute respiratory infections (nonsevere)</td>
      <td>Case management at community or facility level</td>
      <td>7.751938</td>
      <td>6.329114</td>
    </tr>
    <tr>
      <th>45</th>
      <td>Problems requiring surgery</td>
      <td>Surgical ward or services in district hospital...</td>
      <td>7.352941</td>
      <td>6.134969</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Diarrheal disease</td>
      <td>Construction and promotion of basic sanitation...</td>
      <td>7.092199</td>
      <td>3.861004</td>
    </tr>
    <tr>
      <th>0</th>
      <td>Congestive heart failure</td>
      <td>ACE inhibitor and beta-blocker, with diuretics</td>
      <td>6.666667</td>
      <td>4.048583</td>
    </tr>
    <tr>
      <th>48</th>
      <td>HIV/AIDS</td>
      <td>Treatment of opportunistic infections</td>
      <td>6.410256</td>
      <td>3.257329</td>
    </tr>
    <tr>
      <th>51</th>
      <td>Lymphatic filariasis</td>
      <td>Vector control</td>
      <td>6.250000</td>
      <td>4.273504</td>
    </tr>
    <tr>
      <th>38</th>
      <td>HIV/AIDS</td>
      <td>Mother-to-child transmission prevention</td>
      <td>5.208333</td>
      <td>2.702703</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Tuberculosis (epidemic, latent)</td>
      <td>Isoniazid treatment</td>
      <td>5.076142</td>
      <td>3.300330</td>
    </tr>
    <tr>
      <th>37</th>
      <td>Tuberculosis (epidemic)</td>
      <td>Management of drug resistance</td>
      <td>4.830918</td>
      <td>90.909091</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Tuberculosis (endemic, infectious or noninfect...</td>
      <td>Directly observed short-course chemotherapy</td>
      <td>3.322259</td>
      <td>2.141328</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Tuberculosis (endemic)</td>
      <td>Management of drug resistance</td>
      <td>3.144654</td>
      <td>4.524887</td>
    </tr>
    <tr>
      <th>24</th>
      <td>Neonatal mortality</td>
      <td>Family, community, or clinical neonatal package</td>
      <td>2.898551</td>
      <td>76.923077</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Alcohol abuse</td>
      <td>Advertising ban and reduced access to beverage...</td>
      <td>2.475248</td>
      <td>13.513514</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Alcohol abuse</td>
      <td>Excise tax, advertising ban, with brief advice</td>
      <td>1.584786</td>
      <td>16.666667</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Ischemic heart disease</td>
      <td>Aspirin, betablocker, and optional ACE inhibitor</td>
      <td>1.453488</td>
      <td>2.105263</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Panic disorder</td>
      <td>Drugs with optional psychosocial treatment</td>
      <td>1.362398</td>
      <td>1.428571</td>
    </tr>
    <tr>
      <th>33</th>
      <td>Coronary artery disease</td>
      <td>Legislation substituting 2% of trans fat with ...</td>
      <td>1.193317</td>
      <td>0.781861</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HIV/AIDS</td>
      <td>Antiretroviral therapy</td>
      <td>1.084599</td>
      <td>0.874126</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Parkinson's disease</td>
      <td>Ayurvedic treatment and levodopa or carbidopa</td>
      <td>0.883392</td>
      <td>1.315789</td>
    </tr>
    <tr>
      <th>22</th>
      <td>Alcohol abuse</td>
      <td>Excise tax</td>
      <td>0.726216</td>
      <td>3.921569</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Depression</td>
      <td>Drugs with optional episodic or maintenance ps...</td>
      <td>0.588582</td>
      <td>0.479846</td>
    </tr>
    <tr>
      <th>25</th>
      <td>Stroke (ischemic)</td>
      <td>Heparin and recombinant tissue plasminogen act...</td>
      <td>0.505817</td>
      <td>0.715820</td>
    </tr>
    <tr>
      <th>44</th>
      <td>Ischemic heart disease</td>
      <td>Statin, with aspirin and betablocker with ACE ...</td>
      <td>0.493097</td>
      <td>3.039514</td>
    </tr>
    <tr>
      <th>40</th>
      <td>Stroke and ischemic and hypertensive heart dis...</td>
      <td>Polypill by absolute risk approach</td>
      <td>0.469925</td>
      <td>0.369004</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Traffic accidents</td>
      <td>Enforcement of seatbelt laws, promotion of chi...</td>
      <td>0.408330</td>
      <td>0.344828</td>
    </tr>
    <tr>
      <th>50</th>
      <td>Dengue</td>
      <td>Vector control</td>
      <td>0.389712</td>
      <td>0.871840</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Diarrheal disease</td>
      <td>Cholera or rotavirus immunization</td>
      <td>0.368732</td>
      <td>2.183406</td>
    </tr>
    <tr>
      <th>42</th>
      <td>Epilepsy (refractory)</td>
      <td>Second-line treatment with phenobarbital and l...</td>
      <td>0.330360</td>
      <td>15.151515</td>
    </tr>
    <tr>
      <th>34</th>
      <td>Bipolar disorder</td>
      <td>Lithium, valproate, with optional psy-chosocia...</td>
      <td>0.321234</td>
      <td>0.813008</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Diarrheal disease</td>
      <td>Improved water and sanitation at current cover...</td>
      <td>0.238949</td>
      <td>0.226449</td>
    </tr>
    <tr>
      <th>35</th>
      <td>Bipolar disorder</td>
      <td>Lithium, valproate, with optional psychosocial...</td>
      <td>0.226398</td>
      <td>0.604595</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Lower acute respiratory infections (severe and...</td>
      <td>Case management at hospital level</td>
      <td>0.220751</td>
      <td>0.309789</td>
    </tr>
    <tr>
      <th>46</th>
      <td>Trachoma</td>
      <td>Tetracycline or azithromycin</td>
      <td>0.159515</td>
      <td>0.198689</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Schizophrenia</td>
      <td>Antipsychotic drugs with optional psychosocial...</td>
      <td>0.101688</td>
      <td>0.067912</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Schizophrenia</td>
      <td>Antipsychotic drugs with optional psychosocial...</td>
      <td>0.083893</td>
      <td>0.063975</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Tuberculosis (endemic, latent)</td>
      <td>Isoniazid treatment</td>
      <td>0.075999</td>
      <td>0.134825</td>
    </tr>
    <tr>
      <th>47</th>
      <td>HIV/AIDS</td>
      <td>Treatment of Kaposi's sarcoma</td>
      <td>0.019066</td>
      <td>0.028602</td>
    </tr>
  </tbody>
</table>
</div>



These estimates follow a similar pattern to the WSIPP data, with the top interventions a few orders of magnitude better than the worst.  


<figure>
	<a href="{{ site.baseurl }}/images/returns/output_11_0.png"><img src="{{ site.baseurl }}/images/returns/output_11_0.png"></a>
</figure>


<figure>
	<a href="{{ site.baseurl }}/images/returns/output_12_0.png"><img src="{{ site.baseurl }}/images/returns/output_12_0.png"></a>
</figure>


So it seems there might be returns to risk taking when using the spread as the (somewhat imperfect) measure of risk.  

## Evidence from Philanthropy

GiveWell is an organization that does in-depth charity evaluations, often using cost effectiveness estimates in their decision process.  They've recently changed their approach to [explicitly accommodate](https://www.givewell.org/how-we-work/our-criteria/cost-effectiveness/cost-effectiveness-models) different philosophical positions, but the [older models](https://docs.google.com/spreadsheets/d/1KiWfiAGX_QZhRbC9xkzf3I8IqsXC5kkr-nwY_feVlcM/edit#gid=2064365103) had their staff estimate different parameters for direct input.  

Dan Wahl had the [good idea](https://danwahl.github.io/stochastic-altruism) to run a monte carlo simulation by sampling from these staff parameters, which results in a set of estimates you can use to calculate the standard deviation and downside risk for an intervention.  I downloaded [his code](https://github.com/danwahl/stochastic-altruism) and put the combined outputs into `gw_data.csv` (see scrape.py), which I include below.  

<div>

<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>mean</th>
      <th>std</th>
      <th>downside_risk</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>iodine</th>
      <td>41.418910</td>
      <td>41.364215</td>
      <td>1.438643</td>
    </tr>
    <tr>
      <th>dtw</th>
      <td>12.039437</td>
      <td>11.307934</td>
      <td>3.733827</td>
    </tr>
    <tr>
      <th>sci</th>
      <td>9.064981</td>
      <td>8.657475</td>
      <td>4.589170</td>
    </tr>
    <tr>
      <th>ss</th>
      <td>4.894470</td>
      <td>4.598517</td>
      <td>6.279625</td>
    </tr>
    <tr>
      <th>lead</th>
      <td>4.519663</td>
      <td>14.533890</td>
      <td>9.365194</td>
    </tr>
    <tr>
      <th>bednets</th>
      <td>3.572679</td>
      <td>2.964297</td>
      <td>6.958995</td>
    </tr>
    <tr>
      <th>smc</th>
      <td>3.222606</td>
      <td>2.162316</td>
      <td>7.082046</td>
    </tr>
    <tr>
      <th>cash</th>
      <td>1.060328</td>
      <td>0.380961</td>
      <td>8.921943</td>
    </tr>
  </tbody>
</table>
</div>



The cost effectiveness rankings here follow a similar pattern to the other datasets, although it's a little less pronounced:  



<figure>
	<a href="{{ site.baseurl }}/images/returns/output_17_0.png"><img src="{{ site.baseurl }}/images/returns/output_17_0.png"></a>
</figure>



<figure>
	<a href="{{ site.baseurl }}/images/returns/output_18_0.png"><img src="{{ site.baseurl }}/images/returns/output_18_0.png"></a>
</figure>



<figure>
	<a href="{{ site.baseurl }}/images/returns/output_19_0.png"><img src="{{ site.baseurl }}/images/returns/output_19_0.png"></a>
</figure>


So if you prefer to use the standard deviation as a measure, there do seem to be returns to risk taking -- higher impact estimates tend to be noisier.  But if the downside risk makes more sense to you, the lowest impact interventions underperform the mean to a greater extent.    

## Evidence from Scientific Research

I have two sources of data on the impact of scientific research.  The first is from the Future of Humanity Institute's (FHI) [research](http://www.fhi.ox.ac.uk/research-into-neglected-diseases/) looking at the long term impact of  neglected tropical disease research.  The second is data I collected from Google Scholar on the variation in citation counts vs. mean citation counts for individual researchers. 

I also found a few related papers in the existing "Science of Science" literature, and summarize those at the end.  

### FHI Estimates

These numbers differ from the GiveWell numbers above because they are estimates of the value of scientific research, and aren't derived from randomized control trials of existing treatments.  This means we should be much more [uncertain about this model](https://en.wikipedia.org/wiki/Uncertainty_quantification#Sources_of_uncertainty) and the inputs.


<div>

<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>group</th>
      <th>disease</th>
      <th>mu</th>
      <th>sigma</th>
      <th>median</th>
      <th>mean</th>
      <th>stdev</th>
      <th>downside_risk</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>3</th>
      <td>Diarrhoeal disease</td>
      <td>Diarrhoeal diseases</td>
      <td>-1.466692</td>
      <td>4.391203</td>
      <td>0.230687</td>
      <td>3549.783221</td>
      <td>286578.696559</td>
      <td>632.550051</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Meningitis</td>
      <td>Meningititis</td>
      <td>-2.503745</td>
      <td>4.463425</td>
      <td>0.081778</td>
      <td>1732.527683</td>
      <td>150346.122518</td>
      <td>641.766485</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Parasitic and vector diseases</td>
      <td>Leishmaniasis</td>
      <td>-3.706662</td>
      <td>4.721702</td>
      <td>0.024559</td>
      <td>1703.723172</td>
      <td>191421.556624</td>
      <td>646.835802</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Leprosy</td>
      <td>Leprosy</td>
      <td>-5.014960</td>
      <td>4.843504</td>
      <td>0.006638</td>
      <td>824.521890</td>
      <td>104639.483899</td>
      <td>651.840316</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Parasitic and vector diseases</td>
      <td>Trypanosomiasis</td>
      <td>-5.296044</td>
      <td>4.895739</td>
      <td>0.005011</td>
      <td>802.785665</td>
      <td>107344.569326</td>
      <td>652.374858</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Malaria</td>
      <td>Malaria</td>
      <td>-3.161076</td>
      <td>4.437962</td>
      <td>0.042380</td>
      <td>801.655755</td>
      <td>67817.253156</td>
      <td>646.600925</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Meningitis</td>
      <td>Multiple salmonella infections</td>
      <td>-1.895189</td>
      <td>4.127971</td>
      <td>0.150290</td>
      <td>753.616047</td>
      <td>46757.225910</td>
      <td>640.639386</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Meningitis</td>
      <td>Typhoid and paratyphoid fever</td>
      <td>-2.798470</td>
      <td>4.327229</td>
      <td>0.060903</td>
      <td>709.092672</td>
      <td>53697.852674</td>
      <td>645.077267</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Parasitic and vector diseases</td>
      <td>Chagas disease</td>
      <td>-4.955053</td>
      <td>4.740730</td>
      <td>0.007048</td>
      <td>534.967344</td>
      <td>61260.904879</td>
      <td>652.898381</td>
    </tr>
    <tr>
      <th>0</th>
      <td>HIV</td>
      <td>HIV</td>
      <td>-3.783888</td>
      <td>4.358867</td>
      <td>0.022734</td>
      <td>303.678832</td>
      <td>23736.173393</td>
      <td>651.055232</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Helminths</td>
      <td>Trichuriasis</td>
      <td>-1.937768</td>
      <td>3.863822</td>
      <td>0.144025</td>
      <td>251.336051</td>
      <td>11972.794952</td>
      <td>645.358976</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Helminths</td>
      <td>Ascariasis</td>
      <td>-1.894481</td>
      <td>3.776170</td>
      <td>0.150396</td>
      <td>187.775769</td>
      <td>8193.987406</td>
      <td>645.816935</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Helminths</td>
      <td>Hookworm</td>
      <td>-2.221467</td>
      <td>3.745220</td>
      <td>0.108450</td>
      <td>120.526560</td>
      <td>5099.057181</td>
      <td>648.006894</td>
    </tr>
    <tr>
      <th>2</th>
      <td>TB</td>
      <td>TB</td>
      <td>-3.587428</td>
      <td>4.086304</td>
      <td>0.027669</td>
      <td>116.922570</td>
      <td>6958.190392</td>
      <td>651.838335</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Parasitic and vector diseases</td>
      <td>Lymphatic filariasis</td>
      <td>-2.843354</td>
      <td>3.724580</td>
      <td>0.058230</td>
      <td>59.913072</td>
      <td>2482.903110</td>
      <td>652.042895</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Parasitic and vector diseases</td>
      <td>Schistosomiasis</td>
      <td>-3.354314</td>
      <td>3.742827</td>
      <td>0.034933</td>
      <td>38.477140</td>
      <td>1623.940899</td>
      <td>654.124353</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Parasitic and vector diseases</td>
      <td>Onchocerciasis</td>
      <td>-4.002002</td>
      <td>3.718195</td>
      <td>0.018279</td>
      <td>18.365718</td>
      <td>756.260652</td>
      <td>655.728497</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Trachoma</td>
      <td>Trachoma</td>
      <td>-3.984676</td>
      <td>3.693719</td>
      <td>0.018598</td>
      <td>17.066256</td>
      <td>685.749534</td>
      <td>655.754053</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Parasitic and vector diseases</td>
      <td>Dengue</td>
      <td>-5.767322</td>
      <td>3.092770</td>
      <td>0.003128</td>
      <td>0.373548</td>
      <td>8.223787</td>
      <td>659.041049</td>
    </tr>
  </tbody>
</table>
</div>


Again, these numbers follow the patterns of earlier estimates with some research topics substantially outperforming others:


<figure>
	<a href="{{ site.baseurl }}/images/returns/output_25_0.png"><img src="{{ site.baseurl }}/images/returns/output_25_0.png"></a>
</figure>


<figure>
	<a href="{{ site.baseurl }}/images/returns/output_26_0.png"><img src="{{ site.baseurl }}/images/returns/output_26_0.png"></a>
</figure>

<figure>
	<a href="{{ site.baseurl }}/images/returns/output_27_0.png"><img src="{{ site.baseurl }}/images/returns/output_27_0.png"></a>
</figure>


So while there is a strong positive relationship between uncertainty and impact, there is a weaker negative relationship between downside risk and impact.

### Research Citation Counts

Next, I thought it would be interesting to see if these patterns appear in researcher citation counts.  I found a list of ecology researchers along with links to their Google Scholar profiles on [GitHub](https://github.com/weecology/bibliometrics/blob/master/Google_ecology.csv).  I treated this list as a population of researchers (I'm not sure if it really is), then randomly selected 100 non-students and downloaded their list of publications and citation counts.  I then calculated the mean citation count, standard deviation, and downside risk for each researcher.     

The assumption here is that citation count is proportional to real world impact.  Another thing to mention is that these scientists have different funding levels, so we don't know the true funding to citation conversion rate.     

<div>

<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>mean</th>
      <th>std</th>
      <th>downside_risk</th>
    </tr>
    <tr>
      <th>id</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>30</th>
      <td>78.092593</td>
      <td>107.506958</td>
      <td>19.496066</td>
    </tr>
    <tr>
      <th>89</th>
      <td>19.361702</td>
      <td>17.013327</td>
      <td>23.927285</td>
    </tr>
    <tr>
      <th>129</th>
      <td>17.962963</td>
      <td>20.803996</td>
      <td>25.888243</td>
    </tr>
    <tr>
      <th>143</th>
      <td>12.964286</td>
      <td>19.114629</td>
      <td>29.574690</td>
    </tr>
    <tr>
      <th>145</th>
      <td>3.500000</td>
      <td>4.485018</td>
      <td>34.183520</td>
    </tr>
  </tbody>
</table>
</div>


<figure>
	<a href="{{ site.baseurl }}/images/returns/output_32_0.png"><img src="{{ site.baseurl }}/images/returns/output_32_0.png"></a>
</figure>


<figure>
	<a href="{{ site.baseurl }}/images/returns/output_33_0.png"><img src="{{ site.baseurl }}/images/returns/output_33_0.png"></a>
</figure>


<figure>
	<a href="{{ site.baseurl }}/images/returns/output_34_0.png"><img src="{{ site.baseurl }}/images/returns/output_34_0.png"></a>
</figure>


Using the standard deviation in a situation like this doesn't make a lot of sense.  By default, a very successful researcher might have a higher standard deviation in their citations as they progress through their career [10].  I think the downside risk metric is more useful here, and it shows that highly cited researchers outperform the mean researcher more often.

### Uncertainty in Peer Review

An alternate way to look at this question would be to try to relate peer reviewer uncertainty with eventual citation counts.  At least theoretically, it could be rational to fund a study with a lower mean reviewer score if there is sufficient uncertainty [11].  While some research has found a positive relationship between mean reviewer score and eventual citation counts [12], and others have studied the variation in reviewer scores [13], nobody has related the variation in reviewer scores with eventual citation counts.  I contacted the NIH and they don't keep a record of individual reviewer scores for privacy reasons, so this type of study doesn't seem possible currently.  

### Surprise as Risk

Another fascinating study takes a different approach by measuring if the subject matter of the paper is risky/[surprising](https://en.wikipedia.org/wiki/Self-information) [14].  They do this by comparing the chemicals discussed in the paper with an existing network of chemical knowledge.  Studies that propose a new type of connection or a jump to new knowledge are judged to be more risky (Figure 1), and are eventually associated with higher citation counts and more scientific awards (Figure 3).  

<figure>
	<a href="{{ site.baseurl }}/images/returns/network.png"><img src="{{ site.baseurl }}/images/returns/network.png"></a>
</figure>

<figure>
	<a href="{{ site.baseurl }}/images/returns/scatter.png"><img src="{{ site.baseurl }}/images/returns/scatter.png"></a>
</figure>

The effect size in this paper isn't huge -- a research strategy that is an order of magnitude less probable receives 2.26 more citations on average.  But I think this paper gets closer to measuring the concept of scientific risk than anything else.  They also conclude that a scientist trying to maximize citation count would probably focus on repeat projects, so specific policies to encourage higher risk science might be needed.  

## Conclusion

It's interesting to see some common patterns emerge across these different domains and datasets. 

* First, the impact distributions make it clear that some interventions are much better than others.  As a result, it makes sense to spend a lot of time searching for good opportunities.  
* Second, interventions with a high downside risk tend to have lower impacts.  Even though high impact interventions are more uncertain, they dip below the mean less often or to a lesser extent.   
* Third, there do seem to be returns to uncertainty, so a large error bound on a cost effectiveness estimate shouldn't be disqualifying on it's own.  

Whether or not there are returns to risk, then, depends on your definition of risk.  Using the definitions from the introduction, it makes more sense to say there are returns to uncertainty.  In other words, uncertainty is something you might have to learn to live with if you want to have a big effect on the world.  

## References

[1] *What Are Foundations For?* Boston Review.  [http://bostonreview.net/forum/foundations-philanthropy-democracy](http://bostonreview.net/forum/foundations-philanthropy-democracy)

[2] *Hits-based Giving.*  Open Philanthropy Project.  [https://www.openphilanthropy.org/blog/hits-based-giving](https://www.openphilanthropy.org/blog/hits-based-giving)

[3] *Broad market efficiency.*  GiveWell. [https://blog.givewell.org/2013/05/02/broad-market-efficiency/](https://blog.givewell.org/2013/05/02/broad-market-efficiency/)

[4] *The Confusion of Risk vs. Uncertainty.*  The Guesstimate Blog.  [https://medium.com/guesstimate-blog/the-confusion-of-risk-vs-uncertainty-1c6cd512aa69](https://medium.com/guesstimate-blog/the-confusion-of-risk-vs-uncertainty-1c6cd512aa69)

[5] *Benefit-Cost Results.*  Washington State Institute for Public Policy.  [http://www.wsipp.wa.gov/BenefitCost](http://www.wsipp.wa.gov/BenefitCost)

[6] *Disease Control Priorities in Developing Countries (DCP2).*  [http://www.dcp-3.org/dcp2](http://www.dcp-3.org/dcp2)

[7] *GiveWell's Cost-Effectiveness Analyses.*  GiveWell.  [https://www.givewell.org/how-we-work/our-criteria/cost-effectiveness/cost-effectiveness-models](https://www.givewell.org/how-we-work/our-criteria/cost-effectiveness/cost-effectiveness-models)

[8] *Stochastic Altruism.* [https://danwahl.github.io/stochastic-altruism](https://danwahl.github.io/stochastic-altruism)

[9] *Uncertainty Quantification.*  Wikipedia.  [https://en.wikipedia.org/wiki/Uncertainty_quantification#Sources_of_uncertainty](https://en.wikipedia.org/wiki/Uncertainty_quantification#Sources_of_uncertainty)

[10] *Quantifying the evolution of individual scientific impact.*  [http://science.sciencemag.org/content/354/6312/aaf5239](http://science.sciencemag.org/content/354/6312/aaf5239)

[11] *Improving the Peer review process: Capturing more information and enabling high-risk/high-return research.* [https://www.sciencedirect.com/science/article/pii/S0048733316301111](https://www.sciencedirect.com/science/article/pii/S0048733316301111)

[12] *Big names or big ideas: Do peer-review panels select the best science proposals?*  [http://science.sciencemag.org/content/348/6233/434](http://science.sciencemag.org/content/348/6233/434)

[13] *Peer Review Evaluation Process of Marie Curie Actions under EU’s Seventh Framework Programme for Research.* [https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4488366/](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4488366/)

[14] *Tradition and Innovation in Scientists’ Research Strategies.* [http://journals.sagepub.com/doi/abs/10.1177/0003122415601618](http://journals.sagepub.com/doi/abs/10.1177/0003122415601618)

