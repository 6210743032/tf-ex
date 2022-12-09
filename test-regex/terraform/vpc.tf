# Create AWS VPC
resource "aws_vpc" "customvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "customvpc"
  }
}

# Create Subnets in the custom VPC
resource "aws_subnet" "customvpc-public-1" {
  vpc_id = aws_vpc.customvpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-1a"
  tags = {
    Name = "customvpc-public-1"
  }
}

resource "aws_subnet" "customvpc-public-2" {
  vpc_id = aws_vpc.customvpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-1b"
  tags = {
    Name = "customvpc-public-2"
  }
}

resource "aws_subnet" "customvpc-private-1" {
  vpc_id = aws_vpc.customvpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-west-1b"
  tags = {
    Name = "customvpc-private-1"
  }
}

# Define Internet Gateway
resource "aws_internet_gateway" "customvpc-gw" {
  vpc_id = aws_vpc.customvpc.id
  tags = {
    Name = "customvpc-gw"
  }
}

# Define Routing Table for the custom VPC
resource "aws_route_table" "customvpc-public-r" {
  vpc_id = aws_vpc.customvpc.id
  route {
    cidr_block = "0.0.0.0/0" # All IPs
    gateway_id = aws_internet_gateway.customvpc-gw.id
  } 
  tags = {
    Name = "customvpc-public-r"
  }
}

# Routing association
resource "aws_route_table_association" "customvpc-public-1-a" {
  subnet_id      = aws_subnet.customvpc-public-1.id
  route_table_id = aws_route_table.customvpc-public-r.id
}

resource "aws_route_table_association" "customvpc-public-2-a" {
  subnet_id      = aws_subnet.customvpc-public-2.id
  route_table_id = aws_route_table.customvpc-public-r.id
}
