terraform {
  backend "s3" {
    key = "ui/terraform.tfstate"
  }
}

provider "aws" {
  alias  = "us_east"
  region = "us-east-1"

  default_tags {
    tags = var.tags
  }
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

resource "aws_cloudfront_origin_access_identity" "rapid_ui" {}
