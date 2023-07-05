#!/bin/bash

COMPONENT=mongodb

source components/common.sh

echo -e "****** \e[34m $COMPONENT Instatllation is Started \e[0m******"

echo -n "Configuring $COMPONENT repo :"
curl -s -o /etc/yum.repos.d/$COMPONENT.repo https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/mongo.repo
status $?

echo -n "Installing $COMPONENT :"
yum install -y $COMPONENT-org    &>> INandOUT
status $?

echo -n "Updatating the Listen IP in the config file :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
status $?

echo -n "starting the $COMPONENT :"
systemctl daemon-reload mongod   &>> INandOUT
systemctl enable mongod          &>> INandOUT
systemctl restart mongod         &>> INandOUT
status $?

echo -n "Downloading the $COMPONENT schema zipfile :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
status $?

echo -n "Extracting the $COMPONENT schema zipfile :"
cd /tmp
unzip -o $COMPONENT.zip    &>> INandOUT
status $?

echo -n "Injecting the $COMPONENT schema zipfile :"
cd $COMPONENT-main
mongo < catalogue.js &>> INandOUT
mongo < users.js     &>> INandOUT
status $?

echo -e "****** \e[34m $COMPONENT Instatllation is Completed \e[0m******"