#!/bin/bash

clear
VER_FILE_OF_WAR=$1
DEPLOY_DIR="/root/test/deploy"
NEXUS_HOST="192.168.0.10"
echo $VER_OF_WAR

wget -r -O $DEPLOY_DIR/test.war "http://$NEXUS_HOST:8081/nexus/content/repositories/snapshots/task6/$VER_FILE_OF_WAR/test.war"
