variable "aws_region" {
  type        = string
  description = "The Region for our VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "The cidr for the VPC"
}

variable "privateSubnetCount" {
  type        = number
  description = "Count of private Subnets"
}

variable "publicSubnetCount" {
  type        = number
  description = "Count of public Subnets"
}
