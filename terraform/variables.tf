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

variable "app_port" {
  description = "The port on which the web application is running"
  type        = number
  default     = 8080
}

variable "custom_ami_id" {
  description = "The ID of the custom AMI created via packer"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
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

variable "db_storage" {
  description = "value for allocated storage for the RDS instance"
  type        = number
  default     = 20
}

variable "db_port" {
  description = "The port for the RDS instance"
  type        = number
  default     = 3306
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

variable "application_logs_path" {
  description = "The path for application logs"
  type        = string
  default     = "/logs/app.log"
}

variable "domain_name" {
  description = "Name of domain"
  type        = string
  default     = "dev.shreyaskothari.me"
}

variable "lb_target_group_deregistration_delay" {
  description = "Deregistration delay for the target group"
  type        = number
  default     = 100
}

variable "asg_max_size" {
  description = "Maximum size for the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "asg_min_size" {
  description = "Minimum size for the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_desired_capacity" {
  description = "Desired capacity for the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "low_cpu_alarm_threshold" {
  description = "Low CPU alarm threshold"
  type        = number
  default     = 10
}

variable "high_cpu_alarm_threshold" {
  description = "High CPU alarm threshold"
  type        = number
  default     = 15
}

variable "scale_down_cooldown" {
  description = "Cooldown period for scale down in sec"
  type        = number
  default     = 60
}

variable "scale_up_cooldown" {
  description = "Cooldown period for scale up in sec"
  type        = number
  default     = 60
}

variable "mailgun_api_key" {
  description = "Mailgun API key"
  type        = string
}

variable "serverless_file_path" {
  description = "Path to the serverless file"
  type        = string
  default     = "../../serverless-fork/ServerlessEmailLambda/target/ServerlessEmail.jar"
}

variable "email_expiry_min" {
  description = "Email expiry time in minutes"
  type        = number
  default     = 3
}