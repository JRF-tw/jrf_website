FROM ruby:2.3
MAINTAINER Jiang Wu "masterwujiang@gmail.com"

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN echo "deb http://ftp.cn.debian.org/debian jessie main\ndeb http://ftp.cn.debian.org/debian jessie-backports main" > /etc/apt/sources.list
RUN apt-get update \
        && apt-get install -y --no-install-recommends -t jessie-backports \
          libicu-dev \
          nodejs \
        && rm -rf /var/lib/apt/lists/*

ARG GEM_MIRROR
RUN echo $GEM_MIRROR

RUN if [ -n $GEM_MIRROR ];then bundle config mirror.https://rubygems.org $GEM_MIRROR; fi
RUN bundle install --without test:development
RUN if [ -n $GEM_MIRROR ];then bundle config --delete mirror.https://rubygems.org; fi
