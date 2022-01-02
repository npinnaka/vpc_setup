resource "aws_subnet" "private_subnet" {
  cidr_block = var.private_subnet_cidr
  vpc_id     = aws_vpc.vpc.id
  tags = {
    Name = "VPC-Public-Subnet"
  }
}

resource "aws_eip" "eip" {
  vpc = true
  tags = {
    Name = "VPC-EIP"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "VPC-Nat-Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "VPC-Private-Subnet"
  }
  route {
    cidr_block     = var.all_traffic
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "private_route_table_mapping" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet.id
}