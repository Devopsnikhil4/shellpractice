#!/bin/bash

ID=$(id -u)
if [ $ID -ne 0 ] ; then
   echo -e "\e[31m This script is expected to be run by a root user or with a sudo privilage \e[0m"
   exit 1
fi

echo "Installing Nginx :"
yum install nginx -y