#!/bin/bash

clear
TOMCAT_HOST="192.168.0.10"
CHECK_VER=$1
curl $TOMCAT_HOST:8080/test/ > tomcat_http_answer
URL_VER=""
VER_APP=""
while read LINE
do
  if [[ "$LINE" =~ .*"versionapp"*. ]]; then
    arrLINE=(${LINE//=/ })
    str=${arrLINE[1]}
  fi
done < tomcat_http_answer

VER=(${str//"</p>"/})

if [[ "${VER[0]}" == "$CHECK_VER" ]]
 then
   echo "Web version is correct"
 else
   echo "Web version is not correct"
fi

