#!/bin/bash

sudo su
###################################################################
# Vagrant specific
###################################################################
sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile

export DEBIAN_FRONTEND=noninteractive

apt-get install -y language-pack-en
locale-gen "en_US.UTF-8"
dpkg-reconfigure locales
update-locale LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8" LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

add-apt-repository ppa:ondrej/php -y
add-apt-repository -y 'deb http://archive.ubuntu.com/ubuntu trusty universe'
apt-get update > /dev/null 2>&1
###################################################################
# php
###################################################################
apt-get install -y --no-install-recommends php7.1 php7.1-fpm php7.1-cli php7.1-dev php7.1-curl php7.1-intl php7.1-mysql
###################################################################
# npm
###################################################################
apt-get install -y npm nodejs
ln -s /usr/bin/nodejs /usr/bin/node
###################################################################
# composer
###################################################################
cd /tmp && curl -O https://getcomposer.org/installer && php installer && mv composer.phar /usr/local/bin/composer
###################################################################
# nginx
###################################################################
apt-get install -y nginx
root -c "echo '127.0.0.1 my.site.com' >> /etc/hosts"
root -c "echo '127.0.0.1 phpmyadmin.dev' >> /etc/hosts"

rm /etc/nginx/sites-enabled/*
rm /etc/nginx/nginx.conf

cp /var/www/symfony-vagrant/dist/nginx/nginx.conf /etc/nginx/
cp /var/www/symfony-vagrant/dist/nginx/my.site.conf /etc/nginx/sites-available/
cp /var/www/symfony-vagrant/dist/nginx/phpmyadmin.conf /etc/nginx/sites-available/

ln -s /etc/nginx/sites-available/my.site.conf /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/phpmyadmin.conf /etc/nginx/sites-enabled/
###################################################################
# mysql && phpmyadmin
###################################################################
debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password root"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password root"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password root"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"
apt-get install -y mysql-server-5.6
apt-get install -y --no-install-recommends phpmyadmin
ln -s /usr/share/phpmyadmin/ /var/www/phpmyadmin
###################################################################
# xdebug
###################################################################
root -c "echo 'xdebug.remote_port = 9005' >> /etc/php/7.1/mods-available/xdebug.ini"
root -c "echo 'xdebug.remote_enable = 1' >> /etc/php/7.1/mods-available/xdebug.ini"
root -c "echo 'xdebug.remote_connect_back = 1' >> /etc/php/7.1/mods-available/xdebug.ini"
root -c "echo 'xxdebug.idekey = "PHPSTORM"' >> /etc/php/7.1/mods-available/xdebug.ini"
###################################################################
# restarting services
###################################################################
apt-get autoremove -y
service nginx restart
service php7.1-fpm restart
service mysql restart
