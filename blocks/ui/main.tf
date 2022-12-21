terraform {
  backend "s3" {
    key = "ui/terraform.tfstate"
  }
}

data "terraform_remote_state" "s3-state" {
  backend = "s3"

  config = {
    key    = "s3/terraform.tfstate"
    bucket = var.state_bucket
  }
}

resource "aws_s3_bucket" "rapid_ui_release_storage" {
  #checkov:skip=CKV_AWS_144:No need for cross region replication
  #checkov:skip=CKV_AWS_145:No need for non default key

  bucket        = "ui-f1-registry"
  force_destroy = true
  tags          = var.tags

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.logs.bucket
    target_prefix = "log/ui-f1-registry"
  }
}

resource "aws_s3_bucket_acl" "rapid_ui_release_storage_acl" {
  bucket = aws_s3_bucket.rapid_ui_release_storage.id
  acl    = "public-read"
}

resource "aws_s3_bucket" "logs" {
  #checkov:skip=CKV_AWS_144:No need for cross region replication
  #checkov:skip=CKV_AWS_145:No need for non default key
  #checkov:skip=CKV_AWS_18:Log bucket shouldn't be logging
  #checkov:skip=CKV_AWS_21:No need to version log bucket
  bucket        = "ui-f1-registry-logs"
  force_destroy = false
  tags          = var.tags

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "" # use default
        sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_acl" "logs_acl" {
  bucket = aws_s3_bucket.logs.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}
