output "tags" {
    value = var.tags
    description = "The tags used in the project"
}

output "bucket_public_arn" {
    value = aws_s3_bucket.rapid_ui_release_storage.arn
    description = "The arn of the public S3 bucket"
}