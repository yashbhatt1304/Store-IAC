terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.78.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "store_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = var.store_tag
  }
}

# Create a Subnet
resource "aws_subnet" "store_subnet-1" {
  vpc_id     = aws_vpc.store_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = var.store_tag
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "store_igw" {
  vpc_id = aws_vpc.store_vpc.id

  tags = {
    Name = var.store_tag
  }
}

# Creating Route Table
resource "aws_route_table" "store_route_table" {
  vpc_id = aws_vpc.store_vpc.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.store_igw.id
  }
  tags = {
    Name = var.store_tag
  }
}

# Attaching Route table to Subnet
resource "aws_route_table_association" "store_route_subnet" {
  subnet_id      = aws_subnet.store_subnet-1.id
  route_table_id = aws_route_table.store_route_table.id
}

# Creating Security Group
resource "aws_default_security_group" "store_default_sg" {
  vpc_id      = aws_vpc.store_vpc.id

  tags = {
    Name = var.store_tag
  }
}

resource "aws_security_group" "store_sg" {
  name        = "store_sg"
  description = "Allow TLS inbound traffic and all outbound traffic for monitoring"
  vpc_id      = aws_vpc.store_vpc.id

  tags = {
    Name = var.store_tag_mon
  }
}

# Attaching Https Ingress
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  # security_group_id = aws_security_group.store_sg.id
  security_group_id = aws_vpc.store_vpc.default_security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Attaching Http Ingress
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_vpc.store_vpc.default_security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Attaching port 4000 Ingress
 resource "aws_vpc_security_group_ingress_rule" "allow_port_4000" {
  security_group_id = aws_vpc.store_vpc.default_security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 4000
  ip_protocol       = "tcp"
  to_port           = 4000
}

# Attaching port 3002 Ingress
 resource "aws_vpc_security_group_ingress_rule" "allow_port_3002" {
  security_group_id = aws_vpc.store_vpc.default_security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3002
  ip_protocol       = "tcp"
  to_port           = 3002
}

# Creating EC2 Instance
resource "aws_instance" "store_frontend" {
  ami = var.ami_id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.store_subnet-1.id
  tags = {
    Name = var.store_tag
  }
}