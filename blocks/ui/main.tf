terraform {
  backend "s3" {
    key = "ui/terraform.tfstate"
  }
}

module "ui" {
  source = "../../modules/ui"

  resource-name-prefix = var.resource-name-prefix

  load_balancer_dns = data.terraform_remote_state.app-cluster-state.outputs.load_balancer_dns

  ui_information             = var.ui_information
  aws_account                = var.aws_account
  state_bucket               = var.state_bucket
  log_bucket_name            = var.log_bucket_name
  certificate_validation_arn = var.certificate_validation_arn
  domain_name                = var.domain_name
  hosted_zone_id             = var.hosted_zone_id != "" ? var.hosted_zone_id : data.terraform_remote_state.app-cluster-state.outputs.hosted_zone_id
  ip_whitelist               = var.ip_whitelist
  tags                       = var.tags
}

data "terraform_remote_state" "s3-state" {
  backend = "s3"

  config = {
    key    = "s3/terraform.tfstate"
    bucket = var.state_bucket
  }
}

data "terraform_remote_state" "app-cluster-state" {
  backend = "s3"

  config = {
    key    = "app-cluster/terraform.tfstate"
    bucket = var.state_bucket
  }
}

provider "aws" {
  alias  = "us_east"
  region = "us-east-1"

  default_tags {
    tags = var.tags
  }
}

resource "aws_cloudfront_origin_access_identity" "rapid_ui" {}
