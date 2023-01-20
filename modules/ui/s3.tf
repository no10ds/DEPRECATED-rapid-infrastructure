resource "random_uuid" "bucket_id" {
}

resource "aws_s3_bucket" "rapid_ui" {
  #checkov:skip=CKV_AWS_144:No need for cross region replication
  #checkov:skip=CKV_AWS_145:No need for non default key
  #checkov:skip=CKV_AWS_19:No need for securely encrypted at rest
  #checkov:skip=CKV2_AWS_6: No need for public access block
  bucket        = "${var.resource-name-prefix}-static-ui-${random_uuid.bucket_id.result}"
  force_destroy = true
  tags          = var.tags

  versioning {
    enabled = true
  }

  logging {
    target_bucket = var.log_bucket_name
    target_prefix = "log/ui-f1-registry"
  }
}

resource "aws_s3_bucket_acl" "rapid_ui_storage_acl" {
  bucket = aws_s3_bucket.rapid_ui.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "rapid_ui_website" {
  bucket = aws_s3_bucket.rapid_ui.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

locals {
  ui_registry_url = "https://github.com/no10ds/rapid-ui/archive/ref/tags"
  # ui_registry_url = "https://github.com/no10ds/rapid-ui/archive/refs/tags"
  ui_envs = jsonencode({
    "REACT_APP_API_URL" = "https://${var.domain_name}/api"
  })
}

resource "null_resource" "download_static_ui" {
  depends_on = [
    aws_s3_bucket.rapid_ui
  ]

  triggers = {
    ui_version = var.ui_version
  }

  provisioner "local-exec" {
    command = templatefile("./scripts/ui.sh.tpl", {
      REGISTRY_URL = local.ui_registry_url,
      VERSION      = var.ui_version,
      ENVS         = local.ui_envs,
      BUCKET_ID    = aws_s3_bucket.rapid_ui.id
    })
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      "${aws_s3_bucket.rapid_ui.arn}",
      "${aws_s3_bucket.rapid_ui.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:UserAgent"
      values = [
        "${random_string.random_cloudfront_header.result}",
      ]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "s3" {
  bucket = aws_s3_bucket.rapid_ui.id
  policy = data.aws_iam_policy_document.s3.json
}
