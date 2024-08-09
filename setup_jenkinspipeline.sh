#!/bin/bash
sudo chmod -R 755 /var/lib/jenkins/init.groovy.d/*.grrovy
sudo systemctl daemon-reload
sudo systemctl restart jenkins
