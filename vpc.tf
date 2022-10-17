#Creating the VPC
resource "aws_vpc" "Macro_Eyes_VPC" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

#Getting all avalablility zones in us-east-2 region
data "aws_availability_zones" "available_zones" {}

#Creating public ALB NAT server subnet AZ 2a
resource "aws_subnet" "Public_ALB_NAT_1_Sub" {
  vpc_id                  = aws_vpc.Macro_Eyes_VPC.id
  cidr_block              = var.Public_ALB_NAT_1_Sub_Cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.project_name}-Public-ALB/NAT"
  }
}

#Creating the web private subnet AZ 2a
resource "aws_subnet" "Private_Web_1_Sub" {
  vpc_id            = aws_vpc.Macro_Eyes_VPC.id
  cidr_block        = var.Private_Web_1_Sub_Cidr
  availability_zone = data.aws_availability_zones.available_zones.names[0]


  tags = {
    Name = "${var.project_name}-Private-Web"
  }
}

#Creating the DB private subnet AZ 2a
resource "aws_subnet" "Private_DB_1_Sub" {
  vpc_id                  = aws_vpc.Macro_Eyes_VPC.id
  cidr_block              = var.Private_DB_1_Sub_Cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]

  tags = {
    "Name" = "${var.project_name}-Private-DB"
  }
}

#Creating public ALB NAT server subnet AZ 2b
resource "aws_subnet" "Public_ALB_NAT_2_Sub" {
  vpc_id                  = aws_vpc.Macro_Eyes_VPC.id
  cidr_block              = var.Public_ALB_NAT_2_Sub_Cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.project_name}-Public-ALB/NAT"
  }
}

#Creating the web private subnet AZ 2a
resource "aws_subnet" "Private_Web_2_Sub" {
  vpc_id            = aws_vpc.Macro_Eyes_VPC.id
  cidr_block        = var.Private_Web_2_Sub_Cidr
  availability_zone = data.aws_availability_zones.available_zones.names[1]


  tags = {
    Name = "${var.project_name}-Private-Web"
  }
}

#Creating the DB private subnet AZ 2a
resource "aws_subnet" "Private_DB_2_Sub" {
  vpc_id                  = aws_vpc.Macro_Eyes_VPC.id
  cidr_block              = var.Private_DB_2_Sub_Cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]

  tags = {
    "Name" = "${var.project_name}-Private-DB"
  }
}

#creating and attaching IGW
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Macro_Eyes_VPC.id

  tags = {
    "Name" = "${var.project_name}-IGW"
  }
}

#creating EIP for NAT 1
resource "aws_eip" "EIP1" {
  vpc = true

  tags = {
    "Name" = "${var.project_name}-EIP-1"
  }
}

#creating EIP for NAT 2
resource "aws_eip" "EIP2" {
  vpc = true

  tags = {
    "Name" = "${var.project_name}-EIP-2"
  }
}

#creating NAT Gateway for AZ2a
resource "aws_nat_gateway" "NAT1" {
  allocation_id = aws_eip.EIP1.id
  subnet_id     = aws_subnet.Public_ALB_NAT_1_Sub.id
  tags = {
    "Name" ="${var.project_name}-NAT-1"
  }
}

#creating NAT Gateway for AZ2b
resource "aws_nat_gateway" "NAT2" {
  allocation_id = aws_eip.EIP2.id
  subnet_id     = aws_subnet.Public_ALB_NAT_2_Sub.id
  tags = {
    "Name" = "${var.project_name}-NAT-2"
  }
}

#creating a public route table
resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.Macro_Eyes_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    "Name" = "${var.project_name}-Pub-RT"
  }
}

#creating a private route table for AZ 2a
resource "aws_route_table" "Private_RT1" {
  vpc_id = aws_vpc.Macro_Eyes_VPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT1.id
  }

  tags = {
    "Name" = "${var.project_name}-Pri-RT-1"
  }
}

#creating a private route table for AZ 2b
resource "aws_route_table" "Private_RT2" {
  vpc_id = aws_vpc.Macro_Eyes_VPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT2.id
  }

  tags = {
    "Name" = "${var.project_name}-Pri-RT-2"
  }
}

#creating a route table association for AZ2a 1
resource "aws_route_table_association" "Pub1_RTA" {
  subnet_id      = aws_subnet.Public_ALB_NAT_1_Sub.id
  route_table_id = aws_route_table.Public_RT.id
}

#creating a route table association for AZ2b 1
resource "aws_route_table_association" "Pub2_RTA" {
  subnet_id      = aws_subnet.Public_ALB_NAT_2_Sub.id
  route_table_id = aws_route_table.Public_RT.id
}

#creating a route table association for web of AZ2a 2 
resource "aws_route_table_association" "Pri_web1_RTA_2a" {
  subnet_id      = aws_subnet.Private_Web_1_Sub.id
  route_table_id = aws_route_table.Private_RT1.id
}

#creating a route table association for db of AZ2a 2
resource "aws_route_table_association" "Pri_DB2_RTA_2a" {
  subnet_id      = aws_subnet.Private_DB_1_Sub.id
  route_table_id = aws_route_table.Private_RT1.id
}

#creating a route table association for web of AZ2b 3 
resource "aws_route_table_association" "Pri_Web1_RTA_2b" {
  subnet_id      = aws_subnet.Private_Web_2_Sub.id
  route_table_id = aws_route_table.Private_RT2.id
}

#creating a route table association for db of AZ2b 3
resource "aws_route_table_association" "Pri_DB2_RTA_2b" {
  subnet_id      = aws_subnet.Private_DB_2_Sub.id
  route_table_id = aws_route_table.Private_RT2.id
}
