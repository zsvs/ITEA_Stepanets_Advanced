resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "SG for allow trafic from EC2 sg"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = ["80", "443", "3306"]
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.allow_traffic.id]
    }
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


resource "aws_db_instance" "l8-rds" {
  identifier             = "svs-lesson8-homework"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.23"
  instance_class         = "db.t2.micro"
  name                   = "rdsLesson8HomeWork"
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  skip_final_snapshot    = true
  tags = {
    Name = "RDS-l8-hw"
  }
}
