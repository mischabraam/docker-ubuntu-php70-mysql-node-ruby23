FROM ubuntu:16.04
MAINTAINER Mischa Braam "mischa@weprovide.com"

ENV DEBIAN_FRONTEND noninteractive

# Set timezone
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -yq update
RUN apt-get -yq upgrade

# Basic Requirements
RUN apt-get -yq install mysql-server mysql-client php7.0 python-setuptools curl git unzip openssl libssl-dev libz-dev pkg-config ruby ruby-dev imagemagick

# Install Node / NPM from nodesource using apt-get, https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-an-ubuntu-14-04-server
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install -yq nodejs build-essential

# Install front end tools
RUN npm install -g npm
RUN npm install -g bower
RUN npm install -g gulp
RUN gem install bourbon
RUN gem install sass

# MySQL config
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
