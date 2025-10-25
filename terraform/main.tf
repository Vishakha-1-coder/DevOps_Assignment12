resource "tls_private_key" "terraform_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.terraform_key.private_key_pem
  filename = "${path.module}/terraform-key.pem"
}

resource "aws_key_pair" "devops_key" {
  key_name   = "devops_key"
  public_key = tls_private_key.terraform_key.public_key_openssh
}

resource "aws_security_group" "devops_sg" {
  name        = "devops_sg"
  description = "Allow SSH, HTTP, HTTPS, custom ports"
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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Controller
resource "aws_instance" "controller" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.devops_key.key_name
  security_groups = [aws_security_group.devops_sg.name]
  tags = { Name = "Controller" }
}

# Manager
resource "aws_instance" "manager" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.devops_key.key_name
  security_groups = [aws_security_group.devops_sg.name]
  tags = { Name = "Manager" }
}

# Worker A
resource "aws_instance" "worker_a" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.devops_key.key_name
  security_groups = [aws_security_group.devops_sg.name]
  tags = { Name = "WorkerA" }
}

# Worker B
resource "aws_instance" "worker_b" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.devops_key.key_name
  security_groups = [aws_security_group.devops_sg.name]
  tags = { Name = "WorkerB" }
}

# Elastic IPs
resource "aws_eip" "controller_eip" { instance = aws_instance.controller.id }
resource "aws_eip" "manager_eip" { instance = aws_instance.manager.id }
resource "aws_eip" "worker_a_eip" { instance = aws_instance.worker_a.id }
resource "aws_eip" "worker_b_eip" { instance = aws_instance.worker_b.id }
