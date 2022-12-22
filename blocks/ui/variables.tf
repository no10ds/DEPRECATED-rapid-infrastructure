variable "tags" {
  type        = map(string)
  description = "A common map of tags for all VPC resources that are created (for e.g. billing purposes)"
}

variable "state_bucket" {
  type        = string
  description = "Bucket name for backend state"
}

variable "resource-name-prefix" {
  type        = string
  description = "The prefix to add to resources for easier identification"
}

variable "aws_account" {
  type        = string
  description = "AWS Account number to host the rAPId service"
}

variable "ui_information" {
  type = object({
    ui_registry_url = string,
    ui_version      = string,
    bucket_name     = string,
    rapid_api_url   = string # Do we want these another object for env variables?
  })

  description = <<EOT
    ui_information = {
      ui_registry_url: "Url location for the built static ui"
      ui_version: "Version number for the built ui static files (e.g.: v5.0)"
      bucket_name: "The name of the S3 bucket that hosts the static ui files"
      rapid_api_url: "The url of the rapid instance that the ui will request"
    }
  EOT
}
