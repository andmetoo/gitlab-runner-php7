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

### Sample `bitbucket-pipelines.yml`

```YAML
image: andmetoo/gitlab-runner-php7

before_script:
# Install dependencies
- bash ci/docker_install.sh > /dev/null

test:app:
  script:
  - codecept.run
```
