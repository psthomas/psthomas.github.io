---
layout: post
title: "Economic Convergence and the Great Recession"
excerpt: "Looking at the cross country growth convergence data in light of the great recession."
#modified:
tags: [Python, Jupyter notebook, economics, development, Pandas, altair]
comments: true
share: false

---

The absence of [catch-up growth](https://en.wikipedia.org/wiki/Convergence_(economics)) in low income countries is a persistent puzzle in the field of development economics.  At least according to [basic theory](https://en.wikipedia.org/wiki/Solow%E2%80%93Swan_model), low income countries should grow more quickly because they have better opportunities to put capital to use. There are a number of reasons the world diverges from basic theory (e.g. bad institutions, poor provision of public goods, frictions in R&D and technology transfer, or low human capital investments), but I recently came across a [blogpost](https://www.cgdev.org/blog/everything-you-know-about-cross-country-convergence-now-wrong) that suggests that this isn't really a puzzle anymore.  Low and middle income economies do seem to be growing more quickly relative to the advanced economies:

<figure style="text-align:center">
	<a href="{{ site.baseurl }}/images/convergence/patel-sandefur-subramanian-beta_by_series-NEW.png"><img src="{{ site.baseurl }}/images/convergence/patel-sandefur-subramanian-beta_by_series-NEW.png"></a>
</figure>

Each point in the graphic above represents the slope of the regression between the GDP in the x-axis year and the subsequent growth rate for each country.  So a positive beta means that the initially rich countries grew more quickly while a negative beta means poorer countries grew more quickly over the following time period.  For the sake of clarity, the following graphic shows what the betas represent, which is the slope of the regression line through the dataset: 

<figure>
	<a href="{{ site.baseurl }}/images/convergence/output_23_3.png"><img src="{{ site.baseurl }}/images/convergence/output_23_3.png"></a>
</figure>

So the slopes become negative, then level out again over the 1970-2010 time period. All the code and data for this post are available on GitHub [here](https://github.com/economic-convergence/).

## The Great Recession

One question I had when looking at the original graphic is how the great recession influenced these results.  First, I re-created their code in Python and made the original beta plot:

<figure>
	<a href="{{ site.baseurl }}/images/convergence/output_14_3.png"><img src="{{ site.baseurl }}/images/convergence/output_14_3.png"></a>
</figure>

Note that this looks a little different because I extended the axis through the end of the data.  I'm not sure why the authors ended the axis at 2000 -- perhaps the betas aren't reliable beyond that point?  Next, I created a plot that excludes the post 2006 data:   

<figure>
	<a href="{{ site.baseurl }}/images/convergence/output_19_3.png"><img src="{{ site.baseurl }}/images/convergence/output_19_3.png"></a>
</figure>

So a similar pattern is present, but the betas aren't convincingly negative anymore.  One might argue that excluding post 2006 is unfair because it leaves out years of high growth for low and medium income countries.  One might also argue that the recession and subsequent lower growth years are due to structural features of our economy so they can't be fixed through a policy response.  I find this argument implausible for a few reasons discussed more [here](https://www.nytimes.com/2018/09/30/opinion/the-economic-future-isnt-what-it-used-to-be-wonkish.html) and [here](https://voxeu.org/article/europes-fiscal-policy-doom-loop).  Mainly, I find it implausible that structural factors would manifest themselves immediately during a financial crisis rather than steadily over time.  

For example, here are the projected vs. actual GDP numbers for the US and EU for the past few years: 

<figure>
	<a href="{{ site.baseurl }}/images/convergence/usprojections.png"><img src="{{ site.baseurl }}/images/convergence/usprojections.png"></a>
</figure>

<figure>
	<a href="{{ site.baseurl }}/images/convergence/euprojections.png"><img src="{{ site.baseurl }}/images/convergence/euprojections.png"></a>
</figure>

So the financial crisis seems to have had an immediate and lasting effect.  Note that we keep underperforming the projections even after the effects of the recession have been taken into account.  Many economists seem to think that the post recession stimulus was [net beneficial](http://www.igmchicago.org/surveys/economic-stimulus-revisited), and that more stimulus could have been done.  So the GDP performance and beta plots above could look significantly different if we had a better policy response to the great recession.  

If you want to make the deeper point that, for political reasons, western countries don't seem capable of enacting competent policy responses anymore, you're probably right.  And excusing political dysfunction in advanced economies while treating it as a natural part of low income economies doesn't quite seem fair.  

## Recession or Acceleration?

A negative beta could be driven by a few things:

1. Slower growth in rich countries.  
2. Higher growth in poor countries.    
3. A combination of both.  

So what's the main driver?  Below, I bin the earlier scatterplot by initial GDP to show that #3 (a combination of both) seems to be the answer, although the main driver seems to be higher growth in low and middle income countries. 

<figure>
	<a href="{{ site.baseurl }}/images/convergence/output_24_3.png"><img src="{{ site.baseurl }}/images/convergence/output_24_3.png"></a>
</figure>

I actually think this plot is more informative than the beta plot above because I'm more interested in absolute rather than relative levels of growth.  This is because the largest marginal improvements to health and wellbeing probably come at early stages of growth due to improvements in things like infrastructure and public health systems.  So it's great that low and medium income countries are growing more quickly!

## Some closing thoughts

Finally, I thought it would be interesting to just include a plot of per capita GDP over time for a few key countries:

<figure>
	<a href="{{ site.baseurl }}/images/convergence/output_10_3.png"><img src="{{ site.baseurl }}/images/convergence/output_10_3.png"></a>
</figure>

This plot highlights the large differences between economies and the gap lower income countries need to make up.  Dietrich Vollrath made this point in a really informative [post](https://growthecon.com/blog/Convergence/) where he estimated it could take close to 190 years for economies to converge at the beta rates estimated above.  That's a long time to sustain the current levels of growth.  

There are reasons to be concerned that a few economies, especially in Sub-Saharan Africa, will have a tough time maintaining growth.  Dani Rodrik and others have made this point in their work on [premature deindustrialization](https://rodrik.typepad.com/dani_rodriks_weblog/2015/02/premature-deindustrialization-in-the-developing-world.html), which suggests a traditional development model via structural transformation might not be possible anymore.  So these countries probably need to [invent new ways](https://www.youtube.com/watch?v=xsAjHzAGZDU) of growing their economies that aren't so dependent on manufacturing.  But again, absolute levels of growth are probably more important than relative ones, so the recent progress lower income countries have made is really encouraging.      

## References

[1] Convergence (economics). Wikipedia. [https://en.wikipedia.org/wiki/Convergence_(economics)](https://en.wikipedia.org/wiki/Convergence_(economics))

[2] Solow-Swan Model. Wikipedia. [https://en.wikipedia.org/wiki/Solow%E2%80%93Swan_model](https://en.wikipedia.org/wiki/Solow%E2%80%93Swan_model)

[3] Everything You Know about Cross-Country Convergence Is (Now) Wrong.  Dev Patel, Justin Sandefur and Arvind Subramanian. [https://www.cgdev.org/blog/everything-you-know-about-cross-country-convergence-now-wrong](https://www.cgdev.org/blog/everything-you-know-about-cross-country-convergence-now-wrong)

[4] The Economic Future Isn’t What It Used to Be. Paul Krugman. [https://www.nytimes.com/2018/09/30/opinion/the-economic-future-isnt-what-it-used-to-be-wonkish.html](https://www.nytimes.com/2018/09/30/opinion/the-economic-future-isnt-what-it-used-to-be-wonkish.html)

[5] Real-Time Estimates of Potential GDP: Should the Fed Really Be Hitting the Brakes?  [https://www.cbpp.org/research/full-employment/real-time-estimates-of-potential-gdp-should-the-fed-really-be-hitting-the](https://www.cbpp.org/research/full-employment/real-time-estimates-of-potential-gdp-should-the-fed-really-be-hitting-the)

[6] Self-fulfilling pessimism: The fiscal policy doom loop. Antonio Fatás.  [https://voxeu.org/article/europes-fiscal-policy-doom-loop](https://voxeu.org/article/europes-fiscal-policy-doom-loop)

[7] Economic Stimulus Revisited. IGM Economic Experts Panel. [http://www.igmchicago.org/surveys/economic-stimulus-revisited](http://www.igmchicago.org/surveys/economic-stimulus-revisited)

[8] New evidence on convergence. Dietrich Vollrath. [https://growthecon.com/blog/Convergence/](https://growthecon.com/blog/Convergence/)

[9] Premature deindustrialization in the developing world.  Dani Rodrik. [https://rodrik.typepad.com/dani_rodriks_weblog/2015/02/premature-deindustrialization-in-the-developing-world.html](https://rodrik.typepad.com/dani_rodriks_weblog/2015/02/premature-deindustrialization-in-the-developing-world.html)

[10] Premature Deindustrialization.  Tyler Cowen.  [https://www.youtube.com/watch?v=xsAjHzAGZDU](https://www.youtube.com/watch?v=xsAjHzAGZDU)





