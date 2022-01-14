# weblogic-configuration
## This project is developed by me in order to automate weblogic installation and domain setup. I had to remove proprietary parts from software
## You can run weblogic-configuration.sh to do the following:
	0 : create_weblogic_server
	1 : create_domain
	2 : copy_statics
	3 : replace_link
	4 : copy_jdbc_xmls
	5 : create_config_copy_xml
	6 : rollback_config_xml
	7 : add_realm_to_config_xml
	8 : add_standart_definitions_to_config_xml

# Prerequisites:
## 1. Download 'Quick Installer intended for Oracle WebLogic Server and Oracle Coherence development only' zip from the link below: 
##      https://www.oracle.com/middleware/technologies/weblogic-server-installers-downloads.html#license-lightbox 
## 2. This link should download fmw_12.## 2.1.4.0_wls_quick_Disk1_1of1.zip
## 3. Unzip this file. weblogic-configuration.sh uses fmw_12.2.1.4.0_wls_quick.jar from this zip in order to install Oracle 12.2.1.4.0.


# sample usage:
## bash$ MY_ORACLE_HOME=/Users/ttoakan/Dev/tools/weblogic12c/ORACLE_HOME
## bash$ MY_DOMAIN_NAME=MY-STB-DMN
## bash$ OTHER_DOMAIN_PATH=/Users/ttoakan/Dev/tools/weblogic12c_macosx/Oracle_Home/user_projects/domains/MY-STB-DMN
## bash$ STEP_STRING=0123467
## bash$ ./weblogic-configuration.sh $MY_ORACLE_HOME $MY_DOMAIN_NAME $OTHER_DOMAIN_PATH $STEP_STRING

## Note that, you can include anyone or more than one step numbers in STEP_STRING in order to do that step.
