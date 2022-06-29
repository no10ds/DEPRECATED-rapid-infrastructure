variable "tags" {
  type        = map(string)
  description = "A common map of tags for all VPC resources that are created (for e.g. billing purposes)"
  default = {
    Resource = "data-f1-rapid"
  }
}

variable "resource-name-prefix" {
  type        = string
  description = "The prefix to add to resources for easier identification"
}

variable "app-replica-count-desired" {
  type        = number
  description = "The desired number of replicas of the app"
  default     = 1
}

variable "app-replica-count-max" {
  type        = number
  description = "The maximum desired number of replicas of the app"
  default     = 2
}

variable "container_port" {
  type        = number
  description = "The port for the running ECS containers"
  default     = 8000
}

variable "host_port" {
  type        = number
  description = "The host port for the running ECS containers"
  default     = 8000
}

variable "rapid_ecr_url" {
  type        = string
  description = "ECR Url for task definition"
}

variable "data_s3_bucket_arn" {
  type        = string
  description = "S3 Bucket arn to store application data"
}

variable "data_s3_bucket_name" {
  type        = string
  description = "S3 Bucket name to store application data"
}

variable "vpc_id" {
  type        = string
  description = "Application VPC"
}

variable "private_subnet_ids_list" {
  type        = list(string)
  description = "Application Private subnet list"
}

variable "public_subnet_ids_list" {
  type        = list(string)
  description = "Application Public subnet list"
}

variable "application_version" {
  type        = string
  description = "The version number for the application image (e.g.: v1.0.4, v1.0.x-latest, etc.)"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the rAPId instance"
}

variable "aws_account" {
  type        = string
  description = "AWS Account number to host the rAPId service"
}

variable "hosted_zone_id" {
  type        = string
  description = "Hosted Zone ID with the domain Name Servers, pass quotes to create a new one from scratch"
}

variable "certificate_validation_arn" {
  type        = string
  description = "Arn of the certificate used by the domain"
}

variable "ip_whitelist" {
  type        = list(string)
  description = "A list of IPs to whitelist for access to the service"
}

variable "athena_query_output_bucket_arn" {
  type        = string
  description = "The S3 bucket ARN where Athena stores its query results. This bucket is created dynamically with a unique name in the data-workflow module. Reference it by remote state, module output or ARN string directly"
}

variable "cognito_user_pool_id" {
  type        = string
  description = "User pool id for cognito"
}

variable "cognito_user_login_app_credentials_secrets_name" {
  type        = string
  description = "Secret name for Cognito user login app credentials"
}

variable "support_emails_for_cloudwatch_alerts" {
  type        = list(string)
  description = "List of emails that will receive alerts from CloudWatch"
}

variable "aws_region" {
  type        = string
  description = "The region of the AWS Account for the rAPId service"
}

variable "log_bucket_name" {
  type        = string
  description = "A bucket to send the Load Balancer logs"
}

variable "parameter_store_variable_arns" {
  type        = list(string)
  description = "A list of parameter store variables that the ECS task needs access to"
}