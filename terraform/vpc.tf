# Defining the VPC
resource "aws_vpc" "shreyas_terraform_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "VPC Terraform Cloud"
  }
}