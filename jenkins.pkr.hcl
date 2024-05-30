packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}
variable "aws_region" {
  description = "The AWS region to deploy to."
  default     = "us-east-1"
}
 
variable "source_ami" {
  description = "The source Ubuntu 24.04 LTS AMI."
  default     = "ami-04b70fa74e45c3917"
}
 
variable "ami-prefix" {
  type    = string
  default = "Csye-7125-Packer-Image"
}
 
// variable "subnet_id" {
//   type        = string
//   description = "Subnet of the default VPC"
//   // default     = "subnet-06bea9945ba667934"
// }
 
variable "OS" {
  type        = string
  description = "Base operating system version"
  default     = "Ubuntu"
}
 
// variable "ami_users" {
//   type = list(string)
//   default = ["992382384015", "767398141113"]
// }
 
variable "aws-access-key-id" {
  type    = string
  default = env("aws-access-key-id")
}
 
variable "aws-secret-access-key" {
  type    = string
  default = env("aws-secret-access-key")
}
 
variable "instance_type" {
  description = "The instance type to use for the build."
  default     = "t2.micro"
}
 
variable "ssh_username" {
  description = "The SSH username to use."
  default     = "ubuntu"
}
 
variable "ami_name" {
  description = "The name of the created AMI."
  default     = "Jenkins-AMI"
}
 

source "amazon-ebs" "jenkins" {
  region          = "${var.aws_region}"
  ami_name        = "jenkins-{{timestamp}}"
  ami_description = "Building Jenkins AMI built with Packer"
  // ami_users       = "${var.ami_users}"
  instance_type   = "${var.instance_type}"
  source_ami      = "${var.source_ami}"
  ssh_username    = "${var.ssh_username}"
  ami_regions     = ["${var.aws_region}", ]
  // access_key      = "${var.aws-access-key-id}"
  // secret_key      = "${var.aws-secret-access-key}"
  profile       = "infra"
}
// source "amazon-ebs" "jenkins" {
//   ami_name      = "jenkins-{{timestamp}}"
//   instance_type = "t2.micro"
//   region        = "us-east-1"
//   profile       = "infra"

//   // user_data_file = "userdata.sh"
//   source_ami_filter {
//     filters = {
//       name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
//       root-device-type    = "ebs"
//       virtualization-type = "hvm"
//     }
//     most_recent = true
//     owners      = ["099720109477"]
//   }
//   ssh_username = "ubuntu"
// }

build {
  sources = ["source.amazon-ebs.jenkins"]

 provisioner "shell" {
    script = "install_jenkins.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install caddy -y",
      "sudo systemctl enable caddy",
      "sudo systemctl status caddy",
      "sudo mkdir -p /etc/caddy",
      // "sudo bash -c 'cat > /etc/caddy/Caddyfile <<EOF\n{\n    acme_ca https://acme-staging-v02.api.letsencrypt.org/directory\n}\njenkins.centralhub.me {\n    reverse_proxy localhost:8080\n}\nEOF'",
      "sudo bash -c 'cat > /etc/caddy/Caddyfile <<EOF\njenkins.poojacloud24.pw {\n    reverse_proxy 127.0.0.1:8080\n}\nEOF'",
      "sudo systemctl restart caddy"
    ]
  }

 
  // provisioner "shell" {
  // inline = [
  //       // "sudo apt-get update",
  //   // "sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https",
  //   // "curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg",
  //   // "sudo curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy.list",
  //   "sudo apt-get update",
  //   "sudo apt-get install  caddy -y",
  //   "sudo systemctl enable caddy",
  // ]
  // }
  // // provisioner "shell" {
  // //   inline = [ 
  // //   "echo 'deb [signed-by=/usr/share/keyrings/caddy-stable-archive-keyring.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/debian/ any-version any' | sudo tee /etc/apt/sources.list.d/caddy.list",

  // //   ]
  // // }
  // provisioner "file" {
  //   source      = "Caddyfile"
  //   destination = "/tmp/Caddyfile"
  // }

  // provisioner "shell" {
  //   inline = [
  //     "sudo mkdir -p /etc/caddy",
  //     "sudo mv /tmp/Caddyfile /etc/caddy/Caddyfile",
  //     // "sudo chown -R root:root /etc/caddy",
  //     "sudo systemctl restart caddy",
  //   ]
  // }

  // provisioner "shell" {
  //   script = "setupReverseProxy.sh"
  // }

// provisioner "shell" {
//   inline = [
//     "sudo apt-get update",
//     "sudo apt-get install -y nginx certbot python3-certbot-nginx",
//     "sudo systemctl enable nginx",
//   ]
// }

// provisioner "file" {
//   source      = "nginx-config.conf"
//   destination = "/tmp/nginx.conf"
// }

// provisioner "shell" {
//   inline = [
//     "sudo mv /tmp/nginx.conf /etc/nginx/sites-available/default",
//     "sudo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/",
//     "sudo certbot --nginx --non-interactive --agree-tos --email harshsiksha@gmail.com -d poojacloud24.pw",
//     "sudo systemctl restart nginx",
//     "echo nginx files copied successfully",
//   ]
// }

// provisioner "shell" {
//   inline = [
//     "sudo certbot --nginx --non-interactive --agree-tos --email harshsiksha@gmail.com -d poojacloud24.pw",
//     "sudo systemctl reload nginx",
//   ]
// }
 
  
}



