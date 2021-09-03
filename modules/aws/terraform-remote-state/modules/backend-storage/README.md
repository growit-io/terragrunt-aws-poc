# backend-storage

This Terraform module creates the required resources for a given
[Terraform S3 backend](https://www.terraform.io/docs/language/settings/backends/s3.html)
configuration.

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| aws | >= 3.53.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.53.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_dynamodb_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| [aws_s3_bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket | The name of the S3 bucket to create. | `string` | n/a | yes |
| dynamodb\_table | The DynamoDB table to create for storing locks of objects in the S3 bucket. | `string` | n/a | yes |
| encrypt | Whether to enable encryption on the created S3 bucket. | `bool` | `true` | no |
| force\_destroy | A boolean that indicates all objects (including any locked objects) should be deleted from the bucket before destroying the bucket, so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->
