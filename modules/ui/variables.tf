variable "tags" {
  type        = map(string)
  description = "A common map of tags for all VPC resources that are created (for e.g. billing purposes)"
}

variable "state_bucket" {
  type        = string
  description = "Bucket name for backend state"
}

variable "log_bucket_name" {
  type        = string
  description = "A bucket to send the Cloudfront logs"
}

variable "certificate_validation_arn" {
  type        = string
  description = "Arn of the certificate used by the domain"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the rAPId instance"
}

variable "hosted_zone_id" {
  type        = string
  description = "Hosted Zone ID with the domain Name Servers, pass quotes to create a new one from scratch"
}

variable "ip_whitelist" {
  type        = list(string)
  description = "A list of IPs to whitelist for access to the service"
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
    bucket_name     = string
  })

  description = <<EOT
    ui_information = {
      ui_registry_url: "Url location for the built static ui"
      ui_version: "Version number for the built ui static files (e.g.: v5.0)"
      bucket_name: "The name of the S3 bucket that hosts the static ui files"
    }
  EOT
}

variable "load_balancer_dns" {
  type        = string
  description = "The DNS name of the load balancer"
}
