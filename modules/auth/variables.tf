variable "tags" {
  type        = map(string)
  description = "A common map of tags for all VPC resources that are created (for e.g. billing purposes)"
  default = {
    Resource = "data-f1-rapid"
  }
}

variable "domain_name" {
  type        = string
  description = "Domain name for the rAPId instance"
}

variable "rapid_client_explicit_auth_flows" {
  type        = list(string)
  description = "The list of auth flows supported by the client app"
  default     = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH"]
}

variable "rapid_user_login_client_explicit_auth_flows" {
  type        = list(string)
  description = "The list of auth flows supported by the user login app"
  default     = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
}

variable "resource-name-prefix" {
  type        = string
  description = "The prefix to add to resources for easier identification"
}

variable "scopes" {
  type = list(map(any))
  default = [
    {
      scope_name        = "READ_ALL"
      scope_description = "Read all data in the rapid service at all sensitivity levels"
    },
    {
      scope_name        = "WRITE_ALL"
      scope_description = "Write to rapid service at all sensitivity levels"
    },
    {
      scope_name        = "READ_PUBLIC"
      scope_description = "Read all data in the rapid service at the public sensitivity level"
    },
    {
      scope_name        = "WRITE_PUBLIC"
      scope_description = "Write to rapid service at the public sensitivity level"
    },
    {
      scope_name        = "READ_PRIVATE"
      scope_description = "Read all data in the rapid service at the public and private sensitivity level"
    },
    {
      scope_name        = "WRITE_PRIVATE"
      scope_description = "Write to rapid service at the public and private sensitivity level"
    },
    {
      scope_name        = "READ_SENSITIVE"
      scope_description = "Read all data in the rapid service at all sensitivity levels"
    },
    {
      scope_name        = "WRITE_SENSITIVE"
      scope_description = "Write to rapid service at all sensitivity levels"
    },
    {
      scope_name        = "USER_ADMIN"
      scope_description = "Carry out admin actions with regards to users/clients"
    },
    {
      scope_name        = "DATA_ADMIN"
      scope_description = "Carry out admin actions with regards to the data products"
    },
  ]
}