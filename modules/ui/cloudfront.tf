resource "aws_cloudfront_origin_access_identity" "rapid_ui" {}

resource "aws_cloudfront_origin_request_policy" "rapid_ui_lb" {
  name = "${var.resource-name-prefix}-api-lb-request-policy"

  cookies_config {
    cookie_behavior = "all"
  }

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Host", "Accept", "Origin", "Referer"]
    }
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}

resource "aws_cloudfront_distribution" "rapid_ui" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  aliases             = ["${var.domain_name}"]
  web_acl_id          = aws_wafv2_web_acl.rapid_acl.arn

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.rapid-certificate[0].arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  origin {
    domain_name = aws_s3_bucket.rapid_ui.website_endpoint
    origin_id   = "${var.resource-name-prefix}-ui-origin"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  origin {
    domain_name = var.load_balancer_dns
    origin_id   = "${var.resource-name-prefix}-api-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["GB"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.resource-name-prefix}-ui-origin"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["HEAD", "GET"]
    target_origin_id       = "${var.resource-name-prefix}-api-origin"
    viewer_protocol_policy = "redirect-to-https"
    path_pattern           = "/api/*"

    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    origin_request_policy_id = aws_cloudfront_origin_request_policy.rapid_ui_lb.id
  }

  logging_config {
    bucket          = "${var.log_bucket_name}.s3.amazonaws.com"
    prefix          = "${var.resource-name-prefix}-cloudfront"
    include_cookies = true
  }
}

resource "aws_route53_record" "route-to-cloudfront" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.rapid_ui.domain_name
    zone_id                = aws_cloudfront_distribution.rapid_ui.hosted_zone_id
    evaluate_target_health = false
  }
}

locals {
  domain_validation_options = var.certificate_validation_arn == "" ? aws_acm_certificate.rapid-certificate[0].domain_validation_options : []
}

resource "aws_route53_record" "rapid-validation_record" {
  for_each = {
    for dvo in local.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.hosted_zone_id
  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
  ttl     = 60
}

resource "aws_acm_certificate" "rapid-certificate" {
  provider          = aws.us_east
  count             = var.certificate_validation_arn == "" ? 1 : 0
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
