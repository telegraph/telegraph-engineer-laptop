#!/bin/bash
source config

# curl -u admin:admin \
# -X POST "uk.co.telegraph.core.commons.indexing." \
# http://localhost:4502/system/console/configMgr/com.adobe.cq.deserfw.impl.DeserializationFirewallImpl


# curl -u admin:admin \
# -X POST -H "Content-Type: application/json" \
# -d deserialisation_settings.json \
# http://localhost:4502/system/console/configMgr/com.adobe.cq.deserfw.impl.DeserializationFirewallImpl
# # curl -X POST -F 'username=davidwalsh' -F 'password=something' http://domain.tld/post-to-me.php

echo "****************************************************************************************************************"
echo "*                                                                                                              *"
echo "* Please read the instuctions from confluence from section 5.6, to 'Set Whitelisted classes (author / publish)'*"
echo "* I've openned the pages for you, but essentially you need to add the following to the whiltelist              *"
echo "* Include the '.'                                                                                              *"
echo "* ADD following packages at the end 'Whitelisted classes or packages prefixes' list:                           *"
echo "*      uk.co.telegraph.core.author.api.model.                                                                  *"
echo "*      uk.co.telegraph.core.author.webservice.model.                                                           *"
echo "*      uk.co.telegraph.core.commons.indexing.                                                                  *"
echo "*                                                                                                              *"
echo "****************************************************************************************************************"

open https://confluence.aws.telegraph.co.uk/display/AEM/Developer+Setup+-++AEM+6.2+To+AEM+6.4
open http://localhost:4502/system/console/configMgr/com.adobe.cq.deserfw.impl.DeserializationFirewallImpl

echo ""
read -p "Press enter to continue"
