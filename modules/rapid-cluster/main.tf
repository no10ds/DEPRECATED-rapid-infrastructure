module "app_cluster" {
  # source = "git@github.com:no10ds/rapid-infrastructure.git//modules/app-cluster?ref=1c44ef9aaad8e037279c0972772174c5c246c59a"
  source                                          = "../app-cluster"
  app-replica-count-desired                       = var.app-replica-count-desired
  app-replica-count-max                           = var.app-replica-count-max
  resource-name-prefix                            = var.resource-name-prefix
  application_version                             = var.application_version
  support_emails_for_cloudwatch_alerts            = var.support_emails_for_cloudwatch_alerts
  cognito_user_login_app_credentials_secrets_name = module.auth.cognito_user_app_secret_manager_name
  cognito_user_pool_id                            = module.auth.cognito_user_pool_id
  domain_name                                     = var.domain_name
  rapid_ecr_url                                   = var.rapid_ecr_url
  certificate_validation_arn                      = var.certificate_validation_arn
  hosted_zone_id                                  = var.hosted_zone_id
  aws_account                                     = var.aws_account
  aws_region                                      = var.aws_region
  data_s3_bucket_arn                              = aws_s3_bucket.this.arn
  data_s3_bucket_name                             = aws_s3_bucket.this.id
  log_bucket_name                                 = var.log_bucket_name
  vpc_id                                          = var.vpc_id
  public_subnet_ids_list                          = var.public_subnet_ids_list
  private_subnet_ids_list                         = var.private_subnet_ids_list
#  parameter_store_variable_arns                   = [module.auth.protected_scopes_parameter_store_arn]
  athena_query_output_bucket_arn = module.data_workflow.athena_query_result_output_bucket_arn
  ip_whitelist                   = var.ip_whitelist
  allowed_email_domains                           = "example.com"
  permissions_table                               = var.user_permission_table_name
}


module "auth" {
  source               = "../auth"
  tags                 = var.tags
  domain_name          = var.domain_name
  resource-name-prefix = var.resource-name-prefix
}

module "data_workflow" {
  source               = "../data-workflow"
  resource-name-prefix = var.resource-name-prefix
  aws_account          = var.aws_account
  data_s3_bucket_arn   = aws_s3_bucket.this.arn
  data_s3_bucket_name  = aws_s3_bucket.this.id
  vpc_id               = var.vpc_id
  private_subnet       = var.private_subnet_ids_list[0]
  aws_region           = var.aws_region
}

resource "aws_s3_bucket" "this" {
  # checkov:skip=CKV_AWS_144:No need for cross region replication
  bucket = var.resource-name-prefix
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "logs" {
  # checkov:skip=CKV_AWS_144:No need for cross region replication
  bucket = var.log_bucket_name
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}