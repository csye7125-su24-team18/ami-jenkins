sudo sh -c "echo 'GITHUB_SSH_PRIVATE_KEY=${GITHUB_SSH_PRIVATE_KEY}' > /etc/environment"
sudo sh -c "echo 'DOCKER_USERNAME=${DOCKER_USERNAME}' >> /etc/environment"
sudo sh -c "echo 'DOCKER_PASSWORD=${DOCKER_PASSWORD}' >> /etc/environment"
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
