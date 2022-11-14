provider "aws" {
  region     = var.region
}

resource "tls_private_key" "red_bots_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "red_bots_generated_key" {
  key_name   = "red-bots-private-key"
  public_key = tls_private_key.red_bots_key.public_key_openssh
}

data "aws_security_group" "selected" {
  id = var.api_end_point_security_group_id
}

resource "aws_security_group_rule" "red_bots_security_group_for_api" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.red_bot_master_redirector.public_ip}/32"]
  security_group_id = data.aws_security_group.selected.id
  description = "${aws_instance.red_bot_master_redirector.public_ip} ${var.env} Master Redirector"
}
