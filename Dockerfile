# Use the official lightweight Ruby image.
# https://hub.docker.com/_/ruby
FROM jdickey/ruby:2.6.5-alpine

# Install production dependencies.
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_FROZEN=true
RUN gem install bundler -v 2.4.22
RUN bundle config set --local without 'test'
RUN bundle install 

# Copy local code to the container image.
COPY . ./

# Run the web service on container startup.
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "8080"]
