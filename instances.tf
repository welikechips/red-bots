resource "null_resource" "save_cert" {
  provisioner "local-exec" {
    command = "echo \"${tls_private_key.red_bots_key.private_key_pem}\" > red_bots_id_rsa"
  }
  provisioner "local-exec" {
    command = "sudo chmod 600 red_bots_id_rsa"
  }
}


resource "aws_instance" "master" {
  count = 1

  # All four instances will have the same ami and instance_type
  ami           = var.master_ami_id
  instance_type = var.master_instance_type #
  tags          = {
    # The count.index allows you to launch a resource
    # starting with the distinct index number 0 and corresponding to this instance.
    Name = "red-bot-master"
  }
  connection {
    user        = "ubuntu"
    type        = "ssh"
    timeout     = "2m"
    host        = self.public_ip
    private_key = tls_private_key.red_bots_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" dist-upgrade",
      "sudo apt-get autoremove -y",
      "sudo apt-get install -y git tmux curl tar zip gnome-terminal python3-pip apache2 libapache2-mod-wsgi-py3 certbot python3-certbot-apache",
      "sudo curl -sSL https://raw.githubusercontent.com/welikechips/chips/master/tools/install-chips-defaults.sh | sudo bash",
      "pip install \"cookiecutter>=1.7.0\"",
      "cookiecutter https://github.com/cookiecutter/cookiecutter-django --no-input"
    ]
  }
}

resource "aws_spot_instance_request" "bots" {
  count = var._count
  spot_type = var.spot_type

  # All four instances will have the same ami and instance_type
  ami           = var.bot_ami_id
  instance_type = var.bot_instance_type #
  tags          = {
    # The count.index allows you to launch a resource
    # starting with the distinct index number 0 and corresponding to this instance.
    Name = "red-bot-${count.index}"
  }
  connection {
    user        = "ubuntu"
    type        = "ssh"
    timeout     = "2m"
    host        = self.public_ip
    private_key = tls_private_key.red_bots_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" dist-upgrade",
      "sudo apt-get autoremove -y",
      "sudo apt-get install -y git tmux curl tar zip gnome-terminal python3-pip apache2 libapache2-mod-wsgi-py3 certbot python3-certbot-apache",
      "sudo curl -sSL https://raw.githubusercontent.com/welikechips/chips/master/tools/install-chips-defaults.sh | sudo bash",
      "#RUN COMMAND TO CHECK QUEUE",
    ]
  }
}
