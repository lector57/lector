#!/bin/bash

yum install -y mc httpd
cp /vagrant/mod_jk.so /etc/httpd/modules/

FILE_WORKER_PROPERTIES="/etc/httpd/conf/workers.properties"
FILE_CONNECTOR_CONF="/etc/httpd/conf.d/connector.conf"
FILE_TOMCAT_NAME="/vagrant/tomcat_name"
FILE_TOMCAT_IP="/vagrant/tomcat_ip"

if ! [ -f $FILE_WORKER_PROPERTIES ]; then
  i=0
  STR1=""
  STR2="worker.lb.balance_workers="
  
  while read LINE
  do
  STR1+="$LINE "
    if [[ i -ne 0 ]]
      then
      STR2+=" ,$LINE"
    else
      STR2+="$LINE"
      i=$(($i+1))
    fi;
  done < $FILE_TOMCAT_NAME

  IFS=' ' read -ra ADDR <<< $STR1
  echo "worker.list=lb" > $FILE_WORKER_PROPERTIES
  echo "worker.lb.type=lb" >> $FILE_WORKER_PROPERTIES
  echo $STR2 >> $FILE_WORKER_PROPERTIES

  i=0
  while read LINE3
  do
    echo "worker.${ADDR[$i]}.host=$LINE3" >> $FILE_WORKER_PROPERTIES
    echo "worker.${ADDR[$i]}.port=8009" >> $FILE_WORKER_PROPERTIES
    echo "worker.${ADDR[$i]}.type=ajp13" >> $FILE_WORKER_PROPERTIES
    i=$(($i+1))
  done < $FILE_TOMCAT_IP
fi

rm $FILE_TOMCAT_NAME
rm $FILE_TOMCAT_IP

echo "LoadModule jk_module modules/mod_jk.so" > $FILE_CONNECTOR_CONF
echo "JkWorkersFile conf/workers.properties" >> $FILE_CONNECTOR_CONF
echo "JkShmFile /tmp/shm" >> $FILE_CONNECTOR_CONF
echo "JkLogFile logs/mod_jk.log" >> $FILE_CONNECTOR_CONF
echo "JkLogLevel info" >> $FILE_CONNECTOR_CONF
echo "JkMount /test* lb" >> $FILE_CONNECTOR_CONF

systemctl stop firewalld
systemctl enable httpd
systemctl start httpd
