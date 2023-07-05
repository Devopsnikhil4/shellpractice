#!/bin/bash


COMPONENT="catalogue"

source components/common.sh

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

echo -n "Downloading the $COMPONENT zip file :"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
status $?

echo -n "copying the $COMPONENT to $APPUSER home directory :"
cd /home/$APPUSER
rm -rf $COMPONENT &>> INandOUT
unzip -o /tmp/catalogue.zip &>> INandOUT
status $?

echo -n "Moving the $COMPONENT-main to $COMPONENT :"
mv $COMPONENT-main $COMPONENT
status $?

echo -n "npm install in $COMPONENT :"
cd /home/$APPUSER/$COMPONENT
npm install  &>> INandOUT
status $?

echo -n "Updatating the systemD file from MONGO_DNSNAME to mongodb.$APPUSER.internal :"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
status $?

echo -n "Starting the ${COMPONENT} service :"
systemctl daemon-reload       &>> INandOUT
systemctl enable $COMPONENT   &>> INandOUT
systemctl restart $COMPONENT  &>> INandOUT
status $?

echo -e "****** \e[34m $COMPONENT Instatllation is Completed \e[0m******"







