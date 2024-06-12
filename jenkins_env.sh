#!/bin/bash

# Create the /tmp/jenkins_env.sh file with sudo permissions


# Write the GitHub SSH private key to the file
sudo sh -c "echo \"GITHUB_SSH_PRIVATE_KEY='${var.github_ssh_private_key}'\" > /tmp/jenkins_env.sh"

# Append the Docker username to the file
sudo sh -c "echo \"DOCKER_USERNAME='${var.docker_username}'\" >> /tmp/jenkins_env.sh"

# Append the Docker password to the file
sudo sh -c "echo \"DOCKER_PASSWORD='${var.docker_password}'\" >> /tmp/jenkins_env.sh"
