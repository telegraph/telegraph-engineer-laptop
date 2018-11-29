#!/bin/bash
source config

# 5? Check if the Elastic Search ServiceMix bundle is installed if not, install (author only)
# AMS - downloaded with curl
curl http://central.maven.org/maven2/org/apache/servicemix/bundles/org.apache.servicemix.bundles.elasticsearch/1.7.1_1/org.apache.servicemix.bundles.elasticsearch-1.7.1_1.jar  --output org.apache.servicemix.bundles.elasticsearch-1.7.1_1.jar

# AMS - installed with curl
curl -u admin:admin -F action=install -F bundlestartlevel=20 -F bundlefile=@org.apache.servicemix.bundles.elasticsearch-1.7.1_1.jar http://localhost:4502/system/console/bundles

