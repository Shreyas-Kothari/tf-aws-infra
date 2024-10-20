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

variable "sg_cidr" {
  description = "The CIDR block for the security group"
  type        = string
  default     = "0.0.0.0/0"
}

variable "db_engine" {
  description = "The engine for the RDS instance"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The engine version for the RDS instance"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "csye6225"
}

variable "db_username" {
  description = "The username for the RDS instance"
  type        = string
  default     = "csye6224"
}

variable "db_password" {
  description = "The password for the RDS instance"
  type        = string
  default     = "csye6225"
}