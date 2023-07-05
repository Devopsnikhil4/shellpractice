#!/bin/bash

COMPONENT=frontend

source components/common.sh

echo -e "****** \e[34m $COMPONENT Instatllation is Started \e[0m******"

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

echo -n "Updating the Backend component reverseproxy  details :"
for component in catalogue user ; do
    sed -i -e "/$component/s/localhost/$component.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
done
status $?

echo -n "Starting the ${COMPONENT} service :"
systemctl daemon-reload     &>> INandOUT
systemctl enable nginx      &>> INandOUT
systemctl restart nginx       &>> INandOUT
status $?

echo -e "****** \e[34m $COMPONENT Instatllation is Completed \e[0m******"