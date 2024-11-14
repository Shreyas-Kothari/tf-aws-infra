# Define the security group for the web application
resource "aws_security_group" "shreyas_terraform_app_sg" {
  name        = "csye6225_app_security_group"
  description = "Security group for web application"
  vpc_id      = aws_vpc.shreyas_terraform_vpc.id

  # Ingress rule for SSH (port 22)
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.sg_cidr]
  }

  # since load balancer added, remove the below rules
  # Ingress rule for HTTP (port 80)
  # ingress {
  #   description = "Allow HTTP"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = [var.sg_cidr]
  # }

  # # Ingress rule for HTTPS (port 443)
  # ingress {
  #   description = "Allow HTTPS"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = [var.sg_cidr]
  # }

  # Ingress rule for traffic from load balancer on application port (8080)
  ingress {
    description = "Allow Application Traffic"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    # cidr_blocks = [var.sg_cidr]
    security_groups = [aws_security_group.shreyas_terraform_lb_sg.id]
  }

  # Outbound rule for all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "CSYE6225 Application Security Group",
    Description = "Security group for the web application in CSYE 6225 course Spring Boot Application"
  }
}

# Database security Group
resource "aws_security_group" "shreyas_terraform_db_sg" {
  name        = "database security group"
  description = "Security group for database for the CSYE 6225 course"
  vpc_id      = aws_vpc.shreyas_terraform_vpc.id

  # Ingress rule for MySQL (port 3306)
  ingress {
    description     = "Allow MySQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.shreyas_terraform_app_sg.id]
  }

  # Outbound rule for all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "CSYE6225 Database Security Group",
    Description = "Security group for the database in CSYE 6225 course"
  }
}

# Load Balancer security Group
resource "aws_security_group" "shreyas_terraform_lb_sg" {
  name        = "csye6225_lb_security_group"
  description = "Security group for load balancer"
  vpc_id      = aws_vpc.shreyas_terraform_vpc.id

  # Allow HTTP (port 80) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS (port 443) from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CSYE6225 Load Balancer Security Group"
  }
}

resource "aws_security_group" "shreyas_terraform_lambda_sg" {
  name        = "csye6225_lambda_security_group"
  description = "Security group for lambda"
  vpc_id      = aws_vpc.shreyas_terraform_vpc.id

  # Allow HTTP (port 80) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CSYE6225 Lambda Security Group"
  }
}