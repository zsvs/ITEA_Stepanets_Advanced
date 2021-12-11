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
    for_each = ["80", "443", "3306"]
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

######################## Elastic IP ########################
resource "aws_eip" "instance_static_addr" {
  instance = aws_instance.web_server.id
  vpc      = true
  depends_on = [
    aws_db_instance.l8-rds
  ]
}

######################## EC2 instance ########################

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.defaut_latest_ubuntu.id
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.allow_traffic.id]
  instance_type          = "t2.micro"
  user_data = templatefile("./Userdata_for_EC2/user_data.sh.tpl", {
    Listen_Port       = "80"
    DNS_Name          = "wp.svs-devops.click"
    rds_name          = aws_db_instance.l8-rds.name
    rds_user_name     = var.db_username
    rds_user_password = var.db_password
    rds_db_host       = aws_db_instance.l8-rds.address
  })
  tags = {
    Name = "Web application instance"
  }
  depends_on = [
    aws_db_instance.l8-rds
  ]
}
