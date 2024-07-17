data "aws_route53_zone" "hosted_zone" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "web-lb" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "web.${var.hosted_zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = [ aws_lb.web.dns_name ]
}

resource "aws_route53_record" "was-lb" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "was.${var.hosted_zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = [ aws_lb.was.dns_name ]
}