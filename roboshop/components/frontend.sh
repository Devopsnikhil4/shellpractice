#!/bin/bash

COMPONENT=frontend
ID=$(id -u)

if [ $ID -ne 0 ] ; then
   echo -e "\e[31m This script is expected to be run by a root user or with a sudo privilage \e[0m"
   exit 1
fi

echo "Installing Nginx :"
yum install nginx -y &>> "/tmp/${COMPONENT}.log"

if [ $? -eq 0 ] ; then
    echo -n "\e[32m success \e[0m"
    exit 1
else
    echo -n "\e[31m failure \e[0m"
fi