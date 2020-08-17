#!/bin/bash
newPASSWD='123456'
wget http://repo.mysql.com//mysql57-community-release-el7-7.noarch.rpm 
yum localinstall mysql57-community-release-el7-7.noarch.rpm -y 
yum install mysql-community-server MySQL-python -y
systemctl enable mysqld
systemctl start mysqld 
oldPASSWD=`cat /var/log/mysqld.log | grep password | awk '{ print $NF }' | head -n 1`
mysql -uroot -p$oldPASSWD --connect-expired-password -e "set global validate_password_policy=0;"
mysql -uroot -p$oldPASSWD --connect-expired-password -e "set global validate_password_length=1;"
mysql -uroot -p$oldPASSWD --connect-expired-password -e "SET PASSWORD = PASSWORD('$newPASSWD');ALTER USER 'root'@'localhost' PASSWORD EXPIRE NEVER;flush privileges;"
mysql -uroot -p$newPASSWD -e "use mysql;update user set host='%' where user='root';"
mysql -uroot -p$newPASSWD -e "flush privileges;"
