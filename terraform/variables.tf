variable "aws_region" {
  type        = string
  description = "The Region for our VPC"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "The cidr for the VPC"
  default     = "10.0.0.0/16"
}

variable "privateSubnetCount" {
  type        = number
  description = "Count of private Subnets"
  default     = 3
}

variable "publicSubnetCount" {
  type        = number
  description = "Count of public Subnets"
  default     = 3
}
