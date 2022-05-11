output "load_balancer_dns" {
  value       = aws_alb.application_load_balancer.dns_name
  description = "The DNS name of the load balancer"
}

output "load_balancer_arn" {
  value       = aws_alb.application_load_balancer.arn
  description = "The arn of the load balancer"
}

output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.aws-ecs-cluster.arn
  description = "Cluster identifier"
}

output "hosted_zone_name_servers" {
  value       = var.hosted_zone_id == "" ? aws_route53_zone.primary-hosted-zone[0].name_servers : []
  description = "Name servers of the primary hosted zone linked to the domain"
}

output "ecs_task_execution_role_arn" {
  value       = aws_iam_role.ecsTaskExecutionRole.arn
  description = "The ECS task execution role ARN"
}

output "log_error_alarm_notification_arn" {
  value = aws_sns_topic.log-error-alarm-notification.arn
  description = "The arn of the sns topic that receives notifications on log error alerts"
}

output "rapid_metric_log_error_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.log-error-alarm.arn
  description = "The arn of the log error alarm metric"
}