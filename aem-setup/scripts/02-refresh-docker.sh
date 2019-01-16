#!/bin/bash
source config

# make sure we have a directory with this name, and navigate to it
if [ ! -d "$AEM_PROJECT_HOME" ]; then
  echo "Making AEM_PROJECT_HOME folder: $AEM_PROJECT_HOME"
  mkdir -p "$AEM_PROJECT_HOME"
fi

cd "$AEM_PROJECT_HOME"
if [ $? = 1 ]; then
  echo "Cannot change to project directory... cancelling"
  exit 1
else
  echo "$AEM_PROJECT_HOME folder exists - setting up AEM development environment using docker"
fi

# If there is no 64 directory, then clone it
cd "$AEM_PROJECT_HOME/$AEM_STACK"
if [ $? = 1 ]; then
  echo "Project folder exists"
else
  # Step 3 - Clone Docker images and create volumes
  git clone ssh://git@bitbucket.aws.telegraph.co.uk:8080/docker/$AEM_STACK.git
fi

# cd "$AEM_PROJECT_HOME/$AEM_STACK"
# if [ $? = 1 ]; then
#   echo "Cannot navigate to $AEM_PROJECT_HOME/$AEM_STACK folder. Exiting..."
#   exit 1
# fi

# otherwise just update with the latest from github
# refresh - even if we've just cloned it
git pull 
git checkout master
