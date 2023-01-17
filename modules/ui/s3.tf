resource "aws_s3_bucket" "rapid_ui" {
  #checkov:skip=CKV_AWS_144:No need for cross region replication
  #checkov:skip=CKV_AWS_145:No need for non default key

  bucket        = var.ui_information.bucket_name
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

resource "null_resource" "upload_static_ui" {
  depends_on = [
    aws_s3_bucket.rapid_ui
  ]

  triggers = {
    ui_version = var.ui_information.ui_version
  }

  provisioner "local-exec" {
    command = <<EOF
      url="${var.ui_information.ui_registry_url}/${var.ui_information.ui_version}.zip"
      # curl -LO $url
      unzip -o ${var.ui_information.ui_version}.zip
      cd out/
      sed -i '' 's/"REACT_APP_API_URL":"http:\/\/changeme.link\/api"/"REACT_APP_API_URL":"https:\/\/${var.domain_name}\/api"/g' __ENV.js
      aws s3 cp . s3://${aws_s3_bucket.rapid_ui.id} --recursive
    EOF
  }
}

data "aws_iam_policy_document" "cloudfront" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.rapid_ui.arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

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
      test     = "StringLike"
      variable = "aws:Referer"
      values = [
        "http://${var.domain_name}/*",
        "https://${var.domain_name}/*"
      ]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront" {
  bucket = aws_s3_bucket.rapid_ui.id
  policy = data.aws_iam_policy_document.cloudfront.json
}
