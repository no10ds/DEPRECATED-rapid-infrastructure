resource "aws_glue_catalog_database" "catalogue_db" {
  name = "${var.resource-name-prefix}_catalogue_db"
}

resource "aws_glue_connection" "glue_connection" {
  name            = "s3-network-connection"
  connection_type = "NETWORK"

  physical_connection_requirements {
    availability_zone      = data.aws_availability_zones.available.names[0]
    security_group_id_list = [aws_security_group.glue_connection_sg.id]
    subnet_id              = var.private_subnet
  }
}

resource "aws_glue_classifier" "custom_csv_classifier" {
  name = "single_column_csv_classifier"

  csv_classifier {
    allow_single_column    = true
    contains_header        = "PRESENT"
    delimiter              = ","
    disable_value_trimming = false
    quote_symbol           = "\""
  }
}

resource "aws_iam_role" "glue_service_role" {
  name        = "glue_services_access"
  description = "Allow AWS Glue service to access S3 via crawler"
  tags        = var.tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "crawler_s3_policy" {
  name        = "crawler_data_access_policy"
  description = "Allow crawler to access data in s3 bucket"
  tags        = var.tags

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "${var.data_s3_bucket_arn}/data/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "glue_service_role_s3_policy_attach" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = aws_iam_policy.crawler_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "glue_service_role_managed_policy_attach" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_cloudwatch_log_group" "aws_glue_crawlers_log_group" {
  #checkov:skip=CKV_AWS_158:No need for KMS
  name              = "/aws-glue/crawlers"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "aws_glue_connection_error_log_group" {
  #checkov:skip=CKV_AWS_158:No need for KMS
  name              = "/aws-glue/testconnection/error/s3-network-connection"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "aws_glue_connection_log_group" {
  #checkov:skip=CKV_AWS_158:No need for KMS
  name              = "/aws-glue/testconnection/output/s3-network-connection"
  retention_in_days = 90
}
