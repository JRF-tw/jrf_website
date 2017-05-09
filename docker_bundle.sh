#!/bin/bash -ex

function trap_handler(){
    docker stop gemfile
    docker rm gemfile
    exit 1
}

trap 'trap_handler' ERR SIGHUP SIGINT SIGQUIT SIGTERM

docker run --name gemfile -d ruby:2.4 ruby -run -e httpd /tmp
docker cp Gemfile gemfile:/
[[ -s Gemfile.lock ]] && docker cp Gemfile.lock gemfile:/
docker exec gemfile sh -c 'echo "deb http://ftp.cn.debian.org/debian jessie main" > /etc/apt/sources.list'
docker exec gemfile apt-get update
docker exec gemfile apt-get install libicu-dev -y --no-install-recommends
docker exec gemfile gem install bundler -v 1.14.6 -N
docker exec gemfile bundle config --global frozen 0
docker exec gemfile bundle config --global mirror.https://rubygems.org https://gems.ruby-china.org

docker exec gemfile bundle $@

docker cp gemfile:/Gemfile.lock .
docker stop gemfile
docker rm gemfile
