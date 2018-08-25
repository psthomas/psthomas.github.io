---
layout: post
title: "Network Models for Thinking About the World"
excerpt: "I build a few interactive visualizations to communicate the concepts behind network models."
#modified:
tags: [JavaScript, d3.js, network models, complex systems]
comments: true
share: false

---

In a [previous post](https://pstblog.com/2017/07/28/mental-model), I built a simple model of the world where the interventions didn't influence each other.  But in some systems (e.g. economic, political, ecological), the high number of connections means that the indirect effects of our actions might be more important than the direct effects.  In these contexts, it might make more sense to use a network of nodes and edges to represent interventions rather than a traditional model.  I recently came across an [interesting post](http://effective-altruism.com/ea/1h6/causal_networks_model_i_introduction_user_guide/) on this topic, so I decided to build a few visualizations to communicate the ideas.

## A Simple Network

Your goal in the network below is to get the highest score by clicking a single node.  The node size is proportional to the direct impact while the edges represent secondary effects.  When you mouseover a node, the outgoing connections show up as solid lines while the incoming connections are dashed.

<iframe id="network"
    style="width: 100%; height:600px; border: none; position: relative; scrolling:no;">
</iframe>

Hopefully you found the best option, which might be a little surprising given its small direct effect.  In this case, the strong connections with the rest of the nodes in the network result in a high indirect score.  

## A Complicated Network

Next, here's a visualization I made based on the network described in the original [forum post](http://effective-altruism.com/ea/1h6/causal_networks_model_i_introduction_user_guide/), which evaluates potential focus areas for the effective altruism movement.  When you click a node with a dark outline below, it's the equivalent of giving one million dollars to that cause area.  The effect of the money then cascades through the network based on the differentials and elasticities defined by the authors.  In the end, red nodes represent beneficial changes and blue nodes harmful ones.  The final impact, in [quality adjusted life years](https://en.wikipedia.org/wiki/Quality-adjusted_life_year), is reported at the top.    

<iframe id="ea-network" 
    style="width: 100%; height:700px; border: none; position: relative; scrolling:no;">
</iframe>

I'm not sure I agree with every aspect of this model, but I think it provides a good example of how a complicated network operates.  In this case, although spending on money on outreach for movement growth is the most connected node (Node 8), the total impact is smaller than improving policies related to [global catastrophic risks](https://en.wikipedia.org/wiki/Global_catastrophic_risk) (Node 6).  Another interesting takeaway is that interventions can be harmful in one domain and beneficial in another.  For example, donating money to [GiveDirectly](https://www.givedirectly.org/) improves the lives of the beneficiaries through increased consumption, but this consumption might also lead to a slight increases in carbon emissions that could partially offset the benefits.

The main challenge with this model seems to be choosing accurate values for the elasticities and differentials, which is difficult because they need to be derived from experimental data or expert judgement.  One potential fix would be to use probability distributions and [monte carlo](https://en.wikipedia.org/wiki/Monte_Carlo_method) methods rather than point estimates.  Although this won't really solve the underlying problem, it would at least convey some level of uncertainty.  

Another challenge is that it's hard to represent nonlinear relationships using differentials and elasticities.  For example, my first inclination is to add a fluctuating growth rate to the model to see how it affects the long term GDP.  But this is difficult because representing a [compound interest](https://en.wikipedia.org/wiki/Compound_interest#Periodic_compounding) formula like `P' = P(1+r)^t` isn't possible using elasticities and differentials (as far as I can tell).  So maybe using a [system dynamics](https://en.wikipedia.org/wiki/System_dynamics) model that can handle non-linear relationships would be a better approach.  There seem to be a number of options for these models in Python [[1](https://github.com/JamesPHoughton/pysd), [2](https://github.com/jdherman/stockflow)], as well as a pretty cool [in-browser option](https://insightmaker.com/) that's [open source](https://github.com/scottfr/insightmaker). 

## Places to Intervene in a System

Finally, here's a quote from an interesting [article](http://donellameadows.org/archives/leverage-points-places-to-intervene-in-a-system/) discussing the best ways to influence a system: 

> Places to Intervene in a System (in increasing order of effectiveness):  
9. Constants, parameters, numbers (subsidies, taxes, standards).  
8. Regulating negative feedback loops.  
7. Driving positive feedback loops.  
6. Material flows and nodes of material intersection.  
5. Information flows.  
4. The rules of the system (incentives, punishments, constraints).  
3. The distribution of power over the rules of the system.  
2. The goals of the system.  
1. The mindset or paradigm out of which the system — its goals, power structure, rules, its culture — arises.

Many of the best options in the network above score well on this list.  For example, global catastrophic risk (GCR) strategy is so effective because it increases concern about GCRs within academia and government.  So it's influential through a combination of step #2 (changing the goals of the system) and step #1 (changing the mindset that the system arises from).  

What this list doesn't consider is that it's often more difficult to intervene at the higher levels of a system -- influencing goals, mindsets and power distributions seems hard.  But the model does account for this because areas that are harder to influence will have smaller incoming differentials and elasticities.       

## Conclusion

I'm not sure how useful these models are for practical decision making but I think they're a good reminder to consider indirect effects when trying to influence a complex system.  I also think they're useful for getting people to state their assumptions about the world in a way that's open to critique.  In the future, I hope to make my own model incorporating areas like scientific research, other types of policy advocacy, and economic policy, so stay tuned. 

## Appendix A: How it Works

The network above is considered a [cyclic graph](http://mathworld.wolfram.com/CyclicGraph.html), which means there can be feedback loops between the nodes.  The only requirement is there aren't any *positive* feedback loops, which would prevent the infinite series from converging.  The details of the math are covered more in the [technical guide](http://effective-altruism.com/ea/1h9/test/), but this is the basic equation to find a solution, where `I` is an identity matrix, `M` is the matrix of effects, and `V` is the vector of inputs: 

{% highlight javascript %}
Results = V * (I - M)^-1
{% endhighlight %}

In the code, I use [math.js](http://mathjs.org/docs/datatypes/matrices.html) to do the matrix algebra, using a function similar to this:

{% highlight javascript %}
function solve(arr, matrix) {
  var len = arr.length;
  var ident = math.identity(len, len);
  var res = math.multiply(arr, math.inv(math.subtract(ident, matrix))).toArray();
  return res;
}
{% endhighlight %}

## References 

[1] *Causal Networks Model I: Introduction & User Guide.*  Denise Melchin.  [http://effective-altruism.com/ea/1h6/causal_networks_model_i_introduction_user_guide/](http://effective-altruism.com/ea/1h6/causal_networks_model_i_introduction_user_guide/)

[2] *Causal Networks Model II: Technical Guide.*  Alex Barry.  [http://effective-altruism.com/ea/1h9/test/](http://effective-altruism.com/ea/1h9/test/)

[3] *Causality in complex interventions.* Dean Rickles.  [https://link.springer.com/article/10.1007%2Fs11019-008-9140-4](https://link.springer.com/article/10.1007%2Fs11019-008-9140-4)

[4] *math.js.*  [http://mathjs.org/](http://mathjs.org/)  

[5] *Leverage Points: Places to Intervene in a System.*  Donella Meadows.  [http://donellameadows.org/archives/leverage-points-places-to-intervene-in-a-system/](http://donellameadows.org/archives/leverage-points-places-to-intervene-in-a-system/)


<script src="https://d3js.org/d3.v4.min.js"></script>

<script>
d3.request("https://raw.githubusercontent.com/psthomas/mental-model/master/causal-network/network.html")
    .get(function(a) {
        document.getElementById("network").srcdoc = a.response;
    });
    
d3.request("https://raw.githubusercontent.com/psthomas/mental-model/master/causal-network/ea-network.html")
    .get(function(a) {
        document.getElementById("ea-network").srcdoc = a.response;
    });
</script>