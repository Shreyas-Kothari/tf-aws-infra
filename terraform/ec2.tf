# Random integer to get the index of the public subnet
resource "random_integer" "random_subnet_index" {
  min = 0
  max = var.publicSubnetCount - 1
}

# Define the EC2 instance
resource "aws_instance" "web_app_instance" {
  ami                         = var.custom_ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.shreyas_terraform_app_sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.shreyas_terraform_pub_subnet[random_integer.random_subnet_index.result].id # select a random public subnet

  # Attach the IAM role to the EC2 instance to access S3
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_instance_profile.name

  # Root volume configuration
  root_block_device {
    delete_on_termination = true
    volume_size           = 25
    volume_type           = "gp2"
  }

  user_data = <<-EOF
    #!/bin/bash
    ####################################################
    #       Configuring Environment Variables          #
    ####################################################
    echo "# App Environment Variables" | sudo tee -a /etc/environment
    echo "SPRING_DATASOURCE_URL=jdbc:mysql://${aws_db_instance.shreyas_terraform_db_instance.address}:${var.db_port}/${var.db_name}" | sudo tee -a /etc/environment
    echo "SPRING_DATASOURCE_USERNAME=${var.db_username}" | sudo tee -a /etc/environment
    echo "SPRING_DATASOURCE_PASSWORD=${random_password.shreyas_terraform_db_password.result}" | sudo tee -a /etc/environment
    echo "S3_BUCKET_NAME=${aws_s3_bucket.shreyas_tf_s3_bucket.bucket}" | sudo tee -a /etc/environment
    echo "LOG_FILE_NAME=${var.application_logs_path}" | sudo tee -a /etc/environment
    echo "AWS_REGION=${var.aws_region}" | sudo tee -a /etc/environment
    source /etc/environment
    EOF

  # Disable accidental termination protection
  disable_api_termination = false

  depends_on = [aws_db_instance.shreyas_terraform_db_instance]

  tags = {
    Name = "CSYE6225 Spring Boot Application"
  }
}
