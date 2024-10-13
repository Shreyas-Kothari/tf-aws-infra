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

variable "app_port" {
  description = "The port on which the web application is running"
  type        = number
}

variable "custom_ami_id" {
  description = "The ID of the custom AMI created via packer"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
}