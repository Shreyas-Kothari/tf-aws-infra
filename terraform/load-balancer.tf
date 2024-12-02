resource "aws_lb" "shreyas_tf_load_balancer" {
  name               = "csye6225-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.shreyas_terraform_lb_sg.id]
  subnets            = aws_subnet.shreyas_terraform_pub_subnet[*].id
}

resource "aws_lb_target_group" "shreyas_tf_alb_target_group" {
  name     = "csye6225-app-tg"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.shreyas_terraform_vpc.id
  health_check {
    path                = "/healthz"
    protocol            = "HTTP"
    interval            = 30 # Interval between health checks
    timeout             = 5  # Health check timeout
    healthy_threshold   = 2  # Healthy after 2 consecutive successes
    unhealthy_threshold = 2  # Unhealthy after 2 consecutive failures
  }
  deregistration_delay = var.lb_target_group_deregistration_delay
}

# resource "aws_lb_listener" "shreyas_tf_alb_listener" {
#   load_balancer_arn = aws_lb.shreyas_tf_load_balancer.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.shreyas_tf_alb_target_group.arn
#   }
# }

resource "aws_lb_listener" "shreyas_tf_alb_listener_https" {
  load_balancer_arn = aws_lb.shreyas_tf_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "arn:aws:acm:us-east-1:762233742104:certificate/a2b57bc8-2f83-4caa-a4c8-d998a2e95500"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shreyas_tf_alb_target_group.arn
  }
}

resource "aws_autoscaling_attachment" "asg_lb_attachment" {
  lb_target_group_arn    = aws_lb_target_group.shreyas_tf_alb_target_group.arn
  autoscaling_group_name = aws_autoscaling_group.shreyas_tf_asg.name
}
