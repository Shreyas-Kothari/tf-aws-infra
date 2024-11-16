resource "aws_launch_template" "shreyas_asg_launch_template" {
  name          = "csye6225_asg_template"
  image_id      = var.custom_ami_id
  instance_type = var.instance_type
  #   key_name             = var.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_s3_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.shreyas_terraform_app_sg.id]
  }

  user_data = base64encode(<<-EOF
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
    echo "SNS_MAIL_TOPIC_ARN=${aws_sns_topic.shreyas_tf_sns_topic.arn}" | sudo tee -a /etc/environment
    echo "APPLICATION_BASE_URL=${var.domain_name}" | sudo tee -a /etc/environment
    echo "EMAIL_EXPIRY_MIN=${var.email_expiry_min}" | sudo tee -a /etc/environment
    source /etc/environment
    EOF
  )
}

resource "aws_autoscaling_group" "shreyas_tf_asg" {
  name             = "csye6225_asg"
  max_size         = var.asg_max_size
  min_size         = var.asg_min_size
  desired_capacity = var.asg_desired_capacity
  launch_template {
    id      = aws_launch_template.shreyas_asg_launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier       = aws_subnet.shreyas_terraform_pub_subnet[*].id
  health_check_type         = "EC2"
  health_check_grace_period = 120
  tag {
    key                 = "Name"
    value               = "CSYE6225 Auto Scaling Group"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}