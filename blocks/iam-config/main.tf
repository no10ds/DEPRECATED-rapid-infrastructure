terraform {
  backend "s3" {
    key = "iam-config/terraform.tfstate"
  }
}

module "config" {
  source = "git::https://github.com/no10ds/terraform-aws-core-modules.git//config"

  bucket_prefix                      = var.bucket_prefix
  bucket_key_prefix                  = var.bucket_prefix
  enable_lifecycle_management_for_s3 = var.enable_lifecycle_management_for_s3
}

module "iam_users" {
  source = "git::https://github.com/no10ds/terraform-aws-core-modules.git//iam-users"

  # This includes some random bits here purely for demonstrational purposes. Please use a distinct unique identifier otherwise!
  iam_account_alias = var.iam_account_alias
  iam_users         = var.iam_users
}

module "iam_resources" {
  source = "git::https://github.com/no10ds/terraform-aws-core-modules.git//iam-resources"

  # Mandatory parameter so we can't skip it
  iam_account_alias = var.iam_account_alias
  # This will make sure we're only setting the IAM account alias once, as we're operating in the same account
  set_iam_account_alias = false
}

resource "aws_iam_user_group_membership" "manual_user_memberships" {
  for_each = var.manual_users
  user     = each.key

  groups = each.value["groups"]
}
