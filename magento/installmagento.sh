#!/bin/bash
# This script installs Magento2 on Ubuntu1404 system
PASSWORD='septimo'
HOSTNAME='testmagento.org'
IP=`ip addr show | grep global | awk '{print $2}' | cut -d "/" -f1`
SPACE=" "
HOSTS=$IP$SPACE$HOSTNAME
echo $HOSTS >> /etc/hosts
echo "Changing default repositories to BY"
sed -i 's/us\.archive/by\.archive/g' /etc/apt/sources.list
echo "Copy installation conf files to home directory"
cp /vagrant/magentoinstall.sql /home/vagrant/
cp /vagrant/magento.conf /home/vagrant/
echo "Installing nginx and installation dependencies"
apt-get install -y nginx software-properties-common
echo "Installing PHP7"
echo "Adding php7 PPA"
apt-get install -y language-pack-en-base
LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
echo "Adding mariadb repository"
add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://ftp.hosteurope.de/mirror/mariadb.org/repo/10.1/ubuntu trusty main'
apt-get update
echo "Installing php7"
apt-get install php7.0-fpm php7.0-mcrypt php7.0-curl php7.0-cli php7.0-mysql php7.0-gd php7.0-xsl php7.0-json php7.0-intl php-pear php7.0-dev php7.0-common php7.0-mbstring php7.0-zip php-soap libcurl3 curl -y
echo "Installing mariadb"
export DEBIAN_FRONTEND="noninteractive"
sudo debconf-set-selections <<< "mariadb-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $PASSWORD"
apt-get install mariadb-server mariadb-client -y
echo "Configuration of Mariadb"
cd /home/vagrant
mysql -u root -p"$PASSWORD" < magentoinstall.sql
echo "Installing composer"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer
mkdir -p /var/www
cd /var/www/
wget -q https://github.com/magento/magento2/archive/2.1.3.tar.gz
tar -xzf /var/www/2.1.3.tar.gz
mv magento2-2.1.3/ magento
cd /var/www/magento
echo "Composer install dependencies magento"
composer install -v
cd /home/vagrant
echo "Removing default nginx configuration"
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
echo "Install nginx magento config"
cp /home/vagrant/magento.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/magento.conf /etc/nginx/sites-enabled/
echo "Restarting nginx"
service nginx restart
echo "Installing Magento2"
/var/www/magento/bin/magento setup:install --backend-frontname="admin" \
--key="biY8vdWx4w8KV5Q59380Fejy36l6ssUb" \
--db-host="localhost" \
--db-name="magentodb" \
--db-user="magento" \
--db-password="septimo" \
--language="en_US" \
--currency="USD" \
--timezone="America/New_York" \
--use-rewrites=1 \
--use-secure=0 \
--base-url="http://testmagento.org" \
--base-url-secure="https://testmagento.org" \
--admin-user=admin \
--admin-password=ABCdefg123! \
--admin-email=admin@testmagento.org \
--admin-firstname=admin \
--admin-lastname=user \
--cleanup-database
echo "Configuring website permissions"
chmod 700 /var/www/magento/app/etc
chown -R www-data:www-data /var/www/magento
echo "Restarting nginx"
service nginx restart
