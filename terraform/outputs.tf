output "controller_ip" {
  value = aws_instance.controller.public_ip
}

output "manager_ip" {
  value = aws_eip.manager_eip.public_ip
}

output "worker_a_ip" {
  value = aws_eip.worker_a_eip.public_ip
}

output "worker_b_ip" {
  value = aws_eip.worker_b_eip.public_ip
}
