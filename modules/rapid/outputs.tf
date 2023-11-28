output "ecs_cluster_arn" {
  value       = module.app_cluster.ecs_cluster_arn
  description = "Cluster identifier"
}

output "ecs_task_execution_role_arn" {
  value       = module.app_cluster.ecs_task_execution_role_arn
  description = "The ECS task execution role ARN"
}

output "load_balancer_dns" {
  value       = module.app_cluster.load_balancer_dns
  description = "The DNS name of the load balancer"
}

output "load_balancer_arn" {
  value       = module.app_cluster.load_balancer_arn
  description = "The arn of the load balancer"
}

output "load_balancer_security_group_id" {
  value = module.app_cluster.load_balancer_security_group_id
  description = "The security group ID associated with the load balancer"
}

output "user_pool_endpoint" {
  value       = module.auth.user_pool_endpoint
  description = "The Cognito rapid user pool endpoint"
}

output "cognito_user_pool_id" {
  value       = module.auth.cognito_user_pool_id
  description = "The Cognito rapid user pool id"
}

output "cognito_user_pool_arn" {
  value       = module.auth.cognito_user_pool_arn
  description = "The Cognito rapid user pool arn"
}