# automate_jenkins
<H4>Full Build Automation For Java Application Using Docker Containers</H4>
Automated jenkins container with preconfigured job coming from this tutorial (https://jenkins.io/doc/tutorials/build-a-java-app-with-maven/)
<HR>
<H4>Steps for run:</H4>

1.&nbsp;<code>$docker build --no-cache -t jenkins_automate .</code></BR>
2.&nbsp;<code>$docker run --name docker-jenkins -itd -v /var/run/docker.sock:/var/run/docker.sock -p 1111:8080 -p 50000:50000 jenkins_automate </code></BR>
3.&nbsp;start web browser with folowing url http://localhost:1111/jenkins/blue</BR>
4.&nbsp;user name and password is <b>admin</b></BR>
5.&nbsp;run job "sample-maven-job"</BR>

<H4>Optional:</H4>
for using different time zone you can use
&nbsp;<code>$docker run --name docker-jenkins --env JAVA_OPTS:"-Duser.timezone=Europe/Prague" -itd -v /var/run/docker.sock:/var/run/docker.sock -p 1111:8080 -p 50000:50000 jenkins_automate </code></BR>
