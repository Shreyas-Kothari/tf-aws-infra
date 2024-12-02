resource "aws_launch_template" "shreyas_asg_launch_template" {
  name          = "csye6225_asg_template"
  image_id      = var.custom_ami_id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_s3_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.shreyas_terraform_app_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 25
      volume_type           = "gp2"
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = aws_kms_key.shreyas_tf_ec2_kms_key.arn
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    ####################################################
    #       Configuring Environment Variables          #
    ####################################################
    echo "# App Environment Variables" | sudo tee -a /etc/environment
    echo "SPRING_DATASOURCE_URL=jdbc:mysql://${aws_db_instance.shreyas_terraform_db_instance.address}:${var.db_port}/${var.db_name}" | sudo tee -a /etc/environment
    echo "S3_BUCKET_NAME=${aws_s3_bucket.shreyas_tf_s3_bucket.bucket}" | sudo tee -a /etc/environment
    echo "LOG_FILE_NAME=${var.application_logs_path}" | sudo tee -a /etc/environment
    echo "AWS_REGION=${var.aws_region}" | sudo tee -a /etc/environment
    echo "SNS_MAIL_TOPIC_ARN=${aws_sns_topic.shreyas_tf_sns_topic.arn}" | sudo tee -a /etc/environment
    echo "APPLICATION_BASE_URL=${var.domain_name}" | sudo tee -a /etc/environment
    echo "EMAIL_EXPIRY_MIN=${var.email_expiry_min}" | sudo tee -a /etc/environment
    echo "SECRET_NAME=${aws_secretsmanager_secret.shreyas_tf_secret.name}" | sudo tee -a /etc/environment
    source /etc/environment
    EOF
  )
}