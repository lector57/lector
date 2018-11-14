#!/bin/bash

clear

TOMCAT_NODE=$1
TRY_CHECK_NUM=5
WORK_DIR="/root/test"
APACHE_HOST="192.168.0.10"
NEXUS_HOST="192.168.0.10"
VER_FILE="$WORK_DIR/actual_version"

wget -r -O $VER_FILE "http://$NEXUS_HOST:8081/nexus/content/repositories/snapshots/task6/actual_version"
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
  curl "http://$APACHE_HOST/jkmanager?cmd=update&from=list&w=lb&sw=$TOMCAT_NODE&vwa=1"
  TOMCAT_VERSION=""
  i=0
  until [[ $TOMCAT_VERSION =~ .*$STR*. ]] || [[ i -ge $TRY_CHECK_NUM ]]
    do
      i=$(($i+1))
      curl "localhost:8080/test/" > $WORK_DIR/tomcat_http_answer
      ping localhost -c 5 -W 1
      while read LINE
        do
          if [[ "$LINE" =~ .*"versionapp"*. ]]; then
            TOMCAT_VERSION=$LINE
          fi
      done < $WORK_DIR/tomcat_http_answer
    done
  curl "http://$APACHE_HOST/jkmanager?cmd=update&from=list&w=lb&sw=$TOMCAT_NODE&vwa=0"
  rm $WORK_DIR/tomcat_http_answer
  if [[ i -ge  $TRY_CHECK_NUM ]]; then
     echo "Error deploy War !!!"
  fi
fi
curl -XPOST -u admin:admin123 -T $WORK_DIR/tomcat_deploy.sh "http://$NEXUS_HOST:8081/nexus/content/repositories/snapshots/task6/tomcat_deploy.sh"