# Define AWS External IP(EIP) / NAT gateway - for EC2 in a Private VPC subnet
# Connect ผ่าน internet
resource "aws_eip" "customvpc-nat" {
  vpc      = true
}

# Define NAT Internet Gateway 
resource "aws_nat_gateway" "customvpc-nat-gw" {
  allocation_id = aws_eip.customvpc-nat.id
  subnet_id = aws_subnet.customvpc-public-1.id
  depends_on = [
    aws_internet_gateway.customvpc-gw
  ]
}

# Define NAT Routing Table
resource "aws_route_table" "customvpc-private-r" {
  vpc_id = aws_vpc.customvpc.id
  route {
    cidr_block = "0.0.0.0/0" # All IPs
    nat_gateway_id = aws_nat_gateway.customvpc-nat-gw.id
  } 
  tags = {
    Name = "customvpc-private-r"
  }
}


# Routing association Private
resource "aws_route_table_association" "customvpc-private-1-a" {
  subnet_id      = aws_subnet.customvpc-private-1.id
  route_table_id = aws_route_table.customvpc-private-r.id
}
