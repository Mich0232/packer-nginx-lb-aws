packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "version" {
  type        = string
  description = "Version of your AMI"
}

variable "instance_type" {
  type    = string
  default = "t4g.nano"
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "regions" {
  type    = list(string)
  default = []
}

variable "ssh_user" {
  type    = string
  default = "ec2-user"
}

variable "nginx_version" {
  type = string
  default = "1.22.1"
}

source "amazon-ebs" "main" {

  # AWS AMI data source lookup
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-arm64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  # AWS EC2 parameters
  ami_name      = "nginx-lb-aws-linux-${var.version}"
  instance_type = var.instance_type
  region        = var.aws_region

  # provisioning
  ssh_username = var.ssh_user

  tags = {
    Name            = "nginx-lb-aws-linux-${var.version}"
    PackerBuilt     = "true"
    PackerTimestamp = regex_replace(timestamp(), "[- TZ:]", "")
    Version         = var.version
  }
}

build {
  name = "nginx-lb"
  sources = [
    "source.amazon-ebs.main"
  ]

  provisioner "file" {
    source      = "nginx/nginx.repo"
    destination = "/tmp/nginx.repo"
  }

  provisioner "file" {
    source      = "nginx/default.conf"
    destination = "/tmp/default.conf"
  }

  provisioner "file" {
    source      = "nginx/nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "shell" {
    inline = [
      "echo Configuring repository",
      "sudo mv /tmp/nginx.repo /etc/yum.repos.d/nginx.repo",
      "echo Done"
    ]
  }

  provisioner "shell" {
    environment_vars = [
      "NGINX_VERSION=${var.nginx_version}"
    ]
    scripts   = [
      "provisioners/10_yum_setup.sh",
      "provisioners/20_setup_nginx.sh"
    ]
    timeout  = "15m"
  }

  provisioner "shell" {
    inline = [
      "echo Configure NGINX files",
      "sudo mv /tmp/default.conf /etc/nginx/conf.d/default.conf",
      "sudo mv /tmp/nginx.conf /etc/nginx/nginx.conf",
      "echo Done"
    ]
  }
}
