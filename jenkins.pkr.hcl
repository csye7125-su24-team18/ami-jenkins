packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "region" {
  description = "The AWS region to deploy to."
  default     = "us-east-1"
}

variable "source_ami" {
  description = "The source Ubuntu 24.04 LTS AMI."
  default     = "ami-04b70fa74e45c3917"
}

variable "OS" {
  type        = string
  description = "Base operating system version"
  default     = "Ubuntu"
}

variable "aws-access-key-id" {
  type    = string
  default = env("aws-access-key-id")
}

variable "aws-secret-access-key" {
  type    = string
  default = env("aws-secret-access-key")
}

variable "machine_type" {
  description = "The instance type to use for the build."
  default     = "t2.micro"
}

variable "ssh_username" {
  description = "The SSH username to use."
  default     = "ubuntu"
}

//  variable "github_ssh_private_key" {
//   description = "GitHub SSH private key"
//   default     = " "
//  }

variable "docker_username" {
  description = "Docker username"
  default     = ""
}

variable "docker_password" {
  description = "Docker password"
  default     = ""
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  default     = ""
}

variable "git_user" {
  description = "Git user"
  default     = ""

}


source "amazon-ebs" "jenkins" {
  region          = "${var.region}"
  ami_name        = "jenkins-{{timestamp}}"
  ami_description = "Building Jenkins AMI built with Packer"
  // ami_users       = "${var.ami_users}"
  instance_type = "${var.machine_type}"
  source_ami    = "${var.source_ami}"
  ssh_username  = "${var.ssh_username}"
  ami_regions   = ["${var.region}", ]
  profile       = "infra"
}

build {
  sources = ["source.amazon-ebs.jenkins"]

  provisioner "shell" {
    script = "install_jenkins.sh"
  }
  provisioner "file" {
    source      = "Caddyfile"
    destination = "/tmp/Caddyfile"
  }
  provisioner "shell" {
    script = "install_caddy.sh"
  }

  provisioner "file" {
    source      = "user.groovy"
    destination = "/tmp/user.groovy"
  }

  provisioner "file" {
    source      = "./config"
    destination = "/tmp/"
  }


  provisioner "file" {
    source      = "staticSitePiepline.groovy"
    destination = "/tmp/jenkins.groovy"
  }

  provisioner "file" {
    source      = "MultibranchPipeline.groovy"
    destination = "/tmp/MultibranchPipeline.groovy"
  }
  provisioner "file" {
    source      = "jenkins_creds.groovy"
    destination = "/tmp/jenkins_creds.groovy"
  }


  // provisioner "file"{
  //   source = "gitsecret.txt"
  //   destination = "/tmp/gitsecret.txt"
  // }

  //   provisioner "shell" {
  //   inline = [
  //     "#!/bin/bash",
  //     "sudo touch /tmp/jenkins_env.sh",
  //     "echo \"GITHUB_SSH_PRIVATE_KEY='${var.github_ssh_private_key}'\" > /tmp/jenkins_env.sh",
  //     "echo \"DOCKER_USERNAME='${var.docker_username}'\" >> /tmp/jenkins_env.sh",
  //     "echo \"DOCKER_PASSWORD='${var.docker_password}'\" >> /tmp/jenkins_env.sh",
  //   ]
  // }


  provisioner "shell" {
    environment_vars = [
      "DOCKER_USERNAME=${var.docker_username}",
      "DOCKER_PASSWORD=${var.docker_password}",
      "GITHUB_PAT=${var.github_pat}",
      "USER_GIT=${var.git_user}",
    ]
    script = "setup_jenkins.sh"
  }



  provisioner "shell" {
    script = "setup_jenkinspipeline.sh"
  }

  provisioner "shell" {
    script = "install_docker.sh"
  }


}



