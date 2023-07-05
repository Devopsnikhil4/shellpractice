#!/bin/bash

COMPONENT=frontend
ID=$(id -u)
INandOUT="/tmp/${COMPONENT}.log"


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
yum install nginx -y &>> INandOUT
status $?

echo -n "Dowloading the ${COMPONENT} zip file :"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
status $?

echo -n "cleaning the file deleting the exisisting content in file"
cd /usr/share/nginx/html &>> INandOUT
rm -rf *
status $?

echo -n "Unziping the ${COMPONENT} zip file :"
unzip /tmp/${COMPONENT}.zip  &>> INandOUT
mv ${COMPONENT}-main/* .
mv static/* . &>> INandOUT
rm -rf ${COMPONENT}-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
status $?

echo -n "Starting the ${COMPONENT} service :"
systemctl enable nginx &>> INandOUT
systemctl start nginx &>> INandOUT
status $?

