#!/bin/bash
source config

#################################################################################################
# 1. Build And Deploy Ooyala using Maven
# Clone the repo if it does not exist
echo "OOYALA HOME is $AEM_PROJECT_HOME/$AEM_OOYALA"
cd "$AEM_PROJECT_HOME"
if [ ! -d "$AEM_PROJECT_HOME/$AEM_OOYALA" ]; then
  git clone git@github.com:telegraph/aem-ooyala.git
fi 

# Go to root of project
cd "$AEM_PROJECT_HOME/$AEM_OOYALA/cq"
if [ $? = 1 ]; then
  echo "Cannot navigate to $AEM_PROJECT_HOME/$AEM_OOYALA folder. Exiting..."
  exit 1
fi

# Make sure we have the latest
git stash
git pull

# Checkout branch "develop"
git checkout develop

# Build the project (must specify the settings file)
mvn clean install -s ../settings.xml

# Deploy to AEM author
mvn crx:install -Dinstance.url=http://localhost:4502 -Dinstance.password=admin

# Deploy to AEM publish
mvn crx:install -Dinstance.url=http://localhost:4503 -Dinstance.password=admin

#cd "$AEM_PROJECT_HOME"

# return to where we were
# popd
