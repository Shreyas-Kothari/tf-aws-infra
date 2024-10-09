# Defining the VPC
resource "aws_vpc" "shreyas_terraform_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "VPC Terraform Cloud"
  }
}

# Getting all the available availability zones dynamizally
data "aws_availability_zones" "terraform_availability_zones" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Defining the public subnet 
resource "aws_subnet" "shreyas_terraform_pub_subnet" {
  count                   = var.publicSubnetCount
  vpc_id                  = aws_vpc.shreyas_terraform_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.terraform_availability_zones.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Terraform public subnet ${count.index + 1}"
  }
}

# Defining the private subnet
resource "aws_subnet" "shreyas_terraform_pvt_subnet" {
  count             = var.privateSubnetCount
  vpc_id            = aws_vpc.shreyas_terraform_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + var.publicSubnetCount)
  availability_zone = element(data.aws_availability_zones.terraform_availability_zones.names, count.index)
  tags = {
    Name = "Terraform private subnet ${count.index + 1}"
  }
}

# Defining the internet gateway
resource "aws_internet_gateway" "shreyas_terraform_gw" {
  vpc_id = aws_vpc.shreyas_terraform_vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

#Defining the public route table for the VPC
resource "aws_route_table" "shreyas_terraform_rt_public" {
  vpc_id = aws_vpc.shreyas_terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.shreyas_terraform_gw.id
  }

  tags = {
    Name = "Public Route table for VPC Terraform Cloud"
  }
}

#Defining the private route table for the VPC
resource "aws_route_table" "shreyas_terraform_rt_private" {
  vpc_id = aws_vpc.shreyas_terraform_vpc.id

  tags = {
    Name = "Private Route table for VPC Terraform Cloud"
  }
}

# Associating the public subnet
resource "aws_route_table_association" "terraform_rt_association_public" {
  count          = var.publicSubnetCount
  route_table_id = aws_route_table.shreyas_terraform_rt_public.id
  subnet_id      = aws_subnet.shreyas_terraform_pub_subnet[count.index].id
}

# Associating the private subnet
resource "aws_route_table_association" "terraform_rt_association_private" {
  count          = var.privateSubnetCount
  route_table_id = aws_route_table.shreyas_terraform_rt_private.id
  subnet_id      = aws_subnet.shreyas_terraform_pvt_subnet[count.index].id
}