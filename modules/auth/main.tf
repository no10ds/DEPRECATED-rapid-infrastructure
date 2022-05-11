resource "aws_cognito_user_pool" "rapid_user_pool" {
  name = "${var.resource-name-prefix}_user_pool"
  tags = var.tags

  alias_attributes  = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  mfa_configuration = "OPTIONAL"

  software_token_mfa_configuration {
    enabled = true
  }
}

resource "aws_cognito_resource_server" "rapid_resource_server" {
  identifier = "https://${var.domain_name}"
  name       = "${var.resource-name-prefix}_service_api"

  user_pool_id = aws_cognito_user_pool.rapid_user_pool.id

  dynamic "scope" {
      for_each = [for key, value in var.scopes: {
        scope_name     = value.scope_name
        scope_description     = value.scope_description
      }]

      content {
        scope_name     = scope.value.scope_name
        scope_description = scope.value.scope_description
      }
  }
}

resource "aws_cognito_user_pool_client" "test_client" {
  name = "${var.resource-name-prefix}_test_client"

  user_pool_id = aws_cognito_user_pool.rapid_user_pool.id
  generate_secret = true
  explicit_auth_flows = var.rapid_client_explicit_auth_flows
  allowed_oauth_scopes = [
    aws_cognito_resource_server.rapid_resource_server.scope_identifiers[10], # WRITE_ALL
    aws_cognito_resource_server.rapid_resource_server.scope_identifiers[11], # READ_ALL
    aws_cognito_resource_server.rapid_resource_server.scope_identifiers[2], # DELETE_ALL
    aws_cognito_resource_server.rapid_resource_server.scope_identifiers[8], # ADD_CLIENT
    aws_cognito_resource_server.rapid_resource_server.scope_identifiers[9], # ADD_SCHEMA
  ]
  allowed_oauth_flows = ["client_credentials"]
  allowed_oauth_flows_user_pool_client = true
}

resource "aws_cognito_user_pool_client" "user_login" {
  name = "${var.resource-name-prefix}_user_login"

  user_pool_id = aws_cognito_user_pool.rapid_user_pool.id
  supported_identity_providers = ["COGNITO"]
  generate_secret = true
  explicit_auth_flows = var.rapid_user_login_client_explicit_auth_flows
  allowed_oauth_scopes = [
    "phone", "email", "openid"
  ]
  allowed_oauth_flows = ["code"]
  allowed_oauth_flows_user_pool_client = true
  callback_urls = ["https://${var.domain_name}/oauth2/success"]
  default_redirect_uri = "https://${var.domain_name}/oauth2/success"
}

resource "aws_cognito_user_pool_domain" "rapid_cognito_domain" {
  domain       = "${var.resource-name-prefix}-auth"
  user_pool_id = aws_cognito_user_pool.rapid_user_pool.id
}

resource "aws_secretsmanager_secret" "cognito_client_secrets" {
  # checkov:skip=CKV_AWS_149:AWS Managed Key is sufficient
  name = "${var.resource-name-prefix}_cognito_client_secrets"
}

resource "aws_secretsmanager_secret" "cognito_user_secrets" {
  # checkov:skip=CKV_AWS_149:AWS Managed Key is sufficient
  name = "${var.resource-name-prefix}_cognito_user_secrets"
}

resource "aws_secretsmanager_secret_version" "client_secrets_version" {
  secret_id     = aws_secretsmanager_secret.cognito_client_secrets.id
  secret_string = jsonencode({
    client_name = aws_cognito_user_pool_client.test_client.name
    client_id = aws_cognito_user_pool_client.test_client.id
    client_secret = aws_cognito_user_pool_client.test_client.client_secret
  })
}

resource "aws_secretsmanager_secret_version" "user_login_client_secrets_version" {
  secret_id     = aws_secretsmanager_secret.cognito_user_secrets.id
  secret_string = jsonencode({
    client_id = aws_cognito_user_pool_client.user_login.id
    client_secret = aws_cognito_user_pool_client.user_login.client_secret
  })
}