#!/bin/bash

#AMI_ID="ami-0c1d144c8fdd8d690"

COMPONENT=$1
HOSTEDZONEID="Z06982071MSU6YCTWUDBT"

if [ -z "$1" ] ; then
    echo -e "\e[31m COMPONENT NAME IS NEEDED \e[0m"
    echo -e "\e[35m EX Usage : \n \t \t bash create-ec2 componentName \e[0m"
    exit 1
fi


AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' |sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=b54-allow-all | jq '.SecurityGroups[].GroupId' |sed -e 's/"//g')
IPADDRESS=$(aws ec2 run-instances  --image-id $AMI_ID --instance-type t3.micro --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]" | jq '.Instances[].PrivateIpAddress' |sed -e 's/"//g')

echo -e "AMI ID is used to launch the EC2 is \e[32m $AMI_ID \e[0m"
echo -e "SG ID is used to launch the EC2 is \e[32m $SG_ID \e[0m"

echo -e "\e[34m *****Launch the server*****\e[0m"
echo -e "Private Address of $COMPONENT is \e[35m $IPADDRESS \e[0m"

echo -e "\e[34m ***** Launching $COMPONENT server is Completed *****\e[0m"

echo -n "\e[34m ***** Creating DNS Record for the $COMPONENT: ***** \e[0m"
sed -e "s/COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${IPADDRESS}/" route53.json > /tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONEID --change-batch file://tmp/record.json






    


