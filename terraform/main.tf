provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "sg" {
  name = "project-7-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "project-7-sg" }
}

resource "aws_instance" "k3s" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "c7i-flex.large"
  key_name               = "aws-key"
  vpc_security_group_ids = [aws_security_group.sg.id]

  root_block_device {
    volume_size = 20
  }

  # Диск для логів
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 10
  }

  # Диск для бази даних
  ebs_block_device {
    device_name = "/dev/sdc"
    volume_size = 10
  }

  tags = { Name = "project-7-k3s" }
}

output "public_ip" {
  value = aws_instance.k3s.public_ip
}

output "private_ip" {
  value = aws_instance.k3s.private_ip
}