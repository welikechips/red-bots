#resource "null_resource" "red_bot_master_provisioning1" {
#  depends_on = [aws_instance.red_bot_master_redirector]
#    connection {
#      user        = "ubuntu"
#      type        = "ssh"
#      timeout     = "2m"
#      host        = aws_instance.red_bot_master_redirector.public_ip
#      private_key = tls_private_key.red_bots_key.private_key_pem
#    }
#
#    provisioner "remote-exec" {
#      inline = [
#      "export PATH=$PATH:/usr/bin",
#      "sudo apt-get update",
#      "sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" dist-upgrade",
#      "sudo apt-get autoremove -y",
#      "sudo apt-get install -y git tmux curl tar zip gnome-terminal",
#      "sudo curl -sSL https://raw.githubusercontent.com/welikechips/chips/master/tools/install-chips-defaults.sh | sudo bash",
#      "sudo curl -sSL https://raw.githubusercontent.com/welikechips/chips/master/tools/install-redirector-server.sh | sudo bash",
#    ]
#  }
#}

resource "null_resource" "bot_provisioner" {
  depends_on = [aws_ec2_tag.bot_tagger]
  count      = var._count

  connection {
    user        = "ubuntu"
    type        = "ssh"
    timeout     = "10s"
    host        = element(aws_spot_instance_request.bots.*.public_ip, count.index)
    private_key = tls_private_key.red_bots_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" dist-upgrade",
      "sudo apt-get autoremove -y",
      "sudo apt-get install -y git tmux curl tar zip gnome-terminal python3-pip apache2 libapache2-mod-wsgi-py3 certbot python3-certbot-apache chromium-browser",
      "sudo curl -sSL https://raw.githubusercontent.com/welikechips/chips/master/tools/install-chips-defaults.sh | sudo bash",
      "sudo curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -",
      "sudo apt-get install -y nodejs"
    ]
  }
}