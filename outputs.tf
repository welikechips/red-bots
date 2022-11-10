
output "master_private_ip" {
  value = aws_instance.red_bot_master_redirector.private_ip
}

output "master_public_ip" {
  value = aws_instance.red_bot_master_redirector.public_ip
}

