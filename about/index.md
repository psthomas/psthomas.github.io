---
layout: page
title: About 
tags: [blog, portfolio, Philip Thomas, software developer, web development, Python, JavaScript, Flask]
modified: 2014-08-08T20:53:07.573882-04:00
share: false
prof_img: true

---

<div class="article-author-about">
<img src="{{site.baseurl}}/images/author.jpg" class="bio-photo"  alt="{{ author.name }} bio photo">
<div>
<strong>Philip Thomas</strong><br>
<!--href=" site.baseurl /images/email.png"-->
<a style="cursor:pointer;" onclick="alert(['ptho','mas','.v3','@','gm','ail','.co','m'].join(''));" title="Email">Email</a>,
<a href="http://github.com/psthomas" title="GitHub"> GitHub</a>, 
<a href="https://pstblog.com/feed.xml" title="RSS"> RSS</a>
</div>
</div>

<!-- I have an academic background in biology and environmental engineering.  Recently, I have been learning some Python and JavaScript, focusing mainly on web development.  I enjoy working with these two languages, which seem capable of building just about anything.  -->

I have an academic background in [biological systems engineering](https://bse.wisc.edu/) and biology. I picked up some Python and JavaScript along the way and currently work as a freelance programmer and data analyst. I enjoy working with these two languages, which seem capable of building just about anything.

My other interests include economics, public health and life sciences research. I'll write about some of these topics when I know enough to be competent, otherwise I'll stick to summarizing the views of others.  

## Projects 

I'm mostly familiar with Python and Flask for web development along with JavaScript on the frontend. I also enjoy asking questions and trying to answer them with data, using tools like Jupyter Notebooks, Pandas, and D3.js.

**Tabula**  
A simple, stateless password manager built with JavaScript. [[source](https://github.com/psthomas/tabula), [demo]({{site.baseurl}}/2018/01/30/password-manager#tabula)]  
**notebook-html**  
A JavaScript module for rendering Jupyter Notebooks as HTML. [[source](https://github.com/psthomas/notebook-html), [demo](https://psthomas.github.io/notebook-html/)]  
**Jupyter Notebooks**  
There are a number of notebooks outlining my data projects here: [[source](https://github.com/psthomas?tab=repositories&q=&type=source&language=jupyter+notebook)]  
**Visualizations**  
Some of the interactive visualizations I've built using tools like D3.js and Altair: [[demo]({{site.baseurl}}/vis/)]     


<h2>Search</h2>
<div>
Search pstblog.com on DuckDuckGo:
<form onsubmit="return ss(this)" method="get">
    <input type="text" size="40" id="goog-wm-qt" name="q" placeholder="Search Terms"> <!--style="width:350px"-->
    <input type="submit" class="btn" value="Search">
</form>
</div>
<script type="text/javascript">
function ss(form) {
    var q = window.encodeURIComponent(form["q"].value);
    var url = "https://duckduckgo.com/?q=site:pstblog.com ";
    url = url + q;
    window.location = url;
    return false;
}
</script> 



