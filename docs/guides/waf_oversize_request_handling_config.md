# WAF Oversize Request Handling Config

## Context

From 1 October 2022 our AWS WAF will need to be configured for how to handle over-sized requests (requests with a body
of >8kb (not file uploads)).

Since this is a new feature (available since 29 April 2022), Terraform has not yet provided support for this
configuration. See more about the Terraform fix [here](https://github.com/hashicorp/terraform-provider-aws/issues/25832)
.

In the meantime (between 1 October 22 and when support is implemented in TF) we need a manual workaround to add the
configuration.

## How to manually configure the WAF

1. Go to the AWS console -> AWS WAF -> Web ACLs
2. Select the relevant ACL e.g.: `rapid-acl`
3. Click on the `Rules` tab in the secondary navigation row
4. Choose the `validate-request` rule
5. Edit the rule
6. Scroll to the statement that checks for SQL Injection in the request body
7. Under `Oversize handling`, choose `Match` from the dropdown
    1. This will make the WAF assume that any request bigger than 8kb contains SQL Injection and reject the request.

## Future fix
Once Terraform provide support for this flag:

1. The flag should be added to the `aws_wafv2_web_acl` resource in the load
balancer.

2. The warning prompt to manually change the configuration that comes up as an output of applying
the `app-cluster` module and block should also be removed
