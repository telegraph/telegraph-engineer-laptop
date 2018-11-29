#!/bin/bash
source config

# 2. Build And Deploy Telegraph Component using Maven	
cd "$AEM_PROJECT_HOME"
if [ ! -d "$AEM_PROJECT_HOME/$AEM_CORE" ]; then
  # Clone the repo
  git clone git@github.com:telegraph/aem-core.git
fi 

# Go to root of project
cd "$AEM_PROJECT_HOME/$AEM_CORE"
if [ $? = 1 ]; then
  echo "Cannot navigate to $AEM_PROJECT_HOME/$AEM_CORE folder. Exiting..."
  exit 1
fi

# Make sure we have the latest
git stash
git pull

# Checkout branch "develop"
git checkout develop

# Build the project
mvn clean install
# mvn clean install -Pfast # ...skips the tests
 
# Deploy to AEM author
mvn crx:install -Dinstance.url=http://localhost:4502 -Dinstance.password=admin
 
# Deploy to AEM publish
mvn crx:install -Dinstance.url=http://localhost:4503 -Dinstance.password=admin
#cd "$AEM_PROJECT_HOME"
