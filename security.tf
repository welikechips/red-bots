resource "aws_security_group" "red_bots_port_22_ssh_access_cidrs" {
  name = "red_bots_port_22_ssh_access_cidrs"
  vpc_id = aws_vpc.red_bots_vpc.id
  ingress {
    cidr_blocks = var.red_bots_port_22_ssh_access_cidrs
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env} SSH access from valid cidrs."
  }
}
resource "aws_default_security_group" "red_bots_default" {
  vpc_id = aws_vpc.red_bots_vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env} redbots default security group"
  }
}

resource "aws_security_group" "red_bots_allow_certbot" {
  name = "red_bots_allow_certbot"
  vpc_id = aws_vpc.red_bots_vpc.id
  ingress {
    cidr_blocks = var.red_bots_master_redirector_access_cidrs
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }
  ingress {
    cidr_blocks = var.red_bots_master_redirector_access_cidrs
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env} allow certbot to connect and get ssl cert setup."
  }
}