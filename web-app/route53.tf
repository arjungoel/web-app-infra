# Route53 PHZ
resource "aws_route53_zone" "private" {
  name = "example.com"

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_record" "example_record" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "test.example.com"
  type    = "A"
#   ttl     = "300"

  alias {
    name                   = aws_lb.web_app_lb.dns_name
    zone_id                = aws_lb.web_app_lb.zone_id
    evaluate_target_health = true
  }
}
