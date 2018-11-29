#!/bin/bash
source config

# 2. Build And Deploy Telegraph Component using Maven	
cd "$AEM_PROJECT_HOME"
if [ ! -d "$AEM_PROJECT_HOME/$AEM_AUTHOR" ]; then
  # Clone the repo
  git clone git@github.com:telegraph/aem-author.git
fi 

# Go to root of project
cd "$AEM_PROJECT_HOME/$AEM_AUTHOR"
if [ $? = 1 ]; then
  echo "Cannot navigate to $AEM_PROJECT_HOME/$AEM_AUTHOR folder. Exiting..."
  exit 1
fi

# Make sure we have the latest
git stash
git pull

# Checkout branch "develop"
git checkout develop

# Build the project (must specify the settings file)
mvn clean install -s settings.xml
 
# Deploy to AEM author
mvn crx:install -Dinstance.url=http://localhost:4502 -Dinstance.password=admin

cd "$AEM_PROJECT_HOME"

