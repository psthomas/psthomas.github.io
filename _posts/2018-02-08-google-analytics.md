---
layout: post
title: "You might not need (most of) Google Analytics"
excerpt: "I manually build analytics queries for better page speed and more privacy."
tags: [JavaScript, privacy, pagespeed, Google Analytics]
comments: true
share: false

---

When I started this blog, I automatically included [Google Analytics](https://developers.google.com/analytics/devguides/collection/analyticsjs/) because it was convenient and useful.  I've recently been thinking more about privacy and page speed, so I've been looking for alternatives.  I ended up coming up with the following solution that still uses Google Analytics (GA), but is faster and more respectful of a user's privacy.    

## How Google Analytics Works

First, it makes sense to explain how GA works.  The most common way to use it is to add a script like this somewhere on the page:

{% highlight javascript %}
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-XXXXX-Y', 'auto');
ga('send', 'pageview');
{% endhighlight %}

This code just creates a GA object and a script tag, which then loads [analytics.js](https://developers.google.com/analytics/devguides/collection/analyticsjs/field-reference).  When the script loads, function calls are executed to collect information from the browser, set some cookies, and then send a pageview.  This pageview request is the most important part -- it's where all the data is collected. From a privacy standpoint, another relevant part is the `auto` argument, which tells GA to [automatically set cookies](https://developers.google.com/analytics/devguides/collection/analyticsjs/cookies-user-id#automatic_cookie_domain_configuration) to track users.  

Google does offer ways to increase privacy with custom settings on the GA object.  For example, the following settings [disable cookies](https://developers.google.com/analytics/devguides/collection/analyticsjs/cookies-user-id#disabling_cookies), [force SSL](https://developers.google.com/analytics/devguides/collection/analyticsjs/field-reference#forceSSL), and [store fewer digits](https://developers.google.com/analytics/devguides/collection/analyticsjs/ip-anonymization) of the IP address:

{% highlight javascript %}
ga('create', 'UA-XXXXX-Y', {
   'storage': 'none',
   'storeGac': false});
ga("set", "anonymizeIp", true);
ga('set', 'forceSSL', true);
ga('send', 'pageview');  
{% endhighlight %}

The problem with the above approach is that you depend on the API that Google is willing to build.  They still control what happens behind the scenes, and can change it in the future by modifying `analytics.js`.  In addition, they [only anonymize](https://support.google.com/analytics/answer/2763052?hl=en) the last octet of the IP address (e.g. `12.214.31.144` -> `12.214.31.0`), which [isn't very anonymous](https://computer.howstuffworks.com/internet/basics/question5492.htm) if you're on a corporate or university network (and still allows tracking at the city level for a large ISP).    

## The Measurement Protocol

An alternative to loading analytics.js is to manually collect whatever data you need, and then send it to a URL using their [measurement protocol](https://developers.google.com/analytics/devguides/collection/protocol/v1/reference).  This way you don't have to load analytics.js, and you have more [fine tuned](https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters) control over what data is sent.  Here's an example script that sends a `GET` request (an example `POST` request is in the appendix):

{% highlight javascript %}

function sendData() {
    var ls = [];
    var tid = 'UA-XXXXX-Y';  //Your Analytics ID
    var cid = Math.floor(100+Math.random()*900);
    var fields = ['v', 'tid', 'cid', 't', 'aip', 'uip', 'dl', 'dt']; 
    var values = [1, tid, cid, 'pageview', 1, '0.0.0.0', window.location.href, document.title]; 
    for (var i = 0; i<fields.length; i++) {
        ls.push(String(fields[i]) + '=' + encodeURIComponent(String(values[i])));
    }
    var url = "https://www.google-analytics.com/r/collect?" + ls.join('&');
    var request = new XMLHttpRequest();
    request.open("GET", url, true);
    request.send();
}
sendData();
{% endhighlight %}

There are more details about how this works in the [reference](https://developers.google.com/analytics/devguides/collection/protocol/v1/reference), but the main point is I only collect the `page URL` and `page title` for each visit.  The `uip` field is an override that sets the IP to `0.0.0.0`, and the `aip` field tells Google to anonymize this IP address.

**One caveat**: It took me awhile to realize this, but much of the data that GA collects is actually gathered when the user's browser performs the `GET` request, regardless of the data that's attached to the request.  This is how GA gets the user's IP address and User Agent information, so in the end this approach comes down to trusting that Google actually overrides and anonymizes the IP address in their database.  So I'm not completely sold on this approach yet, but it seems like an improvement.   

## Other Options

* Other third party analytics providers - The problem is, they can still sell your data.  
* [Google Webmasters Console](https://www.google.com/webmasters/) - This shows you how often your site showed up in searches, how often people clicked through to your site, and inbound links.  The downside is it only shows traffic from Google searches. 
* Self Hosted - Options like [Matomo/Piwik](https://matomo.org/) are nice, or you could just set up a server and perform get requests to it whenever a site page loads.  The problem is, this option is more complicated than the static site itself.  
* [Amazon Bucket](https://aws.amazon.com/s3/) - Static sites hosted in S3 buckets can be configured to store access logs.  You could pull these down using the command line and analyze them locally.  Unfortunately, static sites on S3 are a pain to set up.  

## Appendix - Post Request

Note this uses a different URL (`/collect`), and sends the joined fields as the body of the `POST`.  

{% highlight javascript %}
function sendData() {
    var ls = [];
    var tid = 'UA-XXXXX-Y';  //Your Analytics ID
    var cid = Math.floor(100+Math.random()*900);
    var fields = ['v', 'tid', 'cid', 't', 'aip', 'uip', 'dl', 'dt']; 
    var values = [1, tid, cid, 'pageview', 1, '0.0.0.0', window.location.href, document.title]; 
    for (var i = 0; i<fields.length; i++) {
        ls.push(String(fields[i]) + '=' + encodeURIComponent(String(values[i])));
    }
    var data = ls.join('&');
    var request = new XMLHttpRequest();
    request.open("POST", "https://www.google-analytics.com/collect", true);
    request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    request.send(data);
}
sendData();
{% endhighlight %}