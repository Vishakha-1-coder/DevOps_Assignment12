# terraform/keypair.tf
resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "devops_key" {
  key_name   = "devops_key"
  public_key = tls_private_key.keygen.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.keygen.private_key_pem
  filename = "${path.module}/terraform-key.pem"
  file_permission = "0400"
}
