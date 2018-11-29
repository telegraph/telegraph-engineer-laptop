#!/bin/bash
source config

#make sure we're in the correct folder
cd "$AEM_PROJECT_HOME/$AEM_STACK"
echo "$AEM_PROJECT_HOME/$AEM_STACK folder exists - stopping AEM docker development environment"
if [ $? = 1 ]; then
  echo "Cannot change to project directory"
  exit 1
else
  pwd
fi

if [ -f docker-compose.yml ]; then
  docker-compose stop --timeout 300
  docker-compose down -v
fi