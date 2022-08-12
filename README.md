# pstblog.com

This is the source code for my personal website, [pstblog.com](http://pstblog.com).  

It is based on the [Minimal Mistakes](https://github.com/mmistakes/minimal-mistakes) theme.  Changes I have made this theme include:

* Disqus comments load on a button click rather than automatically
* Typography changes, mainly to the body text and navigation bar
* Wider text field for the body 
* A variety of other style tweaks
* Remove the Grunt build tool and dependencies.   

A more in-depth description of this theme's features is available at the Minimal Mistakes [theme setup page](http://mmistakes.github.io/minimal-mistakes/theme-setup/).  

## Requirements

This template is compatible with Jekyll 4.0 and up, uses Rouge for code highlighting and Kramdown for markdown conversion. As detailed below, Ruby is needed as well, depending on how much you want to customize the site.

## Run Locally

If you want to run this locally, there are a few steps. 

1. Fork this repo, clone the fork, and cd to the clone
2. Bundle install the dependencies in the `Gemfile`
3. Update the site's _config.yml with your own settings
4. Serve the site locally using jekyll
```
$ git clone url-for-your-clone
$ cd path/to/clone
$ bundle install
$ bundle exec jekyll serve 
```

Then visit the development server at http://localhost:4000/ to view your site.

### Docker

If you're familiar with Docker, you can also use the `Dockerfile` or `docker-compose.yaml` to build an image and run a local container. Either use docker-compose in the root directory:
```
$ docker-compose up
```
Or use the `Dockerfile` to build your own image and start a container:
```
$ docker image build --tag blog-image .
$ docker container run --rm --publish 4000:4000 --name blog-container --volume $(pwd):/home/app blog-image
```
This container will also be available at http://localhost:4000/, and it binds to your local root directory to live reload as you edit the blog. 

