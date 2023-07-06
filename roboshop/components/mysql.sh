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
systemctl enable mysqld &>> INandOUT
systemctl start mysqld &>> INandOUT
status $?

echo -n "Fetching the default root password by using root grep|awk :"
DEFAULT_ROOT_PASSWORD=$(grep 'temporary password'  /var/log/mysqld.log | awk '{print $NF}')
status $?

echo "show databases;" | mysql -uroot -pRoboShop@1 &>> INandOUT
 if [ $? -ne 0 ] ; then
    echo -n "Perfoming password reset of root user :"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p$DEFAULT_ROOT_PASSWORD &>> INandOUT
    status $?
fi

echo "show plugins;" | mysql -uroot -pRoboShop@1 | grep validate_password &>> INandOUT
 if [ $? -eq 0 ] ; then
    echo -n "Uninstalling the validate_password plugin :"
    echo "UNINSTALL PLUGIN validate_password;" | mysql mysql -uroot -pRoboShop@1 &>> INandOUT
    status $?
fi

