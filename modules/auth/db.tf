data "aws_region" "region" {}
data "aws_caller_identity" "current" {}

resource "aws_dynamodb_table" "permissions_table" {
  name         = "${var.resource-name-prefix}_${var.permissions_table_name}"
  hash_key     = "PK"
  range_key    = "SK"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  ttl {
    attribute_name = "TTL"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = var.tags
}

resource "aws_dynamodb_table_item" "data_permissions" {
  table_name = aws_dynamodb_table.permissions_table.name
  hash_key   = aws_dynamodb_table.permissions_table.hash_key
  range_key  = aws_dynamodb_table.permissions_table.range_key

  for_each = var.data_permissions

  item = <<ITEM
      {
        "PK": {"S": "PERMISSION"},
        "SK": {"S": "${each.key}"},
        "Id": {"S": "${each.key}"},
        "Type": {"S": "${each.value.type}"},
        "Sensitivity": {"S": "${each.value.sensitivity}"}
      }
    ITEM
}

resource "aws_dynamodb_table_item" "admin_permissions" {
  table_name = aws_dynamodb_table.permissions_table.name
  hash_key   = aws_dynamodb_table.permissions_table.hash_key
  range_key  = aws_dynamodb_table.permissions_table.range_key

  for_each = var.admin_permissions

  item = <<ITEM
      {
        "PK": {"S": "PERMISSION"},
        "SK": {"S": "${each.key}"},
        "Id": {"S": "${each.key}"},
        "Type": {"S": "${each.value.type}"}
      }
    ITEM
}

resource "aws_dynamodb_table_item" "test_client_permissions" {
  table_name = aws_dynamodb_table.permissions_table.name
  hash_key   = aws_dynamodb_table.permissions_table.hash_key
  range_key  = aws_dynamodb_table.permissions_table.range_key

  item = <<ITEM
  {
    "PK": {"S": "SUBJECT"},
    "SK": {"S": "${aws_cognito_user_pool_client.test_client.id}"},
    "Id": {"S": "${aws_cognito_user_pool_client.test_client.id}"},
    "Type": {"S": "CLIENT"},
    "Permissions": {"SS": ["DATA_ADMIN","READ_ALL","USER_ADMIN","WRITE_ALL"]}
  }
  ITEM
}

data "aws_iam_policy_document" "db_access_logs_key_policy" {
  statement {
    sid = "Enable IAM User Permissions"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "Enable Logs Encryption Permissions"

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.region.name}.amazonaws.com"]
    }

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${data.aws_region.region.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.resource-name-prefix}_${var.permissions_table_name}_access_logs"]
    }
  }

  statement {
    sid = "Enable CloudTrail Encryption Permissions"

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_kms_key" "db_access_logs_key" {
  description = "This key is used to encrypt log objects"
  policy      = data.aws_iam_policy_document.db_access_logs_key_policy.json
  tags        = var.tags
}

resource "aws_cloudwatch_log_group" "db_access_logs_log_group" {
  depends_on        = [aws_kms_key.db_access_logs_key]
  name              = "${aws_dynamodb_table.permissions_table.name}_access_logs"
  retention_in_days = 90
  kms_key_id        = aws_kms_key.db_access_logs_key.arn
  tags              = var.tags
}

resource "aws_cloudtrail" "db_access_logs_trail" {
  depends_on = [
    aws_s3_bucket_policy.db_access_logs_bucket_policy,
    aws_kms_key.db_access_logs_key
  ]

  name           = "${var.resource-name-prefix}-permissions-table-access-logs"
  s3_bucket_name = aws_s3_bucket.db_access_logs.id
  s3_key_prefix  = "permissions-db-access-logs"
  kms_key_id     = aws_kms_key.db_access_logs_key.arn

  is_multi_region_trail         = true
  enable_log_file_validation    = true
  include_global_service_events = true

  event_selector {
    include_management_events = false
    data_resource {
      type = "AWS::DynamoDB::Table"
      values = [
        aws_dynamodb_table.permissions_table.arn
      ]
    }
  }

  # CloudTrail requires the Log Stream wildcard
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.db_access_logs_log_group.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloud_trail_role.arn

  tags = var.tags
}

resource "aws_iam_role" "cloud_trail_role" {
  name = "${var.resource-name-prefix}-cloudtrail-cloudwatch-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = var.tags
}

resource "aws_iam_role_policy" "aws_iam_role_policy_cloudtrail_cloudwatch" {
  name = "${var.resource-name-prefix}-cloudtrail-cloudwatch-policy"
  role = aws_iam_role.cloud_trail_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailCreateLogStream2014110",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream"
            ],
            "Resource": [
                "${aws_cloudwatch_log_group.db_access_logs_log_group.arn}:*"
            ]
        },
        {
            "Sid": "AWSCloudTrailPutLogEvents20141101",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "${aws_cloudwatch_log_group.db_access_logs_log_group.arn}:*"
            ]
        }
    ]
}
EOF
}

resource "aws_s3_bucket" "db_access_logs" {
  bucket        = "${var.resource-name-prefix}-permissions-table-access-logs"
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_policy" "db_access_logs_bucket_policy" {
  bucket = aws_s3_bucket.db_access_logs.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.db_access_logs.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.db_access_logs.arn}/*",
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

resource "aws_s3_bucket_lifecycle_configuration" "db_access_logs_lifecycle" {
  bucket = aws_s3_bucket.db_access_logs.id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    expiration {
      days = 90
    }

  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "db_access_logs_s3_encryption_config" {
  depends_on = [aws_kms_key.db_access_logs_key]
  bucket     = aws_s3_bucket.db_access_logs.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.db_access_logs_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
