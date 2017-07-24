# Gitlab runner PHP 7.0 image
[![](https://images.microbadger.com/badges/version/andmetoo/gitlab-runner-php7.svg)](https://microbadger.com/images/andmetoo/gitlab-runner-php7 "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/andmetoo/gitlab-runner-php7.svg)](https://microbadger.com/images/andmetoo/gitlab-runner-php7 "Get your own image badge on microbadger.com")

## Based on Ubuntu 16.04

### Packages installed

- `php7.0-fpm`, `php7.0-mcrypt`, `mongod`, `xdebug`, `php7.0-zip`, `php7.0-xml`, `php7.0-mbstring`, `php7.0-curl`, `php7.0-json`, `php7.0-imap`, `php7.0-mysql` and `php7.0-tokenizer`
- [Composer](https://getcomposer.org/)
- [Deployer](https://github.com/deployphp/deployer)
- Node / NPM / Gulp 
- Mysql 5.7

### Sample `bitbucket-pipelines.yml` with optional mysql as service

```YAML
stages:
  - test

variables:
  MYSQL_ROOT_PASSWORD: root
  MYSQL_USER: test
  MYSQL_PASSWORD: test
  MYSQL_DATABASE: test
  DB_HOST: mysql

# Speed up builds
cache:
  key: $CI_BUILD_REF_NAME
  paths:
    - vendor
    - node_modules
    - ~/.composer/cache/files

before_script:
    - sh .gitlab-ci.sh
    - echo "$GITLAB_SSH_KEY" >>  ~/.ssh/id_rsa
    - ssh-keyscan -t rsa gitlab.com >> ~/.ssh/known_hosts
    - chmod 600  ~/.ssh/id_rsa
    - composer install
test:
  stage: test
  services:
    #- mysql:5.7
  image: andmetoo/gitlab-runner-php7
  script:
    - codecept run --coverage --coverage-text --coverage-html
  artifacts:
    paths:
    - tests/_output/coverage/
    - tests/_output/coverage.txt
    expire_in: 2 week
```
```bash
#!/usr/bin/env bash

# Install dependencies only for Docker.
[[ ! -e /.dockerinit ]] && exit 0
set -xe

# Install Composer and project dependencies.
echo "start mysql"
service mysql start
echo "add user"
mysql -h localhost --user=root --password=root -e "CREATE DATABASE test;CREATE USER 'test'@'%' IDENTIFIED BY 'test';GRANT ALL PRIVILEGES ON *.* TO 'test'@'%'; FLUSH PRIVILEGES;"
# Copy over testing configuration.
```
