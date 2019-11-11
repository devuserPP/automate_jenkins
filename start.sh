#!/bin/sh
CONTAINER_NAME=docker-jenkins
DOCKER_IMAGE=jenkins_automate:latest
echo my container is $CONTAINER_NAME;

if test ! -z "$(docker images -q ${DOCKER_IMAGE})"; then
  echo "${DOCKER_IMAGE} already exist"
  else
  docker build --no-cache -t ${CONTAINER_NAME} .
fi




if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
echo 'try to remove -' ${CONTAINER_NAME}
docker rm ${CONTAINER_NAME} -f
else
echo 'does not exist' ${CONTAINER_NAME}
fi


docker run --rm -d --name ${CONTAINER_NAME} \
-p 1111:8080 \
-p 50000:50000 \
-v /var/run/docker.sock:/var/run/docker.sock \
jenkins_automate

#"-v jenkins-data:/var/jenkins_home \" does not work