#!/bin/bash
# Actualitzem repositoris
apt-get update
# Instal·lacio apache
apt-get install -y apache2

apt-get install -y php libapache2-mod-php php-mysql
# Reiniciem Apache
sudo systemctl restart apache2
cd /var/www/html
# Descarreguem adminer
wget https://github.com/vrana/adminer/releases/download/v4.3.1/adminer-4.3.1-mysql.php
mv adminer-4.3.1-mysql.php adminer.php
# Apt get update, actualitzem repositoris
apt-get update
# Instal·lacio debconf
apt-get -y install debconf-utils
# Assignacio contrasenya
DB_ROOT_PASSWD=root
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"
# Instal·lacio mysql server
apt-get install -y mysql-server
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
# Reiniciem mysql
sudo systemctl restart mysql
# Assignem la contrasenya root de mysql
mysql -uroot mysql -p$DB_ROOT_PASSWD <<< "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '$DB_ROOT_PASSWD'; FLUSH PRIVILEGES;"
# Data base  de prova
mysql -uroot mysql -p$DB_ROOT_PASSWD <<< "CREATE DATABASE prova;"
