#!/bin/bash

#AMI_ID="ami-0c1d144c8fdd8d690"

COMPONENT=$1

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' |sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=b54-allow-all | jq '.SecurityGroups[].GroupId' |sed -e 's/"//g')
IpAddress=$(aws ec2 run-instances  --image-id $AMI_ID --instance-type t3.micro --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]" | jq '.Instances[].PrivateIpAddress' |sed -e 's/"//g')

echo -e "AMI ID is used to launch the EC2 is \e[32m $AMI_ID \e[0m"
echo -e "SG ID is used to launch the EC2 is \e[32m $SG_ID \e[0m"

echo -e "\e[34m *****Launch the server*****\e[0m"
echo -e "Private Address of $COMPONENT is \e[35m $IpAddress \e[0m"



    


