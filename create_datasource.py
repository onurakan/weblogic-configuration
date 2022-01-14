#!/usr/bin/python
#
# Author: Onur Akan
# Ref: https://stackoverflow.com/questions/52994929/create-data-source-for-weblogic-12-2-1-3-in-offline-mode
#
#
import time
import getopt
import sys
import re
from wlstModule import *


def createDatasource(wls, dsName, dsJNDIName, dsURL, dsDriver, dsUsername, dsPassword, dsTargetName, dsTargetType):
  
    # Display the variable values.
    print '>>create_datasource.py ::: dsName=', dsName
    print '>>create_datasource.py ::: dsJNDIName=', dsJNDIName
    print '>>create_datasource.py ::: dsURL=', dsURL
    print '>>create_datasource.py ::: dsDriver=', dsDriver
    print '>>create_datasource.py ::: dsUsername=', dsUsername
    print '>>create_datasource.py ::: dsPassword=', dsPassword
    print '>>create_datasource.py ::: dsTargetType=', dsTargetType
    print '>>create_datasource.py ::: dsTargetName=', dsTargetName

    wls.cd('/')
    wls.create(dsName, 'JDBCSystemResource')
    wls.cd('/JDBCSystemResource/'+dsName)
    wls.set('Target',dsTargetName)
    wls.cd('/JDBCSystemResource/' + dsName + '/JdbcResource/' + dsName)
    wls.cmo.setName(dsName)
    wls.create(dsName,'JDBCDataSourceParams')
    wls.cd('JDBCDataSourceParams/'+dsName)
    wls.set('JNDIName', java.lang.String(dsJNDIName))
    wls.set('GlobalTransactionsProtocol', java.lang.String('OnePhaseCommit'))


    wls.cd('/JDBCSystemResources/' + dsName + '/JdbcResource/' + dsName)
    #create(dsName,'JDBCDriverParams')
    wls.create('dbParams','JDBCDriverParams')
    wls.cd('JDBCDriverParams/NO_NAME_0')
    #cd('JDBCDriverParams/'+ dsName)
    wls.set('DriverName',dsDriver)
    wls.set('URL',dsURL)
    wls.set('PasswordEncrypted', dsPassword)


    wls.create('properties','Properties')
    #cd('Properties/'+dsName)
    wls.cd('Properties/NO_NAME_0')
    wls.create('user','Property')
    wls.cd('Property/user')
    wls.set('Value', dsUsername)

    wls.cd('/JDBCSystemResource/' + dsName + '/JdbcResource/' + dsName)
    wls.create(dsName,'JDBCConnectionPoolParams')
    wls.cd('JDBCConnectionPoolParams/' + dsName)
    wls.set('TestTableName','SQL SELECT 1 FROM DUAL')
    wls.set('InitialCapacity',0)
    wls.set('MaxCapacity',15)
    wls.set('MinCapacity',0)
    wls.set('CapacityIncrement',1)
    wls.set('StatementCacheSize',10)
    wls.set('StatementCacheType','LRU')

    print '\n>>create_datasource.py ::: Created dsName=', dsName
    print '\n'

