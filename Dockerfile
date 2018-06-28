FROM ubuntu:16.04
MAINTAINER Mischa Braam "mischa@weprovide.com"

ENV DEBIAN_FRONTEND noninteractive

# Set timezone
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -yq update
RUN apt-get -yq upgrade

# Prepare installation of MySQL, set password to use
RUN echo mysql-server-5.7 mysql-server/root_password password root | debconf-set-selections
RUN echo mysql-server-5.7 mysql-server/root_password_again password root | debconf-set-selections

# Basic Requirements
RUN apt-get -yq install mysql-server mysql-client php7.0 php7.0-xml php7.0-xmlreader php7.0-zip php7.0-curl php7.0-dom php7.0-mysql python-setuptools curl git unzip openssl libssl-dev libz-dev pkg-config ruby ruby-dev imagemagick

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

# Install composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot \
    && rm -f /tmp/composer-setup.*
