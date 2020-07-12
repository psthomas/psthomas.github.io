---
layout: post
title: "Privacy With Google Analytics"
excerpt: "I manually build analytics requests for better page speed and more privacy."
tags: [JavaScript, privacy, page speed, Google Analytics]
comments: true
share: false

---

When I started this blog, I automatically included [Google Analytics](https://developers.google.com/analytics/devguides/collection/analyticsjs/) because it was convenient and useful.  I've recently been thinking more about privacy, so I've been looking for alternatives.  I ended up coming up with the following solution that still uses Google Analytics, but sends less user information (and loads faster).

## How Analytics.js Works

The most common way to use GA is to include a script like this somewhere on the page:

{% highlight javascript %}
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-XXXXX-Y', 'auto');
ga('send', 'pageview');
{% endhighlight %}

This code creates a GA object and a script tag, which then loads [analytics.js](https://developers.google.com/analytics/devguides/collection/analyticsjs/field-reference).  When the script loads, functions are called to collect information from the browser, set some cookies, and then send a pageview.  This pageview `GET` request is the most important part -- it's where all the data is collected.  From a privacy standpoint, another relevant part is the `auto` argument, which tells GA to [automatically set cookies](https://developers.google.com/analytics/devguides/collection/analyticsjs/cookies-user-id#automatic_cookie_domain_configuration) to track users.  One of these cookies persists for 2 years, and is meant to track users across multiple sessions.   

Google does offer ways to increase privacy with custom settings on the GA object.  For example, the following settings [disable cookies](https://developers.google.com/analytics/devguides/collection/analyticsjs/cookies-user-id#disabling_cookies), [force SSL](https://developers.google.com/analytics/devguides/collection/analyticsjs/field-reference#forceSSL), and [store fewer digits](https://developers.google.com/analytics/devguides/collection/analyticsjs/ip-anonymization) of the IP address:

{% highlight javascript %}
ga('create', 'UA-XXXXX-Y', {
   'storage': 'none',
   'storeGac': false});
ga("set", "anonymizeIp", true);
ga('set', 'forceSSL', true);
ga('send', 'pageview');  
{% endhighlight %}

The problem with the above approach is that you depend on what Google is willing to build into their API.  They still control what happens behind the scenes, and can change it in the future by modifying `analytics.js`.  In addition, they [only anonymize](https://support.google.com/analytics/answer/2763052?hl=en) the last octet of the IP address (e.g. `12.214.31.144` -> `12.214.31.0`), which [isn't very anonymous](https://computer.howstuffworks.com/internet/basics/question5492.htm) if you're on a corporate or university network (and still allows tracking at the city level for a large ISP).    

## The Measurement Protocol

An alternative to loading analytics.js is to manually collect whatever data you need, then send it to them using the [measurement protocol](https://developers.google.com/analytics/devguides/collection/protocol/v1/reference).  This way you don't have to load analytics.js, and you have more [fine tuned](https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters) control over what data is sent.  Here's an example script that sends a `GET` request (an example `POST` request is in the appendix):

{% highlight javascript %}
let ls = [];
const tid = 'UA-XXXXX-Y';  //Your Analytics ID
const cid = Math.floor(100+Math.random()*900);
const fields = ['v', 'tid', 'cid', 't', 'aip', 'uip', 'dl', 'dt']; 
const values = [1, tid, cid, 'pageview', 1, '0.0.0.0', window.location.href, document.title]; 
for (const i = 0; i<fields.length; i++) {
    ls.push(String(fields[i]) + '=' + encodeURIComponent(String(values[i])));
}
const url = 'https://www.google-analytics.com/r/collect?' + ls.join('&');
// https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch
fetch(url);
{% endhighlight %}

There are more details about how this works in the [reference](https://developers.google.com/analytics/devguides/collection/protocol/v1/reference), but the main point is I only collect the `page URL` and `page title` for each visit.  The `uip` field is an override that sets the IP to `0.0.0.0`, and the `aip` field tells Google to anonymize this IP address.

**One caveat**: It took me awhile to realize this, but much of the data that GA collects is actually gathered when the user's browser performs the `GET` request, regardless of the data that's attached to the request.  This is how GA gets the user's IP address and User Agent information, so in the end this approach comes down to trusting that Google actually overrides and anonymizes the IP address in their database.  So I'm not completely sold on this approach yet, but it seems like an improvement.   

## Other Options

* Other third party analytics providers - The problem is, they can still sell your data.  
* [Google Webmasters Console](https://www.google.com/webmasters/) - This shows you how often your site appears in searches, how often people clicked through to your site, and inbound links.  The downside is it only shows traffic from Google searches. 
* Self Hosted - Options like [Matomo/Piwik](https://matomo.org/) are nice, or you could just set up your own server and perform get requests to it whenever a site page loads.  The problem is, these options are more complicated than the static site itself.  
* [Amazon Bucket](https://aws.amazon.com/s3/) - Static sites hosted in S3 buckets can be configured to store access logs.  You could pull these down using the command line and analyze them locally.  Unfortunately, static sites on S3 are a pain to set up.  

## Appendix - Post Request

Note this uses a different URL (`/collect`), and sends the joined fields as the body of the `POST`.  

{% highlight javascript %}
let ls = [];
const tid = 'UA-XXXXX-Y';  //Your Analytics ID
const cid = Math.floor(100+Math.random()*900);
const fields = ['v', 'tid', 'cid', 't', 'aip', 'uip', 'dl', 'dt']; 
const values = [1, tid, cid, 'pageview', 1, '0.0.0.0', window.location.href, document.title]; 
for (const i = 0; i<fields.length; i++) {
  ls.push(String(fields[i]) + '=' + encodeURIComponent(String(values[i])));
}
const data = ls.join('&');
const request = {
  method: 'POST',
  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  body: data
};
// https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch
fetch('https://www.google-analytics.com/collect', request);
{% endhighlight %}