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

## A Complex Network

Next, here's a visualization I made based on the network described in the original [forum post](http://effective-altruism.com/ea/1h6/causal_networks_model_i_introduction_user_guide/), which evaluates potential focus areas for the effective altruism movement.  When you click a node with a dark outline below, it's the equivalent of giving one million dollars to that cause area.  The effect of the money then cascades through the network based on the differentials and elasticities defined by the authors.  In the end, red nodes represent beneficial changes and blue nodes harmful ones.  The final impact, in [quality adjusted life years](https://en.wikipedia.org/wiki/Quality-adjusted_life_year), is reported at the top.    

<iframe id="ea-network" 
    style="width: 100%; height:700px; border: none; position: relative; scrolling:no;">
</iframe>

I'm not sure I agree with every aspect of this model, but I think it provides a good example of how a complex network operates.  In this case, although spending on money on outreach for movement growth is the most connected node (Node 8), the total impact is smaller than improving policies related to [global catastrophic risks](https://en.wikipedia.org/wiki/Global_catastrophic_risk) (Node 6).  Another interesting takeaway is that interventions can be harmful in one domain and beneficial in another.  For example, donating money to [GiveDirectly](https://www.givedirectly.org/) improves the lives of the beneficiaries through increased consumption, but this consumption might also lead to a slight increases in carbon emissions that could partially offset the benefits.     

## Conclusion

I'm not sure how useful these models are for practical decision making, but I think they're a good reminder that it's important to consider indirect effects when trying to influence a complex system.  The main challenge seems to be choosing accurate values for the elasticities and differentials, which is difficult because there often isn't good experimental data to base them on.  One potential fix would be to use probability distributions and [monte carlo](https://en.wikipedia.org/wiki/Monte_Carlo_method) methods rather than point estimates, but this won't really solve the underlying problem.  In the future, I hope to make my own network model that incorporates areas like scientific research, policy advocacy, and economic policy, so stay tuned. 

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