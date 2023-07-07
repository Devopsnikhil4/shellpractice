#!/bin/bash

#AMI_ID="ami-0c1d144c8fdd8d690"

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' |sed -e 's/"//g')

echo "AMI ID is used to launch the EC2 is \e[32m $AMI_ID" \e"[0m"