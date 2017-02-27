#!/bin/bash

###################################################################
# installing dependencies
###################################################################
echo -e "\n--- Installing composer packages && npm modules ---\n"
cd /var/www/symfony-vagrant/
composer install
npm install