resource "aws_alb" "application_load_balancer" {
  #checkov:skip=CKV_AWS_150:No need for deletion protection
  name                       = "${var.resource-name-prefix}-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = var.public_subnet_ids_list
  security_groups            = [aws_security_group.load_balancer_security_group.id]
  drop_invalid_header_fields = true

  access_logs {
    bucket  = var.log_bucket_name
    prefix  = "${var.resource-name-prefix}-alb"
    enabled = true
  }

  tags = var.tags
}

data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket_policy" "allow_alb_logging" {
  bucket = var.log_bucket_name
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSLogDeliveryWrite",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_elb_service_account.main.arn}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.log_bucket_name}/${var.resource-name-prefix}-alb/AWSLogs/${var.aws_account}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_security_group" "load_balancer_security_group" {
  vpc_id      = var.vpc_id
  description = "ALB Security Group"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ip_whitelist
    description = "Allow HTTP ingress"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ip_whitelist
    description = "Allow HTTPS ingress"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all egress"
  }
  tags = var.tags
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.resource-name-prefix}-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 3
    interval            = 300
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 3
    path                = "/status"
    unhealthy_threshold = 2
  }

  tags = var.tags
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_validation_arn != "" ? var.certificate_validation_arn : aws_acm_certificate_validation.rapid-certificate-validation[0].certificate_arn
  tags              = var.tags
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"
  tags              = var.tags

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_wafv2_web_acl" "rapid_acl" {
  #checkov:skip=CKV2_AWS_31:Already have a logging configuration
  name  = "${var.resource-name-prefix}-acl"
  scope = "REGIONAL"
  tags  = var.tags

  default_action {
    block {}
  }

  rule {
    name     = "validate-request"
    priority = 1

    action {
      allow {}
    }

    statement {
      and_statement {
        statement {
          byte_match_statement {
            positional_constraint = "EXACTLY"

            search_string = var.domain_name
            field_to_match {
              single_header {
                name = "host"
              }
            }
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
        statement {
          not_statement {
            statement {
              sqli_match_statement {
                field_to_match {
                  body {}
                }
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "validate-request"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "aws-known-bad-input"
      sampled_requests_enabled   = true
    }
  }


  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.resource-name-prefix}-acl"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "alb-acl-association" {
  resource_arn = aws_alb.application_load_balancer.arn
  web_acl_arn  = aws_wafv2_web_acl.rapid_acl.arn
}