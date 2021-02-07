FROM python:3.7-slim-buster
LABEL maintainer="CloudOps"

WORKDIR /work

# install dependencies
RUN apt update
RUN apt install vim make gcc ruby-full curl git -y

# install aws cli
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
#RUN ./awscli-bundle/install -b ~/bin/aws
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# install test kitchen dependencies
RUN gem install bundle
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install