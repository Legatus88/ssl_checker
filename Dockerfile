FROM ruby:2.6.3p62
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /ssl_checker
WORKDIR /ssl_checker
ADD Gemfile /ssl_checker/Gemfile
ADD Gemfile.lock /ssl_checker/Gemfile.lock
RUN bundle install
ADD . /ssl_checker
