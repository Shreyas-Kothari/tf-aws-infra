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

variable "availability_zones" {
  type        = list(string)
  description = "The list of availability zones for the subnet"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
