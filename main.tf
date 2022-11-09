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
