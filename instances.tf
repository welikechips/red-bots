resource "null_resource" "save_cert" {
  provisioner "local-exec" {
    command = "echo \"${tls_private_key.red_bots_key.private_key_pem}\" > red_bots_id_rsa"
  }
  provisioner "local-exec" {
    command = "sudo chmod 600 red_bots_id_rsa"
  }
}

resource "aws_instance" "red_bot_master_redirector" {
  ami                    = var.master_ami_id
  instance_type          = var.master_instance_type
  key_name               = aws_key_pair.red_bots_generated_key.key_name
  subnet_id              = aws_subnet.red_bots_subnet.id
  vpc_security_group_ids = [
    aws_security_group.red_bots_port_22_ssh_access_cidrs.id,
    aws_default_security_group.red_bots_default.id,
    aws_security_group.red_bots_allow_certbot.id
  ]
  tags = {
    Name = "${var.env}_red_bot_master_redirector"
  }
}

resource "null_resource" "red_bot_master_provisioning2" {
  depends_on = [aws_instance.red_bot_master_redirector]
  connection {
    user        = "ubuntu"
    type        = "ssh"
    timeout     = "2m"
    host        = aws_instance.red_bot_master_redirector.public_ip
    private_key = tls_private_key.red_bots_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm /etc/apache2/sites-enabled/000-default-le-ssl.conf",
      "echo 'sleeping......'",
      "sleep 60",
      "sudo certbot certonly -d \"www.${var.server_name},${var.server_name}\" --apache -n --agree-tos -m \"${var.contact_email}\"",
      "sudo curl -sSL https://raw.githubusercontent.com/welikechips/bot-tools/main/replace_000_default.sh | sudo bash -s -- ${var.api_end_point_domain}",
      "sudo curl -sSL https://raw.githubusercontent.com/welikechips/bot-tools/main/replace_default_le_ssl.sh | sudo bash -s -- ${var.api_end_point_domain} ${var.server_name}",
      "sudo a2enmod ssl rewrite proxy proxy_http",
      "sudo a2ensite default-ssl.conf",
      "sudo a2enmod proxy_connect",
      "sudo service apache2 stop",
      "sudo service apache2 start",
    ]
  }
}

resource "aws_spot_instance_request" "bots" {
  count                  = var._count
  spot_type              = var.spot_type
  key_name               = aws_key_pair.red_bots_generated_key.key_name
  subnet_id              = aws_subnet.red_bots_subnet.id
  vpc_security_group_ids = [
    aws_security_group.red_bots_port_22_ssh_access_cidrs.id,
    aws_default_security_group.red_bots_default.id
  ]

  # All four instances will have the same ami and instance_type
  ami           = var.bot_ami_id
  instance_type = var.bot_instance_type
}

resource "aws_ec2_tag" "bot_tagger" {
  depends_on  = [aws_spot_instance_request.bots]
  count       = var._count
  resource_id = element(aws_spot_instance_request.bots.*.spot_instance_id, count.index)
  key         = "Name"
  value       = "${var.env}-red-bot-${count.index}"
}

# Comment this resource if create-ami.tf is uncommented
#resource "null_resource" "run_bots" {
#  depends_on = [aws_ec2_tag.bot_tagger]
#  count      = var._count
#
#  connection {
#    user        = "ubuntu"
#    type        = "ssh"
#    timeout     = "10s"
#    host        = element(aws_spot_instance_request.bots.*.public_ip, count.index)
#    private_key = tls_private_key.red_bots_key.private_key_pem
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "rm -rf ~/bot-tools/",
#      "git clone https://github.com/welikechips/bot-tools ~/bot-tools",
#      "cd ~/bot-tools && pip3 install -r requirements.txt",
#      "cd ~/bot-tools && python3 run-bots.py --job_index ${count.index} \"${var.server_name}\" \"${var.api_end_point_domain}\" \"${var.api_key}\" \"${var.api_bot_guid}\""
#    ]
#  }
#}
