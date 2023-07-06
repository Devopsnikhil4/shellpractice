#!/bin/bash

COMPONENT="shipping"

source components/common.sh

JAVA

MVN_PACKAGE

CONFIGURATION_SVC

echo -e "****** \e[34m $COMPONENT Instatllation is Completed \e[0m******"