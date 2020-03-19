# To contain each PE deployment, a fresh VPC to deploy into
locals {
  name_tag = {
    Name = "pe-${var.project}-${var.id}"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "pe" {
  cidr_block           = "10.138.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.name_tag
}

resource "aws_internet_gateway" "pe_gw" {
  vpc_id = aws_vpc.pe.id

  tags = local.name_tag
}

#TODO implement a subnet per availability zone
resource "aws_subnet" "pe_subnet" {
  vpc_id            = aws_vpc.pe.id
  count             = length(data.aws_availability_zones.available.names)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  cidr_block              = "10.138.${1 + count.index}.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "pe-${var.project}-${var.id}-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_route_table" "pe_public" {
  vpc_id = aws_vpc.pe.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pe_gw.id
  }
  tags = local.name_tag
}

resource "aws_route_table_association" "pe_subnet_public" {
  count          = length(aws_subnet.pe_subnet)
  subnet_id      = aws_subnet.pe_subnet[count.index].id
  route_table_id = aws_route_table.pe_public.id
}

# Instances should not be accessible by the open internet so a fresh VPC should
# be restricted to organization allowed subnets
resource "aws_security_group" "pe_sg" {
  name        = "pe-${var.project}-${var.id}"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.pe.id

  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from everywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Anything from VPC"
    from_port   = 1
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = list(aws_vpc.pe.cidr_block)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
