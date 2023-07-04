#!/bin/bash

COMPONENT=frontend
ID=$(id -u)


if [ $ID -ne 0 ] ; then
   echo -e "\e[31m This script is expected to be run by a root user or with a sudo privilage \e[0m"
   exit 1
fi

status(){
    if [ $? -eq 0 ] ; then
        echo -e "\e[32m success \e[0m"
    else
        echo -e "\e[31m failure \e[0m"
        exit 2
    fi
}

echo -n "Installing Nginx :"
yum install nginx -y &>> "/tmp/${COMPONENT}.log"
status $?

echo -n "Dowloading the frontend zip file :"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
status $?

echo -n "cleaning the file deleting the exisisting content in file"
cd /usr/share/nginx/html "/tmp/${COMPONENT}.log"
rm -rf *
status $?

