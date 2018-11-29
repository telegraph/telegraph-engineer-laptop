#!/bin/bash

#################################################################################################
# Open http://localhost:<PORT>/system/console/configMgr
# Search for "Apache Sling DavEx Servlet", and click on it to open properties dialog box
# Set Root Path value /crx/server and click Save
# Now open /system/console/components page and search for following component:
#   org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet
# Make sure this component is in active state
# Now you should be able to login and view repository tree

# seems to be enabled and cannot find command line settings so 
# have not scripted to instructions above
# Step 4 - Enable CRX/DE
# Author:4502	
# curl -u admin:admin \
# -F "jcr:primaryType=sling:OsgiConfig" \
# -F "alias=/crx/server" \
# -F "dav.create-absolute-uri=true" \
# -F "dav.create-absolute-uri@TypeHint=Boolean" \
# http://localhost:4502/apps/system/config/org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet

# # Publish:4503	
# curl -u admin:admin \
# -F "jcr:primaryType=sling:OsgiConfig" \
# -F "alias=/crx/server" 
# -F "dav.create-absolute-uri=true" \
# -F "dav.create-absolute-uri@TypeHint=Boolean" \
# http://localhost:4503/apps/system/config/org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet

# Author 
curl -u admin:admin -F "jcr:primaryType=sling:OsgiConfig" -F "alias=/crx/server" -F "dav.create-absolute-uri=true" -F "dav.create-absolute-uri@TypeHint=Boolean" http://localhost:4502/apps/system/config/org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet
# Publish
curl -u admin:admin -F "jcr:primaryType=sling:OsgiConfig" -F "alias=/crx/server" -F "dav.create-absolute-uri=true" -F "dav.create-absolute-uri@TypeHint=Boolean" http://localhost:4503/apps/system/config/org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet