#!/bin/bash

clear
TOMCAT_NODE=$1
APACHE_HOST_IP="192.168.0.10"
NEXUS_HOST_IP="192.168.0.10"
VER_FILE="/tmp/actual_version"
wget -r -O $VER_FILE "http://$NEXUS_HOST_IP:8081/nexus/content/repositories/snapshots/task6/actual_version"
URL_VER=""
VER_APP=""
if [ -f $VER_FILE ]; then
  while read LINE
  do
    if [[ "$LINE" =~ .*"versionapp"*. ]]; then
      STR=$LINE
      arrLINE=(${LINE//=/ })
      VER_APP=${arrLINE[1]}
    fi
    if [[ "$LINE" =~ .*"URL"*. ]]; then
      arrLINE=(${LINE//=/ })
      URL_VER=${arrLINE[1]}
    fi
  done < $VER_FILE
  sudo wget -r -O /usr/share/tomcat/webapps/test.war $URL_VER
  curl "http://$APACHE_HOST_IP/jkmanager?cmd=update&from=list&w=lb&sw=$TOMCAT_NODE&vwa=1"
  curl -XPOST -u admin:admin123 -T ~/pub_war.sh "http://$NEXUS_HOST_IP:8081/nexus/content/repositories/snapshots/task6/pub_war.sh"
  TOMCAT_VERSION=""
  until [[ $TOMCAT_VERSION =~ .*$STR*. ]]
    do
      curl "localhost:8080/test/" > /tmp/tomcat_http_answer
      ping localhost -c 5 -W 1
      while read LINE
        do
          if [[ "$LINE" =~ .*"versionapp"*. ]]; then
            TOMCAT_VERSION=$LINE
          fi
      done < /tmp/tomcat_http_answer
    done
  curl "http://$APACHE_HOST_IP/jkmanager?cmd=update&from=list&w=lb&sw=$TOMCAT_NODE&vwa=0"
fi
