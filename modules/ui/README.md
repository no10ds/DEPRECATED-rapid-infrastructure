<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_aws.us_east"></a> [aws.us\_east](#provider\_aws.us\_east) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.rapid-certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_cloudfront_distribution.rapid_ui](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.rapid_ui](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_cloudfront_origin_request_policy.rapid_ui_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_request_policy) | resource |
| [aws_route53_record.rapid-validation_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.route-to-cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.rapid_ui](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.rapid_ui_storage_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_website_configuration.rapid_ui_website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_wafv2_ip_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.rapid_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [random_string.random_cloudfront_header](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_uuid.bucket_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [aws_cloudfront_cache_policy.optimised](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | AWS Account number to host the rAPId service | `string` | n/a | yes |
| <a name="input_certificate_validation_arn"></a> [certificate\_validation\_arn](#input\_certificate\_validation\_arn) | Arn of the certificate used by the domain | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for the rAPId instance | `string` | n/a | yes |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | Hosted Zone ID with the domain Name Servers, pass quotes to create a new one from scratch | `string` | n/a | yes |
| <a name="input_ip_whitelist"></a> [ip\_whitelist](#input\_ip\_whitelist) | A list of IPs to whitelist for access to the service | `list(string)` | n/a | yes |
| <a name="input_load_balancer_dns"></a> [load\_balancer\_dns](#input\_load\_balancer\_dns) | The DNS name of the load balancer | `string` | n/a | yes |
| <a name="input_log_bucket_name"></a> [log\_bucket\_name](#input\_log\_bucket\_name) | A bucket to send the Cloudfront logs | `string` | n/a | yes |
| <a name="input_resource-name-prefix"></a> [resource-name-prefix](#input\_resource-name-prefix) | The prefix to add to resources for easier identification | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A common map of tags for all VPC resources that are created (for e.g. billing purposes) | `map(string)` | n/a | yes |
| <a name="input_ui_version"></a> [ui\_version](#input\_ui\_version) | Version number for the built ui static files (e.g. v5.0) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_public_arn"></a> [bucket\_public\_arn](#output\_bucket\_public\_arn) | The arn of the public S3 bucket |
| <a name="output_bucket_website_domain"></a> [bucket\_website\_domain](#output\_bucket\_website\_domain) | The domain of the website endpoint |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags used in the project |
<!-- END_TF_DOCS -->
