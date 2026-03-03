
# 1. VPC క్రియేషన్
resource "aws_vpc" "prod_vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true # మీరు అడిగినట్లుగా DNS Hostnames ఎనేబుల్ చేశాను
  enable_dns_support   = true

  tags = {
    Name        = "FinTech-Prod-VPC"
    Environment = "Production"
    Project     = "Banking-App"
  }
}

# 2. Subnets క్రియేషన్ (2 Public & 6 Private)
# Public Subnets (For Load Balancers & NAT Gateway)
resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = "192.168.${count.index}.0/24"
  availability_zone       = count.index == 0 ? "ap-south-1a" : "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "FinTech-Public-Subnet-${count.index + 1}"
  }
}

# Private Subnets (App & Database Layers కోసం)
resource "aws_subnet" "private_subnets" {
  count             = 6
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "192.168.${count.index + 10}.0/24"
  availability_zone = count.index % 2 == 0 ? "ap-south-1a" : "ap-south-1b"

  tags = {
    Name = "FinTech-Private-Subnet-${count.index + 1}"
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod_vpc.id
  tags   = { Name = "FinTech-Main-IGW" }
}

# 4. NAT Gateway (Private Subnets ఇంటర్నెట్ వాడటానికి)
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id # Public Subnet లో పెట్టాలి
  tags          = { Name = "FinTech-NAT-Gateway" }
}

# 5. Routing Tables
# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "FinTech-Public-RT" }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = { Name = "FinTech-Private-RT" }
}

# 6. Route Table Associations (అసోసియేషన్ చేయడం)
resource "aws_route_table_association" "public_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = 6
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
