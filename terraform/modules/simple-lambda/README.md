<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.simple_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.simple_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.simple_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_s3_bucket_object.simple_lambda_artifact_upload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [archive_file.simple_lambda_artifact](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_bucket"></a> [artifact\_bucket](#input\_artifact\_bucket) | n/a | `string` | `"capsule-lambdas"` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | n/a | `string` | `null` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | n/a | `any` | `null` | no |
| <a name="input_log_retention"></a> [log\_retention](#input\_log\_retention) | n/a | `number` | `7` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | n/a | `number` | `512` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | n/a | `string` | `"nodejs12.x"` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | n/a | `number` | `15` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | n/a |
| <a name="output_lambda_role"></a> [lambda\_role](#output\_lambda\_role) | n/a |
| <a name="output_lambda_role_name"></a> [lambda\_role\_name](#output\_lambda\_role\_name) | n/a |
<!-- END_TF_DOCS -->