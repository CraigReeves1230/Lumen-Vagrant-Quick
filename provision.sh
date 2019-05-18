#!/usr/bin/env bash

echo "-- Updating Apt-Get --"
sudo apt-get update

echo "-- Installing PostgreSQL --"
sudo apt-get -y install wget postgresql postgresql-contrib
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"

echo "-- Installing node, git, Java and other dependencies --"
sudo apt-get -y install nodejs-legacy vim lsof git-core default-jre curl zlib1g-dev build-essential
libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev
python-software-properties libffi-dev

echo "-- Installing Redis --"
sudo apt-get update
sudo apt-get -y install build-essential tcl
cd /tmp
curl -O http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz
cd redis-stable
make
sudo make install

echo "-- Installing NGinX --"
sudo apt-get install -y nginx
sudo ufw allow 'Nginx HTTP'

echo "-- Installing PHP --"
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt install -y php7.3-fpm php7.3-mbstring php7.3-xml php7.3-mysql php7.3-fpm php7.3-common php7.3-gd php7.3-json php7.3-cli php7.3-curl php-zmq php-apcu php-memcached \
php-solr php-mongodb php7.3-bcmath php7.3-pgsql unzip php7.3-dev php7.3- php7.3-opcache php-zmq php-stomp php-imagick php7.3-zip php-pear php7.3-dev php-mongodb

echo "-- Installing BeanstalkD --"
sudo apt-get -y install beanstalkd
sudo apt-get -y install cron

echo "-- Install PHP Redis --"
cd /
sudo apt-get -y install gcc make autoconf libc-dev pkg-config
cd /tmp
sudo wget https://github.com/phpredis/phpredis/archive/master.zip -O phpredis.zip
sudo unzip -o /tmp/phpredis.zip && mv /tmp/phpredis-* /tmp/phpredis && cd /tmp/phpredis && phpize && ./configure && make && sudo make install
sudo touch /etc/php/7.3/mods-available/redis.ini && echo extension=redis.so > /etc/php/7.3/mods-available/redis.ini
sudo ln -s /etc/php/7.3/mods-available/redis.ini /etc/php/7.3/fpm/conf.d/redis.ini
sudo ln -s /etc/php/7.3/mods-available/redis.ini /etc/php/7.3/cli/conf.d/redis.ini
sudo apt -y install php7.3-bcmath
sudo ./configure --enable-redis-igbinary
sudo service php7.3-fpm restart

echo "-- Install and Start Laravel --"
cd /vagrant

# composer install
sudo wget https://getcomposer.org/download/1.6.3/composer.phar
sudo chmod 755 composer.phar
sudo mv composer.phar /usr/local/bin/composer

#Install Laravel
cd /vagrant
composer install

sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/nginx.conf
sudo ln -s /vagrant/nginx-default /etc/nginx/sites-available/default
sudo ln -s /vagrant/nginx-config /etc/nginx/nginx.conf
sudo fuser -k 80/tcp
sudo service nginx restart
sudo service nginx reload
sudo cp preset-env .env
sudo rm preset-env
cd ..
sudo chown -R www-data /vagrant
sudo chmod -R 777 /vagrant/storage

echo "-- Provisioning Complete! You will need perform your first migration. --"





