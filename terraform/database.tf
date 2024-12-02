resource "aws_db_parameter_group" "shreyas_terraform_parameter_group" {
  family      = "mysql8.0"
  name        = "shreyas-terraform-parameter-group"
  description = "My parameter group for the CSYE 6225 course database"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "collation_server"
    value = "utf8_general_ci"
  }

  tags = {
    Name = "CSYE6225 Cloud Database Parameter Group"
  }
}

# Generate a random password for MySQL
resource "random_password" "shreyas_terraform_db_password" {
  length  = 16
  special = false
}

output "shreyas_terraform_db_password" {
  description = "The randomly generated password for the database"
  value       = random_password.shreyas_terraform_db_password.result
  sensitive   = true
}

resource "aws_db_instance" "shreyas_terraform_db_instance" {
  identifier             = "csye6225"
  engine                 = var.db_engine
  port                   = var.db_port
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_storage
  db_name                = var.db_name
  username               = var.db_username
  password               = random_password.shreyas_terraform_db_password.result
  parameter_group_name   = aws_db_parameter_group.shreyas_terraform_parameter_group.name
  publicly_accessible    = false
  multi_az               = false
  vpc_security_group_ids = [aws_security_group.shreyas_terraform_db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.shreyas_terraform_db_subnet_group.name
  skip_final_snapshot    = true
  storage_encrypted      = true
  kms_key_id             = aws_kms_key.shreyas_tf_db_kms_key.arn
  tags = {
    Name = "CSYE6225 Cloud Database instance"
  }

}