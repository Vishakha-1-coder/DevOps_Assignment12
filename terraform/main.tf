# ------------------------------
# Create a key pair
# ------------------------------
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "terraform_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/terraform-key.pem"
  file_permission = "0400"
}

# ------------------------------
# Create a security group
# ------------------------------
resource "aws_security_group" "devops_sg" {
  name        = "devops-sg"
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
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

data "aws_vpc" "default" {
  default = true
}

# ------------------------------
# Instance Creation
# ------------------------------
resource "aws_instance" "controller" {
  ami             = "ami-0c7217cdde317cfec" # Ubuntu 20.04 LTS (Free tier)
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.devops_sg.name]
  tags = {
    Name = "Controller"
  }
}

resource "aws_instance" "manager" {
  ami             = "ami-0c7217cdde317cfec"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.devops_sg.name]
  tags = {
    Name = "Swarm-Manager"
  }
}

resource "aws_instance" "worker_a" {
  ami             = "ami-0c7217cdde317cfec"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.devops_sg.name]
  tags = {
    Name = "Swarm-Worker-A"
  }
}

resource "aws_instance" "worker_b" {
  ami             = "ami-0c7217cdde317cfec"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.devops_sg.name]
  tags = {
    Name = "Swarm-Worker-B"
  }
}

# ------------------------------
# Elastic IPs
# ------------------------------
resource "aws_eip" "manager_eip" {
  instance = aws_instance.manager.id
}

resource "aws_eip" "worker_a_eip" {
  instance = aws_instance.worker_a.id
}

resource "aws_eip" "worker_b_eip" {
  instance = aws_instance.worker_b.id
}

output "elastic_ips" {
  value = {
    manager  = aws_eip.manager_eip.public_ip
    worker_a = aws_eip.worker_a_eip.public_ip
    worker_b = aws_eip.worker_b_eip.public_ip
  }
}
