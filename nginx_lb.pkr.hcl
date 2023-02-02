packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
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
  ami_name      = "nginx-lb-aws-linux-0.1"
  instance_type = "t4g.nano"
  region        = "eu-central-1"

  # provisioning
  ssh_username = "ec2-user"

  tags = {
    Name            = "nginx-lb-aws-linux-0.1"
    PackerBuilt     = "true"
    PackerTimestamp = regex_replace(timestamp(), "[- TZ:]", "")
    Version         = "0.1"
  }
}

build {
  name = "nginx-lb"
  sources = [
    "source.amazon-ebs.main"
  ]

  provisioner "file" {
    source      = "app/nginx.repo"
    destination = "/tmp/nginx.repo"
  }

  provisioner "file" {
    source      = "app/default.conf"
    destination = "/tmp/default.conf"
  }

  provisioner "shell" {
    inline = [
      "echo Configuring repository",
      "sudo mv /tmp/nginx.repo /etc/yum.repos.d/nginx.repo",
      "echo Done"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Installing NGINX",
      "sudo yum update",
      "sudo yum install nginx -y",
      "sudo mv /tmp/default.conf /etc/nginx/conf.d/default.conf",
      "echo Done"
    ]
  }
}
