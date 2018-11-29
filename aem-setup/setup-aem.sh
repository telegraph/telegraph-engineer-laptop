#!/bin/bash
# Script to setup a new instance of AEM, or update an existing one
# Confluence page for 6.4 is located here: https://confluence.aws.telegraph.co.uk/display/AEM/Developer+Setup+-++AEM+6.2+To+AEM+6.4
# Step numbers refer to this document

# settings
source config

# Get parameters from the user to see what they want to do
while getopts s:u:c:f option
do
  case "${option}"
    in
    s) ACTION="setup";;
    u) ACTION="update";;
    c) ACTION="clean";;
    f) ACTION="force";;
  esac
done

echo "action $ACTION"

echo "AEM_PROJECT_HOME folder: $AEM_PROJECT_HOME"
echo "AEM_STACK folder: $AEM_STACK"

echo "AEM_PUBLISH folder: $AEM_PUBLISH"
echo "AEM_AUTHOR folder: $AEM_AUTHOR"

read -p "Press enter to continue"

################################################################################################
# check docker is running
ps cax | grep docker > /dev/null
if [ $? -eq 0 ]; then
  echo "Docker is running. Continuing..."
else
  echo "Docker is not running. Please start docker and wait until it has started before
  continuing"
  exit 1
fi

#################################################################################################
# 1. [OPTIONAL] Remove AEM 6.2 instance (if you are upgrading from 6.2 and want to delete 6.2, 
#     otherwise start from point 2 below.)

# Stop docker regardless of whether reinstalling or not
sh ./01-stop-docker.sh

if [ "$ACTION" == "clean" ]; then 
  sh scripts/01-clean-docker.sh
  # To be used in the extreme case that the above does not work
  # docker-compose down --rmi all --volumes --remove-orphans 
fi 

#################################################################################################
# Step 2 - Install Docker community edition if this is a clean machine.  
# Make sure the memory allocation is 12MB and all CPUs are assigned from the preferences in docker
#################################################################################################
sh scripts/02-refresh-docker.sh

# start AEM and wait until we can set parameters as needed
sh scripts/03-start-aem.sh

# enable crx/de - instructions indicate that the Root Path value /crx/server needs to be 
# from the main page.  seems to be set and enabled
sh scripts/04-enable-crxde.sh

#################################################################################################
# Step 5 - Build and Deploy  Author, Telegraph-component and Ooyala
# 1. Build And Deploy Ooyala using Maven
sh ./05a-build-deploy-ooyala.sh

# 2. Build And Deploy Telegraph Component using Maven	
sh scripts/05b-build-deploy-telegraph-component.sh
	
# 3. Build And Deploy Author using Maven (author only)
# There maybe some warnings like the one below. Ignore them
# ARN* [elasticsearch[Carmilla Black][generic][T#5]] org.elasticsearch.transport.netty [Carmilla Black]
sh scripts/05c-build-deploy-author.sh

# 5. install Elastic Search ServiceMix bundle
sh scripts/05e-install-elasticsearch.sh

# get the user to set whitelist classes
sh scripts/05f-deserialization.sh

