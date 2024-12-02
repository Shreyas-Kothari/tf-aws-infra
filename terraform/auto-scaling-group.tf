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