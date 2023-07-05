#!/bin/bash

COMPONENT=redis
source components/common.sh

echo -e "****** \e[34m $COMPONENT Instatllation is Started \e[0m******"

echo -n "Configuring $COMPONENT repo :"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>> INandOUT
status $?

echo -n "Installing redis :"
yum install redis-6.2.11 -y  &>> INandOUT
status $?