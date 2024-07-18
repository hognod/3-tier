data "aws_route53_zone" "public_hosted_zone" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_zone" "private_hosted_zone" {
  name = var.hosted_zone_name
  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_record" "web-lb" {
  zone_id = data.aws_route53_zone.public_hosted_zone.zone_id
  name    = "web.${var.hosted_zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = [ aws_lb.web.dns_name ]
}

resource "aws_route53_record" "was-lb" {
  zone_id = aws_route53_zone.private_hosted_zone.zone_id
  name    = "was.${var.hosted_zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = [ aws_lb.was.dns_name ]
}

resource "aws_route53_record" "db-lb" {
  zone_id = aws_route53_zone.private_hosted_zone.zone_id
  name    = "db.${var.hosted_zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = [ aws_lb.db.dns_name ]
}