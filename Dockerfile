FROM jenkinsci/blueocean:latest
#$docker build --no-cache  -t jenkins_automate .
#$docker run --name docker_jenkins -itd -v /var/run/docker.sock:/var/run/docker.sock -p 1111:8080 -p 50000:50000 jenkins_automate


# Setting up environment variables for Jenkins admin user
# Variables are used in this file "./jenkins_config/default-user.groovy"
ENV JENKINS_USER admin
ENV JENKINS_PASS admin


# Skip the initial setup wizard
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false"

# Jenkins will be available at http://localhost:1111/jenkins
ENV JENKINS_OPTS "$JENKINS_OPTS --prefix=/jenkins"

# Start-up scripts to set number of executors, default is 2, we set 5 
COPY ./jenkins_config/executors.groovy /usr/share/jenkins/ref/init.groovy.d/

#and creating the admin user
COPY ./jenkins_config/default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

#enable csrf in global security
copy ./jenkins_config/configure-csrf-protection.groovy /usr/share/jenkins/ref/init.groovy.d/

# Configuring Content Security Policy to show html reports with css and js inside Jenkins Server 
COPY ./jenkins_config/csp.groovy /usr/share/jenkins/ref/init.groovy.d/

# Name the jobs  
ARG job_name_1="sample-maven-job"
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}/latest/  
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}/builds/1/

# Add the custom configs to the container  
#COPY ${job_name_1}_config.xml "$JENKINS_HOME"/jobs/${job_name_1}/config.xml  

COPY ./jenkins_config/${job_name_1}_config.xml /usr/share/jenkins/ref/jobs/${job_name_1}/config.xml
#WARNING: JENKINS-2111 path sanitization ineffective when using legacy Workspace Root Directory ‘${ITEM_ROOTDIR}/workspace’; switch to ‘${JENKINS_HOME}/workspace/${ITEM_FULL_NAME}’ as in JENKINS-8446 / JENKINS-21942


#copy credentials into docker container
COPY ./jenkins_config/credentials.xml /usr/share/jenkins/ref/


#check current user in docker container
RUN id

#Switch user to root
USER root

#update alpine
RUN apk update

#Install last version of docker
RUN curl https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz | tar xvz -C /tmp/ && mv /tmp/docker/docker /usr/bin/docker

#Install 1.27.2 version of docker compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.27.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod 755 /usr/local/bin/docker-compose

# Add user jenkins inside group "root"
 RUN adduser jenkins root
#------ Reason -----
# need to run docker client under jenkins user and connect to docker host 
#$docker exec -it docker_jenkins bash
#$docker info

#can see that user jenkins does not have permission to run "docker info"
#$ls -all /var/run/docker.sock

#can see that only user=root and group=root have RW permission

# Switch back to user jenkins
USER jenkins
