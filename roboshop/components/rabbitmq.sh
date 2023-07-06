#!/bin/bash

COMPONENT="rabbitmq"

source components/common.sh

echo -n "Downloading the $COMPONENT zip file :"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash   &>> INandOUT  
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> INandOUT
status $?

echo -n "Installing $COMPONENT :"
yum install rabbitmq-server -y &>> INandOUT
status $?

echo -n "starting $COMPONENT :"
systemctl enable rabbitmq-server  &>> INandOUT
systemctl restart rabbitmq-server   &>> INandOUT
status $?

echo -n "creating the $COMPONENT $APPUSER :"
if [ $? -ne 0 ] ; then
rabbitmqctl add_user roboshop roboshop123 &>> INandOUT
fi
status $?


echo -n "configuring the $COMPONENT $APPUSER privilages :"
rabbitmqctl set_user_tags roboshop administrator           &>> INandOUT
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"   &>> INandOUT
status $?







