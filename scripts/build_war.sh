#!/bin/bash

clear
PROPERTIES_FILE="/opt/gradle/gradle.properties"
APACHE_HOST_IP="192.168.0.10"
NEXUS_HOST_IP="192.168.0.10"

cd /opt/gradle
./gradlew task increment
./gradlew build
if [ -f $PROPERTIES_FILE ]; then
  while read LINE
    do
      if [[ "$LINE" =~ .*"versionapp"*. ]]; then
         arrLINE=(${LINE//=/ })
         VER_APP=${arrLINE[1]}
      fi
    done < $PROPERTIES_FILE
fi
curl -XPUT -u admin:admin123 -T /opt/gradle/build/libs/gradle.war "http://$NEXUS_HOST_IP:8081/nexus/content/repositories/snapshots/task6/$VER_APP/test.war"
cat $PROPERTIES_FILE > /tmp/actual_version
echo "URL = http://$NEXUS_HOST_IP:8081/nexus/content/repositories/snapshots/task6/$VER_APP/test.war" >> /tmp/actual_version
curl -XPUT -u admin:admin123 -T /tmp/actual_version "http://$NEXUS_HOST_IP:8081/nexus/content/repositories/snapshots/task6/actual_version"
curl -XPUT -u admin:admin123 -T ~/build_war.sh "http://$NEXUS_HOST_IP:8081/nexus/content/repositories/snapshots/task6/build_war.sh"


