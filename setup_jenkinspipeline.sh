#!/bin/bash
sudo chmod -R 755 /var/lib/jenkins/init.groovy.d/jenkins.groovy
sudo chmod -R 755 /var/lib/jenkins/init.groovy.d/jenkins_creds.groovy
sudo systemctl daemon-reload
sudo systemctl restart jenkins
