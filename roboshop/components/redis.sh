#!/bin/bash

COMPONENT=redis
source components/common.sh

echo -e "****** \e[34m $COMPONENT Instatllation is Started \e[0m******"

echo -n "Configuring $COMPONENT repo :"
curl -L https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/$COMPONENT.repo -o /etc/yum.repos.d/$COMPONENT.repo &>> INandOUT
status $?

echo -n "Installing $COMPONENT :"
yum install $COMPONENT-6.2.11 -y  &>> INandOUT
status $?

