FROM ruby:3.1.1

WORKDIR /app

RUN apt-get update && rm -rf /var/lib/apt/lists/*

COPY . .

RUN gem install bundler && bundle install
