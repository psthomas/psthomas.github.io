---
layout: post
title: "My Mental Model of the World"
excerpt: "A model and d3.js visualization to communicate my thoughts about how the world works."
#modified: 2016-02-22
tags: [JavaScript, d3.js, statistics, model, economics]
comments: true
share: false

---


Models are useful because they force us to be explicit about how we view the world and open those views up for criticism.  I decided to create an interactive visualization to communicate my ideas about the world, which is included below.  Although it's not meant to be mathematically perfect, I think it captures what I see as the important features and interactions between markets, government and research.  People are too often overconfident in their explicit or implicit models of the world, so feel free to critique or [contribute](https://github.com/psthomas/mental-model). 


<!--https://stackoverflow.com/questions/5867985-->
<div class="outer">
<div class="inner">
<iframe id="vis"
    style="width: 98vw; height: 100vh; border: none; position: relative; right:-50%; scrolling:no;"></iframe>
</div>
</div> 

<!--<script src="https://d3js.org/d3-request.v1.min.js"></script>-->
<script src="https://d3js.org/d3.v4.js"></script>

<script>

d3.request("https://raw.githubusercontent.com/psthomas/mental-model/master/model.html")
    .get(function(a) {
        document.getElementById("vis").srcdoc = a.response;
    });


</script>


## How It Works

There are three sectors in this model: markets, government, and research.  Research is technically a subset of government, but it behaves sufficiently different to warrant it's own category.  Each circle represents a project that needs funding.  In the market each circle could represent a new product for a company to pursue, in government it could represent a new policy initiative, and in research it could represent the ongoing research in a lab.  

The radius of the circle is proportional to the room for more project funding -- when the project has been fully funded the radius and marginal impact of additional funding drop to zero.  The x-axis represents the variation in project outcome and the y-axis represents the [marginal](https://en.wikipedia.org/wiki/Marginal_value) social impact of the project using units of something like wellbeing per dollar spent.  

There can be large differences in the impacts of different projects so I generate the data using a [joint](https://en.wikipedia.org/wiki/Joint_probability_distribution) [lognormal](https://en.wikipedia.org/wiki/Log-normal_distribution) probability distribution with a correlation between the risk and impact.  The specifics of how the joint distributions are generated is in the appendix below if you're interested.  I leave numbers and units off the axes because I don't think there's a single measure of wellbeing and the relationship between the sectors matters more than the numerical values.      

The user can set the percentage of the budget devoted to each sector and the allocation of each sector's money between exploitation (funding existing projects), and exploration (searching for new projects).  When the user clicks the "Next" button, the exploit budget is allocated to each circle by finding the maximum percentage that can be multiplied times the funding needs in each sector while staying below the budget.  This means that society funds every project by some amount because it doesn't always know the real marginal impact of each project.  

Here's the section of the code that finds the percentage funding level: 

{% highlight javascript %}

var sum = 0.0,
    pct = 0.0;

while (sum <= exploit_budget) {
    sum = 0.0;
    pct += 0.001;
    for (var j = 0; j < sector.length; j++) {
    	sum += pct * sector[j].size;
    }
}

{% endhighlight %}

As the research projects are funded, the variation associated with each project declines and the bubbles diffuse through the market.  Once a research project has a low enough variation, there's a ten percent chance that it will transition to the market's budget each year.  This aspect of the model isn't perfect, as the transition to markets should be governed by risk with respect to market returns, not risk with respect to social impact.  But if the two are at least correlated I think it's an okay assumption. 

For exploratory funding, new circles are generated from [lognormal distributions](https://en.wikipedia.org/wiki/Log-normal_distribution) with unique mus and sigmas for each of the sectors.  This model is somewhat informed by the concept of an [efficient frontier](https://en.wikipedia.org/wiki/Modern_portfolio_theory#Efficient_frontier_with_no_risk-free_asset) from modern portfolio theory.  Generally, I think there's a positive relationship between risk taking and societal impact, although greater potential for societal harm comes at high levels of risk as well.  

Because markets are driven by a profit motive and have a shorter time horizon, their risk profile and corresponding social impact are lower (smaller mus and sigmas).  Governments and basic research can play at higher levels of risk, so they're rewarded accordingly with higher marginal social impacts (higher mus and sigmas).  Research has more projects in areas of moderately high social impact than government (higher mu), but government has a heavier tail at the very high levels of impact (higher sigma).  The heavier tail for Government is driven by situations like nuclear crises where decisions have the potential to dwarf all the other areas in impact.    

Finally, three percent of the money allocated to markets is added to the budget each year.  This is meant to simulate the importance of economic growth, and penalizes putting too much money into research or government.  The growth rate and money allocated to markets are some of the most important factors in the long term performance of the model.  

Here are a few things I hope this visualization demonstrates:

## Diminishing Returns

The marginal impact of each project declines linearly as it's room for funding is used up.  This is a pretty fundamental [concept in economics](https://en.wikipedia.org/wiki/Diminishing_returns) and I think it applies to most situations in the real world.  One aspect of the model that avoids diminishing returns is the exploration phase, as the probability of generating a bubble in each location remains constant over time for each sector.   This fits well with my intuition about the world -- there are diminishing returns to exploiting existing knowledge but not to generating new knowledge.

## Importance of Economic Growth

I think the [income](https://en.wikipedia.org/wiki/Gross_domestic_product#Income_approach) approach to measuring GDP is most helpful for thinking about economic growth in this model.  A certain amount of income is generated in each time step, most of which goes to corporations and individuals.  We as a society then decide what to do with this money in the next time step.  We can leave it with individuals and corporations which ends up largely being invested in markets, or we can tax it and put it into government services or basic research. 

All money left in markets grows at three percent each year to match historical real GDP growth.  This is a simplification for a few reasons.  First, government and research spending are also part of the GDP.  Second, government spending can have a [multiplier effect](https://en.wikipedia.org/wiki/Fiscal_multiplier) especially during recessions and technological progress is thought to be one of the [main drivers](http://science.sciencemag.org/content/342/6160/817) of long-run growth in at least the [Solow model](https://en.wikipedia.org/wiki/Solow%E2%80%93Swan_model).  But I needed to demonstrate that there would be a penalty over time if the user taxed their whole economy to put the money into research, so this is my solution.   

One of the best approaches to getting a high Impact/Year over the long term is to put 80-90% of the budget in the Market and let it grow.  I suspect the percent of money allocated to markets and the long term growth rate of three percent would be the most important parameters if I ported this over to Python and ran some simulations.  This model behavior fits well with the real world data.  For example, GDP per capita [correlates strongly](https://ourworldindata.org/happiness-and-life-satisfaction/#correlates-determinants-and-consequences) with life satisfaction over time and across countries.

## Social Impact is the Goal

I use social impact as the measure of progress rather than GDP.  I think the distinction between the two is important because if we used GDP, the immediate impacts of government or research would drop substantially (even if they have large indirect effects).  It's only through the lens of wellbeing that many of the actions of government or research make sense.  

## The Roles of Different Sectors

Markets, government, and research all play different roles in the model.  Markets largely work at lower levels of risk, and, although the projects here have lower marginal impacts, the number of opportunities here outnumber those in other sectors.  I estimate lower marginal impacts here because the alternative for a consumer in a competitive marketplace is usually a similar product with a slightly higher price if a company doesn't offer a product.  The rarer case where a single company makes a decision that has a large social impact (because it's truly innovative or has monopoly power) is located in the tail of the distribution.    

Research, on the other hand, is able to accept higher variability for higher social returns.  Researchers are often criticized by the public for working on esoteric projects without clear applications, but occasionally something like [CRISPR-Cas9](http://science.sciencemag.org/content/346/6213/1258096.full) is discovered that has a revolutionary effect.  Both the exploration and exploitation phases of research need to be funded for research to work well -- if no exploitation is funded the highest impact findings never translate into markets.  But if you don't do enough exploration the pipeline of new ideas dries up, which prevents you from taking advantage of the full potential of research.    

The bulk of Government projects exist in a middle ground between markets and research.  This is because governments are often directly addressing problems in areas of market failures like the insurance market for low income individuals.  The marginal impact is fairly large in a situation like this because the counterfactual for an individual with no insurance is probably a delay in treatment until an emergency room visit.  

Occasionally governments need to make a decisions during crises where catastrophic outcomes are possible.  To get a feel for this, consider simulating one of our many nuclear close calls [[3](https://en.wikipedia.org/wiki/List_of_nuclear_close_calls#1950s), [4](http://www.ucsusa.org/sites/default/files/attach/2015/04/Close%20Calls%20with%20Nuclear%20Weapons.pdf)] over and over again with small changes in the initial conditions.  Realistic outcomes for this experiment would probably range from completely avoiding conflict to the destruction of our civilization.  Government impact in situations like these is mainly driven by [path dependence](https://en.wikipedia.org/wiki/Path_dependence) -- the actions can't be undone or modified.  

Research, on the other hand, largely functions by shifting the future into the present more rapidly, so the main benefit is applied during the time before the discovery would have occurred otherwise [[5](http://www.fhi.ox.ac.uk/research-into-neglected-diseases/)]. (Note: this isn't always the case because research can have a time dependent application.  For example, advances in battery technology for storing renewable energy might prevent a path dependent change in our climate right now.)    

## Possible Negative effects

Not every exploration results in a project with an positive expected marginal impact.  For a random 10% of the projects I multiply the impact by -0.5, resulting in a bimodal distribution.  Nevertheless, the project is funded at the same level as other projects because society isn't always very good at discerning impact.  In this model, larger potential negative effects come with higher levels of risk.  For example, some areas of research or government actions have the potential to be catastrophic if we're not careful.  These [catastrophic risks](https://en.wikipedia.org/wiki/Global_catastrophic_risk) would dwarf the rest of these projects in negative or positive impact, which is part of the reason I don't include numerical axes as it's difficult to legibly show the impacts on the same scale. 

## The Role of Philanthropy

Philanthropists could act in this model in a few ways.  First, they could try too choose a existing project with a high marginal impact and fund it until it's marginal impact is lower than a different project, then switch to a new one.  Second, they could fund the exploration phase of research to try to create an opportunity that is better than the existing options.  Finally, they could try to change the model parameters by influencing the political process or funding research about the optimal model settings.  

Philanthropists tend to take many different approaches in society, but I think taking big risks to create new ideas or trying to influence policy for the better are among the best opportunities [[6](http://bostonreview.net/forum/foundations-philanthropy-democracy), [7](http://www.openphilanthropy.org/blog/hits-based-giving), [8](https://ssir.org/articles/entry/the_elusive_craft_of_evaluating_advocacy)].  


## Model Problems

There are a number of problems with this model.  In addition to the ones I mentioned above, here are a few more:

* **Causation isn't so clear cut**.  For example, good economic policy might lead to better functioning markets, which might free up more money for research, which might result in research that improves economic policy.  This seems to operate more like a mutually beneficial relationship where you can't neatly divide things up by causation.  
* **Can wellbeing be summed?** There are a few [philosophical objections](https://en.wikipedia.org/wiki/Utilitarianism#Aggregating_utility) to summing wellbeing.  Also, some make the point that measuring total wellbeing doesn't account for the distribution of that wellbeing, which is a valid point.    
* **Can money buy everything?**  In the case of a well functioning government, funding might not be the limiting factor on competence.  No amount of project funding will suddenly improve decision making skills in a crisis.  Government competence is something that needs to be built over [decades and centuries](https://www.cgdev.org/publication/capability-traps-mechanisms-persistent-implementation-failure-working-paper-234), and probably depends on something other than funding levels.   
* **Different distributions?** It's possible that the lognormal distribution isn't the best fit for opportunities to do good in the world.  Maybe a power-law distribution would fit better, or maybe I need to change the existing lognormal parameters.  Right now they're tuned for visual communication, not accuracy.  

## Conclusion

I hope you find this model interesting.  It's a first draft, so feel free to critique or [contribute](https://github.com/psthomas/mental-model).  In the future I might create a version that allows people to choose the probability distributions parameters to fit with their intuitions about the world, so stay tuned.  

## Appendix

Generating samples from a correlated, [joint](https://en.wikipedia.org/wiki/Joint_probability_distribution) lognormal distribution ended up being much more difficult than I thought it would be.  There are a number of resources out there and packages for languages like Python and R, but nothing for JavaScript.  I ended up using [jStat](https://github.com/jstat/jstat) for many of it's distributions and helper functions, along with this [Stackoverflow answer](https://stackoverflow.com/questions/32718752/how-to-generate-correlated-uniform0-1-variables).  

Here are the steps:

1. Create uncorrelated samples drawing from a standard normal distribution (mu=0, sigma=1). 
2. Create a [correlation matrix](https://en.wikipedia.org/wiki/Correlation_and_dependence#Correlation_matrices) with the desired correlation between the samples. 
3. Matrix multiply the [cholesky decomposition](https://en.wikipedia.org/wiki/Cholesky_decomposition) of the correlation matrix with the uncorrelated samples to create correlated normal samples. 
4. Convert the correlated normal samples to correlated uniform samples using the standard normal cumulative distribution function (CDF).  I think the result of this is considered a [copula](https://en.wikipedia.org/wiki/Copula_(probability_theory)).  
5. Use the inverted CDF of the desired lognormal distribution to convert the correlated uniform samples into correlated lognormal samples.  This is called [inverse transform](https://en.wikipedia.org/wiki/Inverse_transform_sampling) sampling.   

Note that the lognormal correlation won't be exactly what you specified in the correlation matrix, but it was close enough for my purposes.  Here's the code:

{% highlight javascript %}

//script src="https://cdn.jsdelivr.net/npm/jstat@latest/dist/jstat.min.js" /script

function generateCopula(rows, columns, correlation) {
    //https://en.wikipedia.org/wiki/Copula_(probability_theory)

    //Create uncorrelated standard normal samples
    var normSamples = jStat.randn(rows, columns);

    //Create lower triangular cholesky decomposition of correlation matrix
    var A = jStat(jStat.cholesky(correlation));

    //Create correlated samples through matrix multiplication
    var normCorrSamples = A.multiply(normSamples);

    //Convert to uniform correlated samples over 0,1 using normal CDF
    var normDist = jStat.normal(0,1);
    var uniformCorrSamples = normCorrSamples.map(function(x) {return normDist.cdf(x);});

    return uniformCorrSamples;

}

function generateCorrLognorm(number, mu, sigma, correlation) {

    //Create uniform correlated copula
    var copula = generateCopula(mu.length, number, correlation);

    //Create unique lognormal distribution for each marginal
    var lognormDists = [];
    for (var i = 0; i < mu.length; i++) {
        lognormDists.push(jStat.lognormal(mu[i], sigma[i]));
    }

    //Generate correlated lognormal samples using the inverse transform method:
    //https://en.wikipedia.org/wiki/Inverse_transform_sampling
    var lognormCorrSamples = copula.map(function(x, row, col) {return lognormDists[row].inv(x);});
    return lognormCorrSamples;
}

var mu = [0,0],
	sigma = [0.25, 0.5],
	correlation = [[1.0, 0.5],[0.5, 1.0]];

var data  = generateCorrLognorm(100, mu, sigma, correlation);


{% endhighlight %}


A nice feature of this approach is that you can use any combination of distributions and create any number of correlated samples.  All you need is to do is create the desired correlation matrix, define the distributions with jStat, and then use their inverted CDFs to convert the copula.   

## References

[1] What's So Special About Science (And How Much Should We Spend on It?). Science. [http://science.sciencemag.org/content/342/6160/817](http://science.sciencemag.org/content/342/6160/817)

[2] Happiness and Life Satisfaction. Our World in Data. [https://ourworldindata.org/happiness-and-life-satisfaction/#correlates-determinants-and-consequences](https://ourworldindata.org/happiness-and-life-satisfaction/#correlates-determinants-and-consequences)

[3] List of nuclear close calls. Wikipedia. [https://en.wikipedia.org/wiki/List_of_nuclear_close_calls#1950s](https://en.wikipedia.org/wiki/List_of_nuclear_close_calls#1950s)

[4] Close Calls with Nuclear Weapons. Union of Concerned Scientists. [http://www.ucsusa.org/sites/default/files/attach/2015/04/Close%20Calls%20with%20Nuclear%20Weapons.pdf](http://www.ucsusa.org/sites/default/files/attach/2015/04/Close%20Calls%20with%20Nuclear%20Weapons.pdf)

[5] Estimating the cost-effectiveness of research into neglected diseases. Future of Humanity Institute. [http://www.fhi.ox.ac.uk/research-into-neglected-diseases/](http://www.fhi.ox.ac.uk/research-into-neglected-diseases/)

[6]  What Are Foundations For? Boston Review. [http://bostonreview.net/forum/foundations-philanthropy-democracy](http://bostonreview.net/forum/foundations-philanthropy-democracy) 

[7] Hits-based Giving. Open Philanthropy Project. [http://www.openphilanthropy.org/blog/hits-based-giving](http://www.openphilanthropy.org/blog/hits-based-giving)

[8] The Elusive Craft of Evaluating Advocacy.  Stanford Social Innovation Review.  [https://ssir.org/articles/entry/the_elusive_craft_of_evaluating_advocacy](https://ssir.org/articles/entry/the_elusive_craft_of_evaluating_advocacy)

[9] Capability Traps? The Mechanisms of Persistent Implementation Failure. Center for Global Development. [https://www.cgdev.org/publication/capability-traps-mechanisms-persistent-implementation-failure-working-paper-234](https://www.cgdev.org/publication/capability-traps-mechanisms-persistent-implementation-failure-working-paper-234)