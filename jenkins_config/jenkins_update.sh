#!/bin/bash
# Description: Update all installed Jenkins plugins
# Version 1.0

_JENKINS_URL=http://docker-jenkins:8080/jenkins
_JENKINS_USER=admin
_JENKINS_PASSWD=admin

#test command
#java -jar jenkins-cli.jar -s "http://docker-jenkins:8080/jenkins" -auth admin:admin -noKeyAuth install-plugin $(java -jar ./jenkins-cli.jar -s "http://docker-jenkins:8080/jenkins" -auth admin:admin -noKeyAuth list-plugins| awk '{ print $1 }')



#copy file to tmp
cd /
cp -n ./var/jenkins_home/war/WEB-INF/jenkins-cli.jar /tmp
cd /tmp
java -jar jenkins-cli.jar -s "$_JENKINS_URL" -auth "$_JENKINS_USER:$_JENKINS_PASSWD" -noKeyAuth list-plugins|  grep -e ')$' | awk '{ print $1 }'| while read _UPDATE_LIST;
do
echo "Starting to install plugin: "$_UPDATE_LIST;
java -jar jenkins-cli.jar -s "$_JENKINS_URL" -auth "$_JENKINS_USER:$_JENKINS_PASSWD" -noKeyAuth install-plugin "$_UPDATE_LIST";
sleep 10;
done

if [ -z "$_UPDATE_LIST" ] ;
then
    echo "Nothing to do, all plugins are updated";
else
    java -jar jenkins-cli.jar -s "$_JENKINS_URL" -auth "$_JENKINS_USER:$_JENKINS_PASSWD" -noKeyAuth safe-restart;
    echo "Following plugins was updated \$_JENKINS_URL";
fi
