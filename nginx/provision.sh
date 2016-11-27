apt-get update -y

apt-get install -y nginx

rm -rf /usr/share/nginx/www/
ln -s /vagrant/www /usr/share/nginx/www

service nginx start