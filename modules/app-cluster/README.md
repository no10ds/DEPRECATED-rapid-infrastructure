<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.12.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.12.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.rapid-certificate](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.rapid-certificate-validation](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/acm_certificate_validation) | resource |
| [aws_alb.application_load_balancer](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/alb) | resource |
| [aws_appautoscaling_policy.ecs_policy_cpu](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.ecs_policy_memory](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs_target](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.log-group](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_metric_filter.rapid-service-log-error-count](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_metric_alarm.log-error-alarm](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_ecs_cluster.aws-ecs-cluster](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.aws-ecs-service](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.aws-ecs-task](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.app_athena_query_access](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/iam_policy) | resource |
| [aws_iam_policy.app_cognito_access](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/iam_policy) | resource |
| [aws_iam_policy.app_s3_access](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/iam_policy) | resource |
| [aws_iam_policy.app_secrets_manager_access](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/iam_policy) | resource |
| [aws_iam_policy.app_tags_access](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecsTaskExecutionRole](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecsTaskExecutionRole_policy](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.role_athena_access_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.role_cognito_access_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.role_s3_access_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.role_secrets_manager_access_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.role_tags_access_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb_listener.http-listener](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/lb_listener) | resource |
| [aws_lb_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/lb_target_group) | resource |
| [aws_route53_record.rapid_validation_record](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/route53_record) | resource |
| [aws_route53_record.route-to-lb](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/route53_record) | resource |
| [aws_route53_zone.primary-hosted-zone](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/route53_zone) | resource |
| [aws_s3_bucket_policy.allow_alb_logging](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/s3_bucket_policy) | resource |
| [aws_security_group.load_balancer_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/security_group) | resource |
| [aws_security_group.service_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/security_group) | resource |
| [aws_sns_topic.log-error-alarm-notification](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.log-error-alarm-subscription](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/sns_topic_subscription) | resource |
| [aws_wafv2_web_acl.rapid_acl](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.alb-acl-association](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/wafv2_web_acl_association) | resource |
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/data-sources/ecs_task_definition) | data source |
| [aws_elb_service_account.main](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app-replica-count-desired"></a> [app-replica-count-desired](#input\_app-replica-count-desired) | The desired number of replicas of the app | `number` | `1` | no |
| <a name="input_app-replica-count-max"></a> [app-replica-count-max](#input\_app-replica-count-max) | The maximum desired number of replicas of the app | `number` | `2` | no |
| <a name="input_application_version"></a> [application\_version](#input\_application\_version) | The version number for the application image (e.g.: v1.0.4, v1.0.x-latest, etc.) | `string` | n/a | yes |
| <a name="input_athena_query_output_bucket_arn"></a> [athena\_query\_output\_bucket\_arn](#input\_athena\_query\_output\_bucket\_arn) | The S3 bucket ARN where Athena stores its query results. This bucket is created dynamically with a unique name in the data-workflow module. Reference it by remote state, module output or ARN string directly | `string` | n/a | yes |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | AWS Account number to host the rAPId service | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The region of the AWS Account for the rAPId service | `string` | n/a | yes |
| <a name="input_certificate_validation_arn"></a> [certificate\_validation\_arn](#input\_certificate\_validation\_arn) | Arn of the certificate used by the domain | `string` | n/a | yes |
| <a name="input_cognito_user_login_app_credentials_secrets_name"></a> [cognito\_user\_login\_app\_credentials\_secrets\_name](#input\_cognito\_user\_login\_app\_credentials\_secrets\_name) | Secret name for Cognito user login app credentials | `string` | n/a | yes |
| <a name="input_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#input\_cognito\_user\_pool\_id) | User pool id for cognito | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | The port for the running ECS containers | `number` | `8000` | no |
| <a name="input_data_s3_bucket_arn"></a> [data\_s3\_bucket\_arn](#input\_data\_s3\_bucket\_arn) | S3 Bucket arn to store application data | `string` | n/a | yes |
| <a name="input_data_s3_bucket_name"></a> [data\_s3\_bucket\_name](#input\_data\_s3\_bucket\_name) | S3 Bucket name to store application data | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for the rAPId instance | `string` | n/a | yes |
| <a name="input_host_port"></a> [host\_port](#input\_host\_port) | The host port for the running ECS containers | `number` | `8000` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | Hosted Zone ID with the domain Name Servers, pass quotes to create a new one from scratch | `string` | n/a | yes |
| <a name="input_ip_whitelist"></a> [ip\_whitelist](#input\_ip\_whitelist) | A list of IPs to whitelist for access to the service | `list(string)` | n/a | yes |
| <a name="input_log_bucket_name"></a> [log\_bucket\_name](#input\_log\_bucket\_name) | A bucket to send the Load Balancer logs | `string` | n/a | yes |
| <a name="input_private_subnet_ids_list"></a> [private\_subnet\_ids\_list](#input\_private\_subnet\_ids\_list) | Application Private subnet list | `list(string)` | n/a | yes |
| <a name="input_public_subnet_ids_list"></a> [public\_subnet\_ids\_list](#input\_public\_subnet\_ids\_list) | Application Public subnet list | `list(string)` | n/a | yes |
| <a name="input_rapid_ecr_url"></a> [rapid\_ecr\_url](#input\_rapid\_ecr\_url) | ECR Url for task definition | `string` | n/a | yes |
| <a name="input_resource-name-prefix"></a> [resource-name-prefix](#input\_resource-name-prefix) | The prefix to add to resources for easier identification | `string` | n/a | yes |
| <a name="input_support_emails_for_cloudwatch_alerts"></a> [support\_emails\_for\_cloudwatch\_alerts](#input\_support\_emails\_for\_cloudwatch\_alerts) | List of emails that will receive alerts from CloudWatch | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A common map of tags for all VPC resources that are created (for e.g. billing purposes) | `map(string)` | <pre>{<br>  "Resource": "data-f1-rapid"<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Application VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#output\_ecs\_cluster\_arn) | Cluster identifier |
| <a name="output_ecs_task_execution_role_arn"></a> [ecs\_task\_execution\_role\_arn](#output\_ecs\_task\_execution\_role\_arn) | The ECS task execution role ARN |
| <a name="output_hosted_zone_name_servers"></a> [hosted\_zone\_name\_servers](#output\_hosted\_zone\_name\_servers) | Name servers of the primary hosted zone linked to the domain |
| <a name="output_load_balancer_arn"></a> [load\_balancer\_arn](#output\_load\_balancer\_arn) | The arn of the load balancer |
| <a name="output_load_balancer_dns"></a> [load\_balancer\_dns](#output\_load\_balancer\_dns) | The DNS name of the load balancer |
| <a name="output_log_error_alarm_notification_arn"></a> [log\_error\_alarm\_notification\_arn](#output\_log\_error\_alarm\_notification\_arn) | The arn of the sns topic that receives notifications on log error alerts |
| <a name="output_rapid_metric_log_error_alarm_arn"></a> [rapid\_metric\_log\_error\_alarm\_arn](#output\_rapid\_metric\_log\_error\_alarm\_arn) | The arn of the log error alarm metric |
<!-- END_TF_DOCS -->