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

resource "aws_db_instance" "shreyas_terraform_db_instance" {
  identifier             = "csye6225"
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = 10
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = aws_db_parameter_group.shreyas_terraform_parameter_group.name
  publicly_accessible    = false
  multi_az               = false
  vpc_security_group_ids = [aws_security_group.shreyas_terraform_db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.shreyas_terraform_db_subnet_group.name
  skip_final_snapshot    = true

  tags = {
    Name = "CSYE6225 Cloud Database instance"
  }

}