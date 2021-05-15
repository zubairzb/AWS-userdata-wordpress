#!/bin/bash

########################
#Script Created by ZB for wordpress spinup
#######################################

########################
#INSTALLING OF PACKAGES
########################

yum install httpd mariadb-server mariadb -y
amazon-linux-extras install php7.2 -y
yum install php-gd php-mysql -y

########################
#START AND ENABLING OF SERVICES
#######################
service httpd start
systemctl enable httpd
systemctl start mariadb
systemctl enable mariadb.service

########################
#CONFIGURE WORDPRESS DB
########################

mysql -e "create database wpdb;"
mysql -e "CREATE USER wpuser@localhost IDENTIFIED BY 'wp123';"
mysql -e "GRANT ALL PRIVILEGES ON wpdb.* TO wpuser@localhost IDENTIFIED BY 'wp123';"
mysql -e "FLUSH PRIVILEGES;"

systemctl restart httpd.service

######################
#INSTALLING WORDPRESS
#######################

cd /var/www/html/
wget https://wordpress.org/latest.zip
unzip latest.zip
rsync -aPz wordpress/* /var/www/html/
mkdir /var/www/html/wp-content/uploads
chown -R apache:apache /var/www/html/*
rm -rf latest.zip wordpress

##################
#CONFIGURING WP_CONFIG
##########################
cp -apf wp-config-sample.php wp-config.php
sed -i -e  "s/define( 'DB_NAME', 'database_name_here' );/define( 'DB_NAME', 'wpdb' );/g" /var/www/html/wp-config.php
sed -i -e "s/define( 'DB_USER', 'username_here' );/define( 'DB_USER', 'wpuser' );/g" /var/www/html/wp-config.php
sed -i -e "s/define( 'DB_PASSWORD', 'password_here' );/define( 'DB_PASSWORD', 'wp123' );/g" /var/www/html/wp-config.php
service httpd restart

