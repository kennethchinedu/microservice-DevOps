#Resouce for VPC



resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

###### RESOURCES FOR AVAILABILITY ZONES ######

#Public Subnet for az zone 1
resource "aws_subnet" "pubsub1" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.availability_zones[0]
  cidr_block = var.subnet_cidr[0]
  map_public_ip_on_launch = true
}
#Private Subnet for az zone 1
resource "aws_subnet" "prisub1" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.availability_zones[0]
  cidr_block = var.subnet_cidr[1] 
  map_public_ip_on_launch = false
}

#Public Subnet for az zone 2
resource "aws_subnet" "pubsub2" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.availability_zones[1]
  cidr_block = var.subnet_cidr[2]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "prisub2" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.availability_zones[1]
  cidr_block = var.subnet_cidr[3]
  map_public_ip_on_launch = false
}
