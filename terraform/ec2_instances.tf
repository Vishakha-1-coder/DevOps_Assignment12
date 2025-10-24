# terraform/ec2_instances.tf
variable "instance_count" {
  default = 4
}

locals {
  instance_names = ["controller", "manager", "workerA", "workerB"]
}

resource "aws_instance" "servers" {
  count         = var.instance_count
  ami           = "ami-0f58b397bc5c1f2e8" # Ubuntu 20.04 LTS (Mumbai)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.devops_key.key_name
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = local.instance_names[count.index]
  }
}
