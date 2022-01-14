#!/bin/bash
#
# Author: Onur Akan
# weblogic-configuration.sh
#

#============================================================================
# Check Parameters
#============================================================================
MY_ORACLE_HOME=$1
MY_DOMAIN_NAME=$2
OTHER_DOMAIN_PATH=$3
STEP_STRING=$4

if [ -z $MY_ORACLE_HOME ]; then
	echo "1. parameter of batch not set. MY_ORACLE_HOME is expected. Example: /Users/ttoakan/Dev/tools/weblogic12c/ORACLE_HOME"
	exit 1
fi

if [ -z $MY_DOMAIN_NAME ]; then
	echo "2. parameter of batch not set. MY_DOMAIN_NAME is expected. Example: MY-STB-DMN"
	exit 1
fi

if [ -z $OTHER_DOMAIN_PATH ]; then
	echo "3. parameter of batch not set. OTHER_DOMAIN_PATH is expected. This is a sample domain that you can copy some files from"
	exit 1
fi

if [ -z $STEP_STRING ]; then
	echo "4. parameter of batch not set. STEP_STRING is expected. Example: 012345"
	exit 1
fi

#============================================================================
# Set constants
#============================================================================
MY_INSTALLER_PATH=fmw_12.2.1.4.0_wls_quick.jar
MY_DOMAIN_PATH=$MY_ORACLE_HOME/wls12214/user_projects/domains/$MY_DOMAIN_NAME
cwd=$(pwd)

#============================================================================
# Functions
#============================================================================
main () {
	clear
	echo -e "\n>>create_domain.sh ::: Starting create_domain.sh"
	if step_string_contains 0; then create_weblogic_server 0; fi
	if step_string_contains 1; then create_domain 1; fi
	if step_string_contains 2; then copy_statics 2; fi
	if step_string_contains 3; then replace_link 3; fi
	if step_string_contains 4; then copy_jdbc_xmls 4; fi #depracated. jdbcs are created, not copied anymore.
	if step_string_contains 5; then create_config_copy_xml 5; fi
	if step_string_contains 6; then rollback_config_xml 6; fi
	if step_string_contains 7; then add_realm_to_config_xml 7; fi
	if step_string_contains 8; then	add_standart_definitions_to_config_xml 8; fi
	echo -e "\n>>create_domain.sh ::: Finished create_domain.sh \n"
}

create_weblogic_server () {
	echo ">>create_domain.sh ::: $1-Starting to Create Weblogic Server in : " $MY_ORACLE_HOME

	#export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
	rm -Rf $MY_ORACLE_HOME
	mkdir -p $MY_ORACLE_HOME
	cd $MY_ORACLE_HOME
	pwd
	echo ">>create_domain.sh ::: $1-Deleted previous Weblogic Server in : " $MY_ORACLE_HOME

	java -jar $MY_INSTALLER_PATH

	cd $cwd
	pwd

	echo -e "\n"
}

create_domain () {
	echo ">>create_domain.sh ::: $1-Creating domain in : " $MY_DOMAIN_PATH
	
	$MY_ORACLE_HOME/wls12214/oracle_common/common/bin/wlst.sh ./create_domain.py "$MY_ORACLE_HOME/wls12214/user_projects/domains" $MY_DOMAIN_NAME
	cp $OTHER_DOMAIN_PATH/config/config.xml $MY_DOMAIN_PATH/config/config_other_domain.xml 

	echo -e "\n"
}

copy_statics () {
	echo ">>create_domain.sh ::: $1-Copying statics"
	cp -R $OTHER_DOMAIN_PATH/autodeploy/static $MY_DOMAIN_PATH/autodeploy/static
	echo -e "\n"
}

replace_link () {
	echo ">>create_domain.sh ::: $1-Replacing http://hostname:port/console to http://my.onurakan.com.tr:7001/console "
	sed -i -e 's;http:\/\/hostname:port\/console;http:\/\/my.onurakan.com.tr:7001\/console;g' $MY_DOMAIN_PATH/bin/startWebLogic.sh
	echo -e "\n"
}

#depracated
#no need to copy. new version of sciprt autocreates datasources.
copy_jdbc_xmls () {
#	echo ">>create_domain.sh ::: $1-Copying jdbc"
#	cp -R $OTHER_DOMAIN_PATH/config/jdbc $MY_DOMAIN_PATH/config/
#	echo -e "\n"
}

create_config_copy_xml () {
	echo ">>create_domain.sh ::: $1-Create config_copy.xml"
	cp $MY_DOMAIN_PATH/config/config.xml $MY_DOMAIN_PATH/config/config_backup.xml 
	echo -e "\n"
}

rollback_config_xml () {
	echo ">>create_domain.sh ::: $1-Recovering from config_backup.xml to config.xml"
	cp $MY_DOMAIN_PATH/config/config_backup.xml $MY_DOMAIN_PATH/config/config.xml
	echo -e "\n"
}

add_realm_to_config_xml () {
	echo ">>create_domain.sh ::: $1-Adding realm to config.xml."

	line=7
	fileToInsert="create_domain_Realm.txt"
	sed -i -e "${line}r $fileToInsert" $MY_DOMAIN_PATH/config/config.xml
	echo -e "\n"
}

add_standart_definitions_to_config_xml () {
	echo ">>create_domain.sh ::: $1-Adding app-deployment, library, web-app-container, startup-class and jdbc-system-resource to config.xml :"
	
	sed -i '' '/  <admin-server-name>AdminServer<\/admin-server-name>/d' $MY_DOMAIN_PATH/config/config.xml
	line=58
	fileToInsert="create_domain_replace_admin-server-name.txt"
	sed -i -e "${line}r $fileToInsert" $MY_DOMAIN_PATH/config/config.xml
	echo -e "\n"
}

step_string_contains () {
	if [[ $STEP_STRING == *$1* ]]; then
		return 0;
	fi
	return 1;
}

#============================================================================
# Run script
#============================================================================
main;

exit 0
