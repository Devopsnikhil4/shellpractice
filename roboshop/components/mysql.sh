#!/bin/bash

COMPONENT=mysql

source components/common.sh

echo -e "****** \e[34m $COMPONENT Instatllation is Started \e[0m******"

echo -n "Configuring $COMPONENT repo :"
curl -s -L -o /etc/yum.repos.d/$COMPONENT.repo https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/$COMPONENT.repo &>> INandOUT
status $?

echo -n "Installing $COMPONENT :"
yum install mysql-community-server -y    &>> INandOUT
status $?

echo -n "starting the $COMPONENT :"
systemctl enable mysqld
systemctl start mysqld
status $?