FROM ubuntu:16.04

MAINTAINER andmetoo <hello@notme.pw>

# Use baseimage-docker's init system.
#CMD ["/sbin/my_init"]

# Set correct environment variables
ENV HOME /root

# MYSQL ROOT PASSWORD
ARG MYSQL_ROOT_PASS=root    

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    locales \
    software-properties-common \
    python-software-properties \
    build-essential \
    curl \
    git \
    unzip \
    mcrypt \
    wget \
    openssl \
    autoconf \
    openssh-client \
    g++ \
    make \
    libssl-dev \
    libcurl4-openssl-dev \
    libsasl2-dev \
    libcurl3 \
    --no-install-recommends && rm -r /var/lib/apt/lists/* \
    && apt-get --purge autoremove -y

# Ensure UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
RUN locale-gen en_US.UTF-8

# OpenSSL
RUN mkdir -p /usr/local/openssl/include/openssl/ && \
    ln -s /usr/include/openssl/evp.h /usr/local/openssl/include/openssl/evp.h && \
    mkdir -p /usr/local/openssl/lib/ && \
    ln -s /usr/lib/x86_64-linux-gnu/libssl.a /usr/local/openssl/lib/libssl.a && \
    ln -s /usr/lib/x86_64-linux-gnu/libssl.so /usr/local/openssl/lib/

# NODE JS
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install nodejs -qq && \
    npm install -g gulp-cli 

# MYSQL
# /usr/bin/mysqld_safe
RUN bash -c 'debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password password $MYSQL_ROOT_PASS"' && \
		bash -c 'debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password_again password $MYSQL_ROOT_PASS"' && \
		DEBIAN_FRONTEND=noninteractive apt-get update && \
		DEBIAN_FRONTEND=noninteractive apt-get install -qqy mysql-server-5.7		
# PHP Extensions
RUN add-apt-repository -y ppa:ondrej/php && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y -qq php-pear php7.0-dev php7.0-fpm php7.0-mcrypt php7.0-zip php7.0-xml php7.0-mbstring php7.0-curl php7.0-json php7.0-mysql php7.0-tokenizer php7.0-cli php7.0-imap && \
    apt-get remove --purge php5 php5-common

# Time Zone
RUN echo "date.timezone = UTC" > /etc/php/7.0/cli/conf.d/date_timezone.ini && \
    echo "date.timezone = UTC" > /etc/php/7.0/fpm/conf.d/date_timezone.ini

VOLUME /root/composer

# Environmental Variables
ENV COMPOSER_HOME /root/composer

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Goto temporary directory.
WORKDIR /tmp

# Codecept Support
wget http://codeception.com/codecept.phar
chmod +x codecept.phar
sudo mv codecept.phar /usr/local/bin/codecept

# Deployer
RUN curl -L http://deployer.org/deployer.phar -o deployer.phar && \
    mv deployer.phar /usr/local/bin/dep && \
    chmod +x /usr/local/bin/dep

RUN service php7.0-fpm restart

RUN apt-get clean -y && \
        apt-get autoremove -y && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
