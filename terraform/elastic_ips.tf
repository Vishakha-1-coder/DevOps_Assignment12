# terraform/elastic_ips.tf
resource "aws_eip" "ips" {
  count      = var.instance_count
  instance   = aws_instance.servers[count.index].id
  depends_on = [aws_instance.servers]
}

output "instance_public_ips" {
  value = [for eip in aws_eip.ips : eip.public_ip]
}
