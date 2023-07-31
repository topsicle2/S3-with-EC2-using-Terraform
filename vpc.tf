#Create VPC
resource "aws_vpc" "int1-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "int1-vpc"
  }
}

#Create Public Subnet
resource "aws_subnet" "int1-pubSN1" {
  vpc_id            = aws_vpc.int1-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "int1-pubSN1"
  }
}

resource "aws_subnet" "int1-pubSN2" {
  vpc_id            = aws_vpc.int1-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "int1-pubSN2"
  }
}

#Create Private Subnet
resource "aws_subnet" "int1-priSN1" {
  vpc_id            = aws_vpc.int1-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name = "int1-priSN1"
  }
}

resource "aws_subnet" "int1-priSN2" {
  vpc_id            = aws_vpc.int1-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-1b"

  tags = {
    Name = "int1-priSN2"
  }
}

#Create IGW
resource "aws_internet_gateway" "int1-igw" {
  vpc_id = aws_vpc.int1-vpc.id

  tags = {
    Name = "int1-igw"
  }
}

#Create EIP for NATGW
resource "aws_eip" "int1-eip-natgw" {
  domain = "vpc"
}

#Create NAT-GW
resource "aws_nat_gateway" "int1-natgw" {
  allocation_id = aws_eip.int1-eip-natgw.id
  subnet_id     = aws_subnet.int1-pubSN2.id
  depends_on    = [aws_internet_gateway.int1-igw]

  tags = {
    Name = "int1-natgw"
  }
}

#Create Public Route Table
resource "aws_route_table" "int1-pubRT" {
  vpc_id = aws_vpc.int1-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int1-igw.id
  }

  tags = {
    Name = "int1-pubRT"
  }
}

#Create Public RT Association
# resource "aws_route_table_association" "b" {
#   gateway_id     = aws_internet_gateway.int1-igw.id
#   route_table_id = aws_route_table.int1-pubRT.id
# }

resource "aws_route_table_association" "pubRT-assoc1" {
  subnet_id      = aws_subnet.int1-pubSN1.id
  route_table_id = aws_route_table.int1-pubRT.id
}

resource "aws_route_table_association" "pubRT-assoc2" {
  subnet_id      = aws_subnet.int1-pubSN2.id
  route_table_id = aws_route_table.int1-pubRT.id
}

#Create Private Route Table
resource "aws_route_table" "int1-priRT" {
  vpc_id = aws_vpc.int1-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.int1-natgw.id
  }

  tags = {
    Name = "int1-priRT"
  }
}

resource "aws_route_table_association" "priRT-assoc1" {
  subnet_id      = aws_subnet.int1-priSN1.id
  route_table_id = aws_route_table.int1-priRT.id
}

resource "aws_route_table_association" "priRT-assoc2" {
  subnet_id      = aws_subnet.int1-priSN2.id
  route_table_id = aws_route_table.int1-priRT.id
}

