# export GITHUB_SSH_PRIVATE_KEY=$(cat /tmp/gitsecret.txt)

# Store environment variables in /etc/environment
# sudo sh -c "echo 'GITHUB_SSH_PRIVATE_KEY=${GITHUB_SSH_PRIVATE_KEY}' > /etc/environment"
sudo sh -c "echo 'DOCKER_USERNAME=${DOCKER_USERNAME}' >> /etc/environment"
sudo sh -c "echo 'DOCKER_PASSWORD=${DOCKER_PASSWORD}' >> /etc/environment"
sudo mkdir -p /etc/jenkins
# sudo sh -c "echo '${GITHUB_SSH_PRIVATE_KEY}' >> /etc/jenkins/github_ssh_key"
sudo sh -c "echo '${DOCKER_USERNAME}' >> /etc/jenkins/dockerUsername"
sudo sh -c "echo '${DOCKER_PASSWORD}' >> /etc/jenkins/dockerPassword"
sudo sh -c "echo '${PERSONAL_PAT}' >> /etc/jenkins/github_pat"
sudo sh -c "echo '${USER_GIT}' >> /etc/jenkins/github_username"
# sudo echo "${GITHUB_SSH_PRIVATE_KEY}" > /var/lib/jenkins/github_ssh_key
# sudo echo "${DOCKER_USERNAME}" > /var/lib/jenkins/dockerUsername
# sudo echo "${DOCKER_PASSWORD}" > /var/lib/jenkins/dockerPassword
sudo mkdir -p /var/lib/jenkins/init.groovy.d
sudo mv /tmp/*.groovy /var/lib/jenkins/init.groovy.d/
# mv /tmp/config/jenkins /etc/sysconfig/jenkins
sudo chmod +x /tmp/config/install_plugins.sh
sudo mkdir -p /var/lib/jenkins/plugins
sudo chown -R jenkins:jenkins /var/lib/jenkins/plugins
sudo bash /tmp/config/install_plugins.sh
sudo service jenkins start
sudo mkdir -p /var/lib/jenkins/init.groovy.d
sudo chown jenkins:jenkins /var/lib/jenkins/init.groovy.d/
