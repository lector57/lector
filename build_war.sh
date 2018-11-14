#!/bin/bash

clear
WORK_DIR="/root/test"
PROPERTIES_FILE="gradle.properties"
APACHE_HOST="192.168.0.10"
NEXUS_HOST="192.168.0.10"

cd $WORK_DIR

./gradlew task increment
./gradlew build
if [ -f $PROPERTIES_FILE ]; then
  while read LINE
    do
      if [[ "$LINE" =~ .*"versionapp"*. ]]; then
         arrLINE=(${LINE//=/ })
         VER_APP=${arrLINE[1]}
         git tag $VER_APP
      fi
    done < $PROPERTIES_FILE
fi
curl -XPUT -u admin:admin123 -T $WORK_DIR/build/libs/test.war "http://$NEXUS_HOST:8081/nexus/content/repositories/snapshots/task6/$VER_APP/test.war"
cat $PROPERTIES_FILE > /tmp/actual_version
echo "URL = http://$NEXUS_HOST:8081/nexus/content/repositories/snapshots/task6/$VER_APP/test.war" >> /tmp/actual_version
curl -XPUT -u admin:admin123 -T /tmp/actual_version "http://$NEXUS_HOST:8081/nexus/content/repositories/snapshots/task6/actual_version"
curl -XPUT -u admin:admin123 -T $WORK_DIR/build_war.sh "http://$NEXUS_HOST:8081/nexus/content/repositories/snapshots/task6/build_war.sh"


