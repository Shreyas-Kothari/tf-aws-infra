
# Getting all the available availability zones dynamically
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