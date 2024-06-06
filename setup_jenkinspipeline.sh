#!/bin/bash
sudo touch  /tmp/jenkins_env.sh
GITHUB_SSH_PRIVATE_KEY="$1"
DOCKER_USERNAME="$2"
DOCKER_PASSWORD="$3"
echo "GITHUB_SSH_PRIVATE_KEY='$GITHUB_SSH_PRIVATE_KEY'" > /tmp/jenkins_env.sh
echo "DOCKER_USERNAME='$DOCKER_USERNAME'" >> /tmp/jenkins_env.sh
echo "DOCKER_PASSWORD='$DOCKER_PASSWORD'" >> /tmp/jenkins_env.sh

sudo chmod -R 755 /var/lib/jenkins/init.groovy.d/jenkins.groovy
sudo chmod -R 755 /var/lib/jenkins/init.groovy.d/jenkins_creds.groovy
sudo systemctl daemon-reload
sudo systemctl restart jenkins
