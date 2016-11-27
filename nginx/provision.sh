apt-get update -y

apt-get install -y nginx

rm -rf /etc/nginx/sites-enabled
cp -r /vagrant/sites-enabled /etc/nginx

service nginx start