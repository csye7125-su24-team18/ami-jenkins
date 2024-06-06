echo GITHUB_SSH_PRIVATE_KEY=${var.github_ssh_private_key} > /tmp/jenkins_env.sh
echo DOCKER_USERNAME=${var.docker_username} >> /tmp/jenkins_env.sh
echo DOCKER_PASSWORD=${var.docker_password} >> /tmp/jenkins_env.sh
sudo mv /tmp/jenkins.groovy /var/lib/jenkins/init.groovy.d/jenkins.groovy
sudo mv /tmp/jenkins_creds.groovy /var/lib/jenkins/init.groovy.d/jenkins_creds.groovy
sudo chmod -R 755 /var/lib/jenkins/init.groovy.d/jenkins.groovy
sudo chmod -R 755 /var/lib/jenkins/init.groovy.d/jenkins_creds.groovy
sudo systemctl daemon-reload
sudo systemctl restart jenkins
