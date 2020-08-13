# vpc and gateway
resource "aws_vpc" "tls-nfs-vpc" {
  cidr_block              = var.vpc_cidr
  enable_dns_support      = "true"
  enable_dns_hostnames    = "true"
  tags                    = {
    Name                  = "tls-nfs-vpc"
  }
}

# internet gateway for public subnets
resource "aws_internet_gateway" "tls-nfs-gw" {
  vpc_id                  = aws_vpc.tls-nfs-vpc.id
  tags                    = {
    Name                  = "tls-nfs-gw"
  }
}

# public route table
resource "aws_route_table" "tls-nfs-pubrt" {
  vpc_id                  = aws_vpc.tls-nfs-vpc.id
  route {
    cidr_block              = "0.0.0.0/0"
    gateway_id              = aws_internet_gateway.tls-nfs-gw.id
  }
  tags                    = {
    Name                  = "tls-nfs-pubrt"
  }
}

# public subnets
resource "aws_subnet" "tls-nfs-pubnet1" {
  vpc_id                  = aws_vpc.tls-nfs-vpc.id
  availability_zone       = data.aws_availability_zones.tls-nfs-azs.names[0]
  cidr_block              = var.pubnet1_cidr
  tags                    = {
    Name                  = "tls-nfs-pubnet1"
  }
}

# public route table associations
resource "aws_route_table_association" "rt-assoc-pubnet1" {
  subnet_id               = aws_subnet.tls-nfs-pubnet1.id
  route_table_id          = aws_route_table.tls-nfs-pubrt.id
}
