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
| [aws_cognito_resource_server.rapid_resource_server](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/cognito_resource_server) | resource |
| [aws_cognito_user_pool.rapid_user_pool](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.test_client](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_client.user_login](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.rapid_cognito_domain](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/cognito_user_pool_domain) | resource |
| [aws_secretsmanager_secret.cognito_client_secrets](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.cognito_user_secrets](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.client_secrets_version](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.user_login_client_secrets_version](https://registry.terraform.io/providers/hashicorp/aws/4.12.1/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for the rAPId instance | `string` | n/a | yes |
| <a name="input_rapid_client_explicit_auth_flows"></a> [rapid\_client\_explicit\_auth\_flows](#input\_rapid\_client\_explicit\_auth\_flows) | The list of auth flows supported by the client app | `list(string)` | <pre>[<br>  "ALLOW_REFRESH_TOKEN_AUTH",<br>  "ALLOW_CUSTOM_AUTH",<br>  "ALLOW_USER_SRP_AUTH"<br>]</pre> | no |
| <a name="input_rapid_user_login_client_explicit_auth_flows"></a> [rapid\_user\_login\_client\_explicit\_auth\_flows](#input\_rapid\_user\_login\_client\_explicit\_auth\_flows) | The list of auth flows supported by the user login app | `list(string)` | <pre>[<br>  "ALLOW_REFRESH_TOKEN_AUTH",<br>  "ALLOW_USER_SRP_AUTH"<br>]</pre> | no |
| <a name="input_resource-name-prefix"></a> [resource-name-prefix](#input\_resource-name-prefix) | The prefix to add to resources for easier identification | `string` | n/a | yes |
| <a name="input_scopes"></a> [scopes](#input\_scopes) | n/a | `map(any)` | <pre>{<br>  "scope1": {<br>    "scope_description": "Read all data in the rapid service at all sensitivity levels",<br>    "scope_name": "READ_ALL"<br>  },<br>  "scope10": {<br>    "scope_description": "Read all data in the rapid service at all sensitivity levels",<br>    "scope_name": "READ_SENSITIVE"<br>  },<br>  "scope11": {<br>    "scope_description": "Write to rapid service at all sensitivity levels",<br>    "scope_name": "WRITE_SENSITIVE"<br>  },<br>  "scope12": {<br>    "scope_description": "Delete files from the rapid service at all sensitivity levels",<br>    "scope_name": "DELETE_SENSITIVE"<br>  },<br>  "scope13": {<br>    "scope_description": "Create a new client",<br>    "scope_name": "ADD_CLIENT"<br>  },<br>  "scope14": {<br>    "scope_description": "Generate or upload a new schema",<br>    "scope_name": "ADD_SCHEMA"<br>  },<br>  "scope2": {<br>    "scope_description": "Write to rapid service at all sensitivity levels",<br>    "scope_name": "WRITE_ALL"<br>  },<br>  "scope3": {<br>    "scope_description": "Delete files from the rapid service at all sensitivity levels",<br>    "scope_name": "DELETE_ALL"<br>  },<br>  "scope4": {<br>    "scope_description": "Read all data in the rapid service at the public sensitivity level",<br>    "scope_name": "READ_PUBLIC"<br>  },<br>  "scope5": {<br>    "scope_description": "Write to rapid service at the public sensitivity level",<br>    "scope_name": "WRITE_PUBLIC"<br>  },<br>  "scope6": {<br>    "scope_description": "Delete files from the rapid service at the public sensitivity level",<br>    "scope_name": "DELETE_PUBLIC"<br>  },<br>  "scope7": {<br>    "scope_description": "Read all data in the rapid service at the public and private sensitivity level",<br>    "scope_name": "READ_PRIVATE"<br>  },<br>  "scope8": {<br>    "scope_description": "Write to rapid service at the public and private sensitivity level",<br>    "scope_name": "WRITE_PRIVATE"<br>  },<br>  "scope9": {<br>    "scope_description": "Delete files from the rapid service at the public and private sensitivity level",<br>    "scope_name": "DELETE_PRIVATE"<br>  }<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A common map of tags for all VPC resources that are created (for e.g. billing purposes) | `map(string)` | <pre>{<br>  "Resource": "data-f1-rapid"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cognito_client_app_secret_manager_name"></a> [cognito\_client\_app\_secret\_manager\_name](#output\_cognito\_client\_app\_secret\_manager\_name) | Secret manager name where client app info is stored |
| <a name="output_cognito_user_app_secret_manager_name"></a> [cognito\_user\_app\_secret\_manager\_name](#output\_cognito\_user\_app\_secret\_manager\_name) | Secret manager name where user login app info is stored |
| <a name="output_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#output\_cognito\_user\_pool\_id) | The Cognito rapid user pool id |
| <a name="output_rapid_test_client_id"></a> [rapid\_test\_client\_id](#output\_rapid\_test\_client\_id) | The rapid test client id registered in the user pool |
| <a name="output_resource_server_scopes"></a> [resource\_server\_scopes](#output\_resource\_server\_scopes) | The scopes defined in the resource server |
| <a name="output_user_pool_endpoint"></a> [user\_pool\_endpoint](#output\_user\_pool\_endpoint) | The Cognito rapid user pool endpoint |
<!-- END_TF_DOCS -->