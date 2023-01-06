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
    target_bucket = data.terraform_remote_state.s3-state.outputs.log_bucket_name
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

  provisioner "local-exec" {
    command = <<EOF
      url="${var.ui_information.ui_registry_url}/${var.ui_information.ui_version}.zip"
      # curl -LO $url
      unzip ${var.ui_information.ui_version}.zip
      cd out/
      sed -i '' 's/"REACT_APP_API_URL":"https:\/\/getrapid.link"/"REACT_APP_API_URL":"${var.ui_information.rapid_api_url}"/g' __ENV.js
      aws s3 cp . s3://${aws_s3_bucket.rapid_ui.id} --recursive
    EOF
  }
}

data "aws_iam_policy_document" "cloudfront" {
  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.rapid_ui.arn}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_cloudfront_origin_access_identity.rapid_ui.iam_arn,
      ]
    }
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.rapid_ui.arn,
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_cloudfront_origin_access_identity.rapid_ui.iam_arn,
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront" {
  bucket = aws_s3_bucket.rapid_ui.id
  policy = data.aws_iam_policy_document.cloudfront.json
}
