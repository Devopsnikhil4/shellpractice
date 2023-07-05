#!/bin/bash

COMPONENT=catalogue
INandOUT="/tmp/${COMPONENT}.log"
APPUSER="roboshop"

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

echo -e "****** \e[34m $COMPONENT Instatllation is Started \e[0m******"

echo -n "Configuring $COMPONENT repo :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> INandOUT
status $?

echo -n "Installing the nodejs :"
yum install nodeJS -y &>> INandOUT
status $?

id $APPUSER
if [ $? ne 0 ] ; then
echo -n "creating the user account roboshop  :"
useradd $APPUSER
status $?
fi




