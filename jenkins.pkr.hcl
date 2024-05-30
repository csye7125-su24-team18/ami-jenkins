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
 


source "amazon-ebs" "jenkins" {
  region          = "${var.region}"
  ami_name        = "jenkins-{{timestamp}}"
  ami_description = "Building Jenkins AMI built with Packer"
  // ami_users       = "${var.ami_users}"
  instance_type   = "${var.machine_type}"
  source_ami      = "${var.source_ami}"
  ssh_username    = "${var.ssh_username}"
  ami_regions     = ["${var.region}", ]
  // access_key      = "${var.aws-access-key-id}"
  // secret_key      = "${var.aws-secret-access-key}"
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
  provisioner "shell"{
    script = "install_caddy.sh"
  }
  
}



