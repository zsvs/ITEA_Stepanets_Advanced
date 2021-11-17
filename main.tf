terraform {
  backend "s3" {
    bucket = "itea-adv-stepanets"        # Bucket where to SAVE Terraform State
    key    = "servers/terraform.tfstate" # Object name in the bucket to SAVE Terraform State
    region = "eu-west-1"                 # Region where bucket created
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.65.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {} # Get current availability zones LINK https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones

data "aws_region" "current" {} # Get info about current region

data "aws_vpc" "default" { # Get info about default vpc
  tags = {
    Name = "Default"
  }
}

data "aws_ami" "defaut_latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

######################## Security group ########################
resource "aws_security_group" "allow_traffic" {
  name        = "Dynamic_sg_allow_traffic"
  description = "Allow SSH & HTTP via terraform"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "ssh allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.home_ip

  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  tags = {
    Name = "Dynamic_created_sg_allow_ssh_http"
  }
}

######################## EC2 instance ########################

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.defaut_latest_ubuntu.id
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.allow_traffic.id]
  instance_type          = "t2.micro"
  user_data = templatefile("./External_sh/user_data.sh.tpl", {
    f_name = "Stepanets Valerii"
    f_nick = "SVS"
  })
  tags = {
    Name = "NGINX web server"
  }
}
