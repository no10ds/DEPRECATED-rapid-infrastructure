resource "aws_route53_zone" "primary-hosted-zone" {
  count = var.hosted_zone_id == "" ? 1 : 0
  name  = var.domain_name
  tags  = var.tags
}

resource "aws_route53_record" "route-to-lb" {
  #checkov:skip=CKV2_AWS_23:Record is within AWS Account
  zone_id = var.hosted_zone_id != "" ? var.hosted_zone_id : aws_route53_zone.primary-hosted-zone[0].zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_alb.application_load_balancer.dns_name
    zone_id                = aws_alb.application_load_balancer.zone_id
    evaluate_target_health = true
  }
}

# Create the certificate
resource "aws_acm_certificate" "rapid-certificate" {
  count             = var.certificate_validation_arn == "" ? 1 : 0
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}


locals {
  domain_validation_options = var.certificate_validation_arn == "" ? aws_acm_certificate.rapid-certificate[0].domain_validation_options : []
}
# Add the Route53 validation record
resource "aws_route53_record" "rapid_validation_record" {
  for_each = {
  for dvo in local.domain_validation_options : dvo.domain_name => {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }
  }

  zone_id = var.hosted_zone_id != "" ? var.hosted_zone_id : aws_route53_zone.primary-hosted-zone[0].zone_id
  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type

}

# Wait for validate the certificate
resource "aws_acm_certificate_validation" "rapid-certificate-validation" {
  count                   = var.certificate_validation_arn == "" ? 1 : 0
  certificate_arn         = aws_acm_certificate.rapid-certificate[0].arn
  validation_record_fqdns = [for record in aws_route53_record.rapid_validation_record : record.fqdn]
}
