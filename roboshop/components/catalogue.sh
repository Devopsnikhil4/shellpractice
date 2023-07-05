#!/bin/bash

APPUSER="roboshop"
COMPONENT="catalogue"
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

echo -e "****** \e[34m $COMPONENT Instatllation is Started \e[0m******"

echo -n "Configuring $COMPONENT repo :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> INandOUT
status $?

echo -n "Installing NodeJs :"
yum install nodejs -y &>> INandOUT
status $?

id $APPUSER &>> INandOUT
if [ $? -ne 0 ] ; then
    echo -n "Adding the service account :"
    useradd $APPUSER &>> INandOUT
    status $?
fi

ehco -n "Downloading the $COMPONENT zip file :"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip" &>> INandOUT
status $?






