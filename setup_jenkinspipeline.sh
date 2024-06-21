#!/bin/bash
sudo chmod -R 755 /var/lib/jenkins/init.groovy.d/jenkins.groovy
sudo chmod -R 755 /var/lib/jenkins/init.groovy.d/jenkins_creds.groovy
sudo chmod -R 755 /var/lib/jenkins/init.groovy.d/webapp-helm-pipeline.groovy
sudo chmod -R 755 /var/lib/jenkins/init.groovy.d/webapp-pipeline.groovy
sudo chmod -R 755 /var/lib/jenkins/init.groovy.d/infra-pipeline.groovy
sudo systemctl daemon-reload
sudo systemctl restart jenkins
