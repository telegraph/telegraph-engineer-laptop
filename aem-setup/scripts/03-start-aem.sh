#!/bin/bash

source config

# navigate to the correct folder
pushd "$AEM_PROJECT_HOME/$AEM_STACK"
if [ $? = 1 ]; then
  echo "Cannot navigate to $AEM_PROJECT_HOME/$AEM_STACK folder. Exiting..."
  exit 1
fi

# Start Docker
docker-compose pull
docker-compose up -d

###########################################################################################################
# the following instructions from confluence have been replaced with a script borrowed from the platform team
# Tail log files and wait until there are no more messages The error log file currently logs Info messages
#docker exec -it -u root  aem64-author tail -f 500 ./crx-quickstart/logs/error.log

# borrowed and modified from the firstBoot script use for servers
echo "Waiting for author to be ready to apply settings, by testing response"
# The homepage may return empty to begin with
echo Waiting for homepage to come up...
while [ -z $(curl -ILs http://localhost:4502 | head -n 1 | awk '{print $2}') ]
do
  sleep 5s
done

# Actually wait now
echo "Waiting for homepage to come back with Unauthorized..."
while [ $(curl -ILs http://localhost:4502 | head -n 1 | awk '{print $2}') -ne 401 ]
do
  echo "Current response: $(curl -ILs http://localhost:4502 | head -n 1 | awk '{print $2}').... (waiting for 401)"
  sleep 20s
done

echo "Waiting for a blank response homepage"
curl -s http://localhost:4502 >/dev/null
while [ ! -z $(curl -s http://localhost:4502) ]
do
  sleep 15s
done

echo "Waiting for welcome page from Author"

while [ $(curl -u admin:admin -ILs http://localhost:4502/libs/cq/core/content/welcome.html | head -n 1 | awk '{print $2}') -ne 200 ]
do
  echo "Current response from Author: $(curl -u admin:admin -ILs http://localhost:4502/libs/cq/core/content/welcome.html | head -n 1 | awk '{print $2}').... (waiting for 200)"
  sleep 15s
done

echo "Waiting for welcome page from Publisher"

while [ $(curl -u admin:admin -ILs http://localhost:4503/libs/cq/core/content/welcome.html | head -n 1 | awk '{print $2}') -ne 200 ]
do
  echo "Current response from Publisher: $(curl -u admin:admin -ILs http://localhost:4503/libs/cq/core/content/welcome.html | head -n 1 | awk '{print $2}').... (waiting for 200)"
  sleep 15s
done

echo "AEM successfully started"

# back to original folder
popd
