//network.tf
resource "aws_vpc" "red_bots_vpc" {
    cidr_block              = var.subnet
    enable_dns_hostnames    = true
    enable_dns_support      = true
    tags = {
        Name = "${var.env}_red_bots_vpc"
    }
}

resource "aws_internet_gateway" "red_bots_gw" {
    vpc_id = aws_vpc.red_bots_vpc.id
    tags = {
        Name = "${var.env}_red_bots_gw"
        Env  = var.env
    }
}

resource "aws_default_route_table" "red_bots_route_table" {
    default_route_table_id = aws_vpc.red_bots_vpc.default_route_table_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.red_bots_gw.id
    }
    tags = {
        Name = "${var.env}_red_bots_default_route_table"
        env  = var.env
    }
}

resource "aws_subnet" "red_bots_subnet" {
    cidr_block = cidrsubnet(aws_vpc.red_bots_vpc.cidr_block, 3, 1)
    vpc_id = aws_vpc.red_bots_vpc.id
    availability_zone = var.availability_zones[0]
    map_public_ip_on_launch = "true"
    tags = {
        Name = "${var.env}_red_bots_subnet"
        Env  = var.env
    }
}