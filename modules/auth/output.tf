output "user_pool_endpoint" {
  value       = aws_cognito_user_pool.rapid_user_pool.endpoint
  description = "The Cognito rapid user pool endpoint"
}

output "resource_server_scopes" {
  value = aws_cognito_resource_server.rapid_resource_server.scope_identifiers
  description = "The scopes defined in the resource server"
}

output "rapid_test_client_id" {
  value = aws_cognito_user_pool_client.test_client.id
  description = "The rapid test client id registered in the user pool"
}

output "cognito_user_pool_id" {
  value       = aws_cognito_user_pool.rapid_user_pool.id
  description = "The Cognito rapid user pool id"
}

output "cognito_client_app_secret_manager_name" {
  value       = aws_secretsmanager_secret.cognito_client_secrets.name
  description = "Secret manager name where client app info is stored"
}

output "cognito_user_app_secret_manager_name" {
  value       = aws_secretsmanager_secret.cognito_user_secrets.name
  description = "Secret manager name where user login app info is stored"
}