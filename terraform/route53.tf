data "aws_route53_zone" "selected" {
  name = var.domain_name
}

resource "aws_route53_record" "shreyas_tf_a_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = data.aws_route53_zone.selected.name
  type    = "A"
  ttl     = "60"
  records = [aws_instance.web_app_instance.public_ip]
}