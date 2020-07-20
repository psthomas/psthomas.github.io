---
layout: post
title: "What's the probability a person has Covid-19?"
excerpt: "I use a model of estimated infections to calculate infection probabilities."
tags: [Python, Pandas, Altair, Covid-19, Coronavirus, modeling]
comments: true
share: false
---

At first I thought this would be fairly simple question to answer. Just sum up the new cases over the past few weeks and divide by the total population of each region, right? This is the approach that I took in my [previous post](https://pstblog.com/2020/06/10/covid-vis), but this probability is actually much more difficult to estimate for a few reasons outlined in [this paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7073841/):
1. There's a 10 day lag between an infection and a reported case and a 20 day lag between an infection and death on average. This means the counts we see today reflect the past. The effect of this lag on the numbers depends on the growth rate of the pandemic at the time.
2. Roughly 35-40% of cases are [asymptomatic](https://www.cdc.gov/coronavirus/2019-ncov/hcp/planning-scenarios.html). These cases will never show up in the numbers unless we do random testing.
3. Even among symptomatic people, a large fraction (right now [estimated](https://cmmid.github.io/topics/covid19/global_cfr_estimates.html) at 65% for the US) will never have a positive test. Perhaps they don't seek one out, one isn't available, or they have a [false negative](https://www.acpjournals.org/doi/10.7326/M20-1495) result.
4. The availability of testing [influences](https://fivethirtyeight.com/features/coronavirus-case-counts-are-meaningless/) many of the numbers above.

The end result is that it's probably more accurate to estimate the true number of infections using a [SEIR model](https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology#The_SEIR_model) that matches the reported deaths, rather than back-calculating infections from reported cases. This is what the [model](https://covid19-projections.com/about/) I ended up choosing does; see the appendix below for more information. 

So after that lengthy introduction, here's the probability that a person is infected by country:

<div class="outer" style="padding-left:25px">
<div class="inner">
<iframe id="vis1" src="{{ site.baseurl }}/vis/covid-world-model.html"
style="width: 1020px; height: 650px; border: none; position: relative; right:-50%; scrolling:no;"></iframe>
</div>
</div>

Here are the results by state in the US:

<div class="outer" style="padding-left:25px">
<div class="inner">
<iframe id="vis2" src="{{ site.baseurl }}/vis/covid-us-model.html"
style="width: 1000px; height: 650px; border: none; position: relative; right:-50%; scrolling:no;"></iframe>
</div>
</div>
<!-- <iframe id="vis3" src="{{ site.baseurl }}/vis/covid-us-model.html" style="width: 900px; height:600px; border:none;"></iframe> -->
<!-- <div id="vis3" style="width: 100%; height:600px;"> </div> -->

This model also has results for some counties that contain major urban areas, so here's the probability of infection by US county:

<div class="outer" style="padding-left:25px">
<div class="inner">
<iframe id="vis3" src="{{ site.baseurl }}/vis/covid-county-model.html"
style="width: 1000px; height: 650px; border: none; position: relative; right:-50%; scrolling:no;"></iframe>
</div>
</div>
<!-- <iframe id="vis4" src="{{ site.baseurl }}/vis/covid-county-model.html" style="width: 100%; height:600px; border:none;"></iframe> -->
<!-- <div id="vis4" style="width: 100%; height:600px;"> </div> -->

Note that although the peak for New York state above is a little over 5%, the peak for the five boroughs of New York City is over 10%.  This means that if you attended a meeting with 10 random people at the peak of the outbreak, there was a 65% chance someone attending was infected ([`1-(1-p)^n`](https://blogs.scientificamerican.com/observations/online-covid-19-dashboard-calculates-how-risky-reopenings-and-gatherings-can-be/)`= 1-(1-0.1)^10 = 0.65`). One thing to add is that the probability someone is *infected* isn't neccessarily equal to the probability they're *infectious* -- there may be a smaller window of time that someone can actually spread the infection but that's still uncertain for now.

Sometimes a table is the best way to visualize data, so here's a searchable table with data sorted by probability:

<!-- <div id="covidtable" style="margin:30px auto;height: 600px; max-width:775px; overflow: auto;"></div> -->
<!-- <div class="outer" style="padding: 0px 15px">
<div class="inner"> -->
<iframe id="vis3" src="{{ site.baseurl }}/vis/covid-probtable.html" style="width: 100%; height:600px; border:none;"></iframe> 
<!-- </div>
</div> -->

The idea here is that people can use these probabilies to estimate the risk of their lifestyle given their location. So if there's a 1% chance that someone is infected in your region, attending a meeting with 10 individuals means there's a 9.5% chance of getting exposed to a person with Covid-19 (`1-(1-0.01)^10 = 0.095`). Of course, this approach could backfire. Here are some potential problems:

* This approach requires some math, but creating a risk calculator similar to [this one](https://covid19risk.biosci.gatech.edu/) could help.
* People could just be really bad at estimating how many people they interact with.   
* The [spread via aerosols](https://twitter.com/firefoxx66/status/1260905937910587392) or surfaces could make estimating the number of interactions impossible.  
* County level data isn't available for every urban area, so people may underestimate their risk by using statewide risk estimates.

But I think this visualization provides people with more actionable information than others I've seen, so I decided to put it out there. I'll try to update it as often as possible when new data is available. If you want to embed these visualizations elsewhere, please let me know because I could host them on Amazon S3 or something. All the code for this post is available on GitHub [here](https://github.com/psthomas/covid-vis).

## Appendix: Model Selection

There a a number of models that try to predict the course of the pandemic, most of which are compiled on the Reich Lab [forecasting hub](https://reichlab.io/covid19-forecast-hub/) and [FiveThirtyEight](https://projects.fivethirtyeight.com/covid-forecasts/). But the only ones that include an estimate of the true number of infections over time are the models created by [IHME](https://covid19.healthdata.org/united-states-of-america), [Columbia](https://cuepi.shinyapps.io/COVID-19/), [Imperial College](https://mrc-ide.github.io/covid19usa/#/), and [Youyang Gu](https://covid19-projections.com/). 

First, I looked at IHME's model, but immediately something seemed off. Here's the predicted cases for Wisconsin during a time when cases were increasing:

<figure style="text-align:center">
    <a href="{{site.baseurl}}/images/covidvis/ihme-model.png"><img src="{{site.baseurl}}/images/covidvis/ihme-model.png"></a>
</figure>

Predicted infections are actually lower than measured infections, something that would only happen due to testing lag when cases were declining significantly. This could be because their initial model [fit a Gaussian curve](https://twitter.com/CT_Bergstrom/status/1250304081265963010) to the data, which forced a symmetric increase and decline around a peak. While I don't think this is their approach anymore, everything still seemed to be asymptoting towards zero when I reviewed it, so that doesn't inspire much confidence. 

The Columbia and Imperial models do a better job, but they're not updated as frequently as I'd like. Youyang Gu's model is updated daily, performs really well in predictions, and has [good reviews](https://twitter.com/CT_Bergstrom/status/1255343846445195266) from subject matter experts, so I decided to use it. But I still wanted to do a few checks to validate it. First, I compared it to Imperial College's model:

<figure style="text-align:center">
    <a href="{{site.baseurl}}/images/covidvis/concordance.png"><img src="{{site.baseurl}}/images/covidvis/concordance.png"></a>
</figure>

If they agreed perfectly, their estimates would sit on a 45 degree line. So there's some deviation, especially in the high case counts. One way to quantify this deviation is using a [concordance correlation coefficient](https://en.wikipedia.org/wiki/Concordance_correlation_coefficient), which ends up being `0.917`. Perfect concordance would give a value of `1.0`, so this is pretty good.

Next, I compared it against recent serology tests in Spain, which [suggests 5%](https://www.vox.com/2020/5/16/21259492/covid-antibodies-spain-serology-study-coronavirus-immunity) of the population has been infected so far. If we just sum up the reported case counts as of 5/13/2020 and divide by the Spanish population, it gives an estimated percent infected of `0.5%`, which is a 10x undercount. But if we sum up the predicted infections from Youyang's model and divide by the population, we get an estimated `6.7%` of the population infected. So this is at least at the right order of magnitude, and could be correct depending on when the serology study actually ended. 

New York state also completed a [serology study](https://twitter.com/NYGovCuomo/status/1253352837255438338) on April 23rd that estimated a New York City infection rate of `21.2%` and a statewide rate of `13.9%`. The model predictions of `20.9%` in the city and `12.5%` statewide as of 4/23/2020 are quite close. So overall this seems like a quality model and I'll probably continue using it. 

**Update:** After observing these probabilities for the past few weeks, one thing I've noticed is that even these tend to lag during a new outbreak. I think this is because the model does a grid search and finds the optimal model paramaters that minimize the error on the deaths timeseries. But if these parameters are optimized to match the death timeseries from a month ago, running the model forward to today will still underestimate the cases during an exponential growth phase because it's using old parameters. I'm not sure how to fix this, but what's really needed is a robust way to estimate actual cases using the current cases timeseries. Please let me know if you're aware of an epidemiologist that's actually doing this!

## References

[1] COVID-19 Projections Using Machine Learning. [https://covid19-projections.com/about/](https://covid19-projections.com/about/)

[2] Communicating the Risk of Death from Novel Coronavirus Disease (COVID-19). [https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7073841/](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7073841/)

[3] COVID-19 Pandemic Planning Scenarios. [https://www.cdc.gov/coronavirus/2019-ncov/hcp/planning-scenarios.html](https://www.cdc.gov/coronavirus/2019-ncov/hcp/planning-scenarios.html)

[4] Variation in False-Negative Rate of Reverse Transcriptase Polymerase Chain Reaction–Based SARS-CoV-2 Tests by Time Since Exposure. [https://www.acpjournals.org/doi/10.7326/M20-1495](https://www.acpjournals.org/doi/10.7326/M20-1495)

[5] Using a delay-adjusted case fatality ratio to estimate under-reporting. [https://cmmid.github.io/topics/covid19/global_cfr_estimates.html](https://cmmid.github.io/topics/covid19/global_cfr_estimates.html)

[6] Inferring cases from recent deaths. [https://cmmid.github.io/topics/covid19/cases-from-deaths.html](https://cmmid.github.io/topics/covid19/cases-from-deaths.html)

[7] Coronavirus Case Counts Are Meaningless. [https://fivethirtyeight.com/features/coronavirus-case-counts-are-meaningless/](https://fivethirtyeight.com/features/coronavirus-case-counts-are-meaningless/)

[8] Reich Lab COVID-19 Forecast Hub. [https://reichlab.io/covid19-forecast-hub/](https://reichlab.io/covid19-forecast-hub/)

[9] Where The Latest COVID-19 Models Think We're Headed — And Why They Disagree. [https://projects.fivethirtyeight.com/covid-forecasts/](https://projects.fivethirtyeight.com/covid-forecasts/)

[10] The results of a Spanish study on Covid-19 immunity have a scary takeaway. [https://www.vox.com/2020/5/16/21259492/covid-antibodies-spain-serology-study-coronavirus-immunity](https://www.vox.com/2020/5/16/21259492/covid-antibodies-spain-serology-study-coronavirus-immunity)

[11] Online COVID-19 Dashboard Calculates How Risky Reopenings and Gatherings Can Be. [https://blogs.scientificamerican.com/observations/online-covid-19-dashboard-calculates-how-risky-reopenings-and-gatherings-can-be/](https://blogs.scientificamerican.com/observations/online-covid-19-dashboard-calculates-how-risky-reopenings-and-gatherings-can-be/)

[12] COVID-19 Event Risk Assessment Planning tool. [https://covid19risk.biosci.gatech.edu/](https://covid19risk.biosci.gatech.edu/)


