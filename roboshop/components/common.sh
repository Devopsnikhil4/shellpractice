#!/bin/bash

ID=$(id -u)
INandOUT="/tmp/${COMPONENT}.log"
APPUSER="roboshop"


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

CREATE_USER(){

    id $APPUSER &>> INandOUT
    if [ $? -ne 0 ] ; then
        echo -n "Adding the service account :"
        useradd $APPUSER &>> INandOUT
        status $?
    fi   

}

DOWNLOAD_EXTRACT() {
   
    echo -n "Downloading the $COMPONENT zip file :"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
    status $?

    echo -n "copying the $COMPONENT to $APPUSER home directory :"
    cd /home/$APPUSER
    rm -rf $COMPONENT &>> INandOUT
    unzip -o /tmp/$COMPONENT.zip &>> INandOUT
    status $?

    echo -n "Moving the $COMPONENT-main to $COMPONENT :"
    mv $COMPONENT-main $COMPONENT
    status $?

}

NPM_INSTALL() {

    echo -n "npm install in $COMPONENT :"
    cd /home/$APPUSER/$COMPONENT
    npm install  &>> INandOUT
    status $?

}

CONFIGURATION_SVC(){

echo -n "Updatating the $COMPONENT systemd file :"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
status $?

echo -n "Starting the ${COMPONENT} service :"
systemctl daemon-reload       &>> INandOUT
systemctl enable $COMPONENT   &>> INandOUT
systemctl restart $COMPONENT  &>> INandOUT
status $?

echo -e "****** \e[34m $COMPONENT Instatllation is Completed \e[0m******"

}

NODEJS() {
    echo -e "****** \e[34m $COMPONENT Instatllation is Started \e[0m******"

    echo -n "Configuring $COMPONENT repo :"
    curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> INandOUT
    status $?

    echo -n "Installing NodeJs :"
    yum install nodejs -y &>> INandOUT
    status $?

    CREATE_USER        #Creates userid roboshop

    DOWNLOAD_EXTRACT   #Dowloding and extracting the file

    NPM_INSTALL        #creates artifacts

    CONFIGURATION_SVC  #Configuring and starting the service

}

MVN_PACKAGE (){
    echo -n "preparing $COMPONENT artifacts :"
    cd /home/$APPUSER/$COMPONENT
    mvn clean package &>> INandOUT
    mv target/shipping-1.0.jar shipping.jar
    status $?
}

JAVA(){
    echo -e "****** \e[34m $COMPONENT Instatllation is Started \e[0m******"

    echo -n "Installing Maven :"
     yum install maven -y  &>> INandOUT
    status $?

    CREATE_USER        #Creates userid roboshop

    DOWNLOAD_EXTRACT   #Dowloding and extracting the file

}