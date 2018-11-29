#!/bin/bash
source config

#make sure we're in the correct folder
cd "$AEM_PROJECT_HOME/$AEM_STACK"
echo "$AEM_PROJECT_HOME/$AEM_STACK folder exists - tearing down AEM docker development environment"
if [ $? = 1 ]; then
  echo "Cannot change to project directory"
  exit 1
else
  pwd
fi

# make sure there is a docker file - this could be a clean machine 
if [ -f docker-compose.yml ]; then
  docker-compose stop --timeout 300
  docker-compose down -v
  # docker volume ls
  # docker volume rm  <volume name>
  # docker volume ls

  # (Optional) Step 1 - Delete all containers
  docker rm $(docker ps -a -q)
  # Delete all images
  docker rmi $(docker images -q)

  # To be used in the extreme caase that the above does not work
  # docker-compose down --rmi all --volumes --remove-orphans 
fi