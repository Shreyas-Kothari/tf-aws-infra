data "aws_route53_zone" "selected" {
  name = var.domain_name
}

resource "aws_route53_record" "shreyas_tf_a_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = data.aws_route53_zone.selected.name
  type    = "A"
  # ttl     = "60"
  # records = [aws_instance.web_app_instance.public_ip]
  alias {
    name                   = aws_lb.shreyas_tf_load_balancer.dns_name
    zone_id                = aws_lb.shreyas_tf_load_balancer.zone_id
    evaluate_target_health = true
  }
}