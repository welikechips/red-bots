
output "master_private_ip" {
  value = aws_instance.master.private_ip
}

output "master_public_ip" {
  value = aws_instance.master.public_ip
}

