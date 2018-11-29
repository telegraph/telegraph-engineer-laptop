# check and activate commons bundle on author
curl -u admin:admin http://localhost:4502/system/console/bundles/com.adobe.acs.acs-aem-commons-bundle -F action=start 

# check and activate commons bundle on publisher
curl -u admin:admin http://localhost:4503/system/console/bundles/com.adobe.acs.acs-aem-commons-bundle -F action=start 