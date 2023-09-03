#!/bin/bash

#AMI_ID="ami-0c1d144c8fdd8d690"

COMPONENT=$1
ENV=$2
HOSTEDZONEID="Z05048761Z5DSI3008CTK"

if [ -z "$1" ] || [ -z "$2" ] ; then
    echo -e "\e[31m COMPONENT NAME IS NEEDED \e[0m"
    echo -e "\e[35m EX Usage : \n \t \t bash create-ec2 componentName envName \e[0m"
    exit 1
fi


AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' |sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=b54-allow-all | jq '.SecurityGroups[].GroupId' |sed -e 's/"//g')


create_ec2() {

echo -e "AMI ID is used to launch the EC2 is \e[32m $AMI_ID \e[0m"
echo -e "SG ID is used to launch the EC2 is \e[32m $SG_ID \e[0m"
echo -e "\e[34m *****Launch the server*****\e[0m"

IPADDRESS=$(aws ec2 run-instances  --image-id $AMI_ID --instance-type t3.micro --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT-$ENV}]" | jq '.Instances[].PrivateIpAddress' |sed -e 's/"//g')

echo -e "\e[34m ***** Launching $COMPONENT-$ENV server is Completed *****\e[0m"
echo -e "Private Address of $COMPONENT-$ENV is \e[35m $IPADDRESS \e[0m"

echo -e "\e[34m ***** Creating DNS Record for the $COMPONENT : ***** \e[0m"
sed -e "s/COMPONENT/${COMPONENT}-${ENV}/" -e "s/IPADDRESS/${IPADDRESS}/" route53.json > /tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONEID --change-batch file:///tmp/record.json
echo -e "\e[34m ***** Creating DNS Record for the $COMPONENT has completed : ***** \e[0m \n\n"

}



if [ "$1" = "all" ] ; then
    for  component in frontend mongodb catalogue redis user cart shipping mysql rabbitmq payment ; do
         COMPONENT=$component
         create_ec2
    done

else

    create_ec2

fi    


