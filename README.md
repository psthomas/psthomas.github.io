# pstblog.com

This is the source code for my personal website, [pstblog.com](http://pstblog.com).  

It is based on the [Minimal Mistakes](https://github.com/mmistakes/minimal-mistakes) theme.  Changes I have made this theme include:

* Disqus comments load on a button click rather than automatically
* Typography changes, mainly to the body text and navigation bar
* Wider text field for the body 
* A variety of other style tweaks 

Here are the two commits showing the changes:
[Deletions](https://github.com/psthomas/psthomas.github.io/commit/30b59fc6bb13ba3d1b471b216061fe1894aa7ba3), 
[Site Updates](https://github.com/psthomas/psthomas.github.io/commit/afd450bfd56a1778be1016385fd35cb5435a50f8)

A more in-depth description of this theme's features is available at the Minimal Mistakes [theme setup page](http://mmistakes.github.io/minimal-mistakes/theme-setup/).  

## Requirements

This template is compatible with Jekyll 3.0 and up, uses Rouge for code highlighting and Kramdown for markdown conversion.  As detailed below, ruby and node are needed as well, depending on how much you want to customize the site.  

## Run Locally

If you want to run this locally, there are a few steps. 

1. Install `bundler` (`$ gem install bundler`) if you don't have it 
2. Fork this repo, clone the fork, and cd to the clone
3. Bundle install Jekyll and the dependencies in the `Gemfile`
4. Update the site's _config.yml with your content (and remove mine)
5. Serve the site locally using jekyll

```
$ gem install bundler 
$ git clone url-for-your-clone
$ cd path/to/clone
$ bundle install
$ bundle exec jekyll serve 
```

Then visit the development server at http://localhost:4000/ to view your site.  
