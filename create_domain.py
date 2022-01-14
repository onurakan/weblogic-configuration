#!/usr/bin/python
#
# Author: Onur Akan
# Ref: https://docs.oracle.com/middleware/1221/wls/WLSTG/domains.htm#WLSTG159
#      https://docs.oracle.com/cd/E13196_01/platform/docs81/sp_notes/config-files.html
#      https://oracle-base.com/articles/web/wlst-create-data-source bu calismadi!
#      https://stackoverflow.com/questions/52994929/create-data-source-for-weblogic-12-2-1-3-in-offline-mode
#
#

import time
import getopt
import sys
import re
from create_datasource import createDatasource

domainPath=sys.argv[1] + '/' + sys.argv[2]
domainName=sys.argv[2]

print '>>create_domain.py ::: domainPath= ', domainPath
print '>>create_domain.py ::: domainName= ', domainName

#============================================================================
# Read Template
#============================================================================
#selectTemplate('Base WebLogic Server Domain')
#selectTemplate('WebLogic Advanced Web Services for JAX-RPC Extension')
selectTemplate('Basic WebLogic Server Domain', '12.2.1.3.0')
loadTemplates()

#============================================================================
# Administration Server
#============================================================================
# Set the listen address and listen port for the Administration Server
cd('Servers/AdminServer')
cmo.setName('AdminServer')
set('ListenAddress','')
set('ListenPort', 7001)
 
# Enable SSL on the Administration Server and set the SSL listen address and
# port
create('AdminServer','SSL')
cd('SSL/AdminServer')
set('Enabled', 'False')
set('ListenPort', 7002)

#============================================================================
# User
#============================================================================
# Set the domain password for the WebLogic Server administration user
cd('/')
cd('Security/base_domain/User/weblogic')
cmo.setPassword('weblogic1')


#============================================================================
# Data sources
#============================================================================
dsName='CUSTOMER-DB-DS'
dsJNDIName='CUSTOMER-DB-JNDI'
dsURL='jdbc:oracle:thin:@()'
dsDriver='oracle.jdbc.OracleDriver'
dsUsername='user'
dsPassword='s_user'
dsTargetName='AdminServer'
dsTargetType='Server'

createDatasource(WLS, dsName, dsJNDIName, dsURL, dsDriver, dsUsername, dsPassword, dsTargetName, dsTargetType)

dsName='ORDER-DB-DS'
dsJNDIName='ORDER-DB-JNDI'
dsURL='jdbc:oracle:thin:@()'
dsDriver='oracle.jdbc.OracleDriver'
dsUsername='user'
dsPassword='s_user'
dsTargetName='AdminServer'
dsTargetType='Server'

createDatasource(WLS, dsName, dsJNDIName, dsURL, dsDriver, dsUsername, dsPassword, dsTargetName, dsTargetType)


#============================================================================
# Options
#============================================================================
# If the domain already exists, overwrite the domain
setOption('OverwriteDomain', 'true')

#============================================================================
# Write Domain and Close The Template
#============================================================================
writeDomain(domainPath)
closeTemplate()

exit()