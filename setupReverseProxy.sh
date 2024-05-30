#!/bin/bash
sudo systemctl start jenkins
sudo systemctl status jenkins
# sudo cat /var/lib/jenkins/secrets/initialAdminPassword

sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl status nginx
sudo enable nginx

echo "nginx installed"
