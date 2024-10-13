# Random integer to get the index of the public subnet
resource "random_integer" "random_subnet_index" {
  min = 0
  max = var.publicSubnetCount - 1
}

# Define the EC2 instance
resource "aws_instance" "web_app_instance" {
  ami                         = var.custom_ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.shreyas_terraform_sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.shreyas_terraform_pub_subnet[random_integer.random_subnet_index.result].id # select a random public subnet

  # Root volume configuration
  root_block_device {
    delete_on_termination = true
    volume_size           = 25
    volume_type           = "gp2"
  }

  # Disable accidental termination protection
  disable_api_termination = false

  tags = {
    Name = "CSYE6225 Spring Boot Application"
  }
}
