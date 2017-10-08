---
layout: post
title: "Version Control with Jupyter Notebooks"
excerpt: "I demonstrate a technique for easily using version control along with Jupyter Notebooks."
#modified: 2016-02-22
tags: [Python, git, version control, Jupyter Notebook]
comments: true
share: false

---

I'm a big fan of using [Jupyter Notebooks](http://jupyter.org/) for Python projects, but one downside is that version control is a pain.  Commits become very large and illegible if you opt to track the entire notebook with the output cells, especially when graphics are included.  

There are a number of [proposed solutions](https://stackoverflow.com/questions/18734739/using-ipython-notebooks-under-version-control), but they require either changing your git configuration or generating a Jupyter [configuration file and modifying it](https://stackoverflow.com/a/25765194).  These approaches could vary by user and it's not clear from the code or repo how the changes are being tracked.  Below I outline an approach that might be better because the solution is included directly in a notebook cell.

## The Approach

I use a tool called [nbstripout](https://github.com/kynan/nbstripout) (installable via pip) along with a bash command in a notebook cell to solve this problem.  Just add a cell like this one to your notebook, set the filenames, save the notebook, then run the cell to create a cleaned version of your notebook without the output.  

{% highlight python %}

# Save your notebook and run this cell to create 
# a cleaned file for version control:
import os
import nbstripout
from datetime import datetime

notebook_path = os.path.join(os.getcwd(),'notebook_working.ipynb')
cleaned_path = os.path.join(os.getcwd(),'notebook_clean.ipynb')

#Bash command below:
!cat {notebook_path} | nbstripout > {cleaned_path}

date_str = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
print('{0} Cleaned file created at: {1}'.format(date_str, cleaned_path))
{% endhighlight %}

    2017-06-23 12:57:40 Cleaned file created at: <current directory>/notebook_clean.ipynb

Then use git to track the cleaned version and only commit to your working version when you need to push viewable results.  This way people can easily see what changes have been made to the clean version and merge changes into the working version more confidently.

{% highlight bash %}

$ git add notebook_clean.ipynb
$ git commit -m "First change, no output tracked"
$ git add notebook_clean.ipynb
$ git commit -m "Second change, no output tracked"
$ git add notebook_clean.ipynb notebook_working.ipynb
$ git commit -m "Third change, with output tracked in working file"

{% endhighlight %}
    
You could even use .gitignore to completely untrack the working version if you don't need to display the output anywhere:

    # .gitignore
    notebook_working.ipynb
    
This approach makes it clear how the files are being tracked and doesn't resort to user specific configuration files that seem prone to error.  




