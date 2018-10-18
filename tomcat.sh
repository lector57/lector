#!/bin/bash

yum install -y tomcat tomcat-webapps tomcat-admin-webappsmc
mkdir /usr/share/tomcat/webapps/test
echo $2 > /usr/share/tomcat/webapps/test/index.html

if ! [ -f /vagrant/tomcat_name ]; then
  touch /vagrant/tomcat_name
fi

if ! [ -f /vagrant/tomcat_ip ]; then
  touch /vagrant/tomcat_ip
fi

echo $1 >> /vagrant/tomcat_ip
echo $2 >> /vagrant/tomcat_name

systemctl enable tomcat
systemctl start tomcat