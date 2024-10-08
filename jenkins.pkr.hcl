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

 variable "git_user" {
   description = "Git user"
   default     = ""
 }

 variable "github_pat" {
    description = "GitHub Personal Access Token"
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
    source      = "webapp-helm-pipeline.groovy"
    destination = "/tmp/webapp-helm-pipeline.groovy"
  }
  provisioner "file" {
    source      = "webapp-pipeline.groovy"
    destination = "/tmp/webapp-pipeline.groovy"
  }
  provisioner "file" {
    source      = "consumer-helm-pipeline.groovy"
    destination = "/tmp/consumer-helm-pipeline.groovy"
  }
  provisioner "file" {
    source      = "consumer-pipeline.groovy"
    destination = "/tmp/consumer-pipeline.groovy"
  }
  provisioner "file" {
    source      = "jenkins_creds.groovy"
    destination = "/tmp/jenkins_creds.groovy"
  }

  provisioner "file" {
    source      = "infra-pipeline.groovy"
    destination = "/tmp/infra-pipeline.groovy"
  }

  provisioner "file"{
    source = "operator-pipeline.groovy"
    destination = "/tmp/operator-pipeline.groovy"
  }

provisioner "shell" {
  script = "install_node_go.sh" 
}

provisioner "shell" {
  script = "install_terraform.sh"
}

 provisioner "shell" {
  environment_vars = [
    
    "DOCKER_USERNAME=${var.docker_username}",
    "DOCKER_PASSWORD=${var.docker_password}",
    "USER_GIT=${var.git_user}",
    "PERSONAL_PAT=${var.github_pat}"
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



