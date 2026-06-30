#modules/vpc/main.tf

# Create AWS VPC

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name                                        = "${var.cluster_name}-vpc"
    Environment                                 = var.environment
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

#create private subnet in the VPC
resource "aws_subnet" "priv_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    Name                                        = "${var.cluster_name}-private-subnet"
    Environment                                 = var.environment
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

#create Publicsubnet in the vpc
resource "aws_subnet" "pub_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name                                        = "${var.cluster_name}-public-subnet"
    Environment                                 = var.environment
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

#Create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name                                        = "${var.cluster_name}-igw"
    Environment                                 = var.environment
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

#Route table for public subnet
resource "aws_route_table" "rt_public_subnet" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name                                        = "${var.cluster_name}-public-route-table"
    Environment                                 = var.environment
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

#Associate public subnet with route table
resource "aws_route_table_association" "rta_public_subnet" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.pub_subnet[count.index].id
  route_table_id = aws_route_table.rt_public_subnet.id
}


#Create NAT gateway in public subnet
resource "aws_nat_gateway" "nat_gateway" {
  count = length(var.public_subnet_cidrs)

  subnet_id     = aws_subnet.pub_subnet[count.index].id
  allocation_id = aws_eip.nat[count.index].id

  tags = {
    Name        = "${var.cluster_name}-nat-gateway"
    Environment = var.environment
  }
}

#Route table for private subnet
resource "aws_route_table" "rt_private_subnet" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
  }
  tags = {
    Name                                        = "${var.cluster_name}-private-route-table"
    Environment                                 = var.environment
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
#Associate private subnet with route table
resource "aws_route_table_association" "rta_private_subnet" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.priv_subnet[count.index].id
  route_table_id = aws_route_table.rt_private_subnet.id
}
#Elastic IP for NAT gateway
resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidrs)
  tags = {
    Name                                        = "${var.cluster_name}-nat-eip"
    Environment                                 = var.environment
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}





