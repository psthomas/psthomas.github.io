
# https://lipanski.com/posts/dockerfile-ruby-best-practices
FROM ruby:2.7.6-alpine3.16 AS base

# This stage will be responsible for installing gems
FROM base AS dependencies

# Install system dependencies required to build some Ruby gems (pg)
RUN apk add --update build-base

COPY Gemfile Gemfile.lock ./

# bundle config set without "development test" && 
RUN bundle install --jobs=3 --retry=3

# We're back at the base stage
FROM base

# Create a non-root user to run the app and own app-specific files
RUN adduser -D app

# Switch to this user
USER app

# We'll install the app in this directory
WORKDIR /home/app

# Copy over gems from the dependencies stage
COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/

# Finally, copy over the code
# This is where the .dockerignore file comes into play
# Note that we have to use `--chown` here
COPY --chown=app . ./

EXPOSE 4000

# Launch the server (or run some other Ruby command)
# Watches the bound volume for updates
# CMD ["bundle", "exec", "jekyll", "serve", "--livereload"] #"--livereload" --watch
# Note, you need to specify host 0.0.0.0 here, otherwise it runs on 127.0.0.1
# https://github.com/daattali/beautiful-jekyll/issues/263
CMD bundle exec jekyll serve --host 0.0.0.0 --port 4000 --livereload

# Build/run commands: 
# docker image build --tag blog-image .
# docker container run --rm --publish 4000:4000 --name blog-container --volume $(pwd):/home/app blog-image
