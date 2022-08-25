# s3-website-example

This Terraform module deploys a simple, static example website hosted in an S3
bucket. The website will only have a static index, and an error page.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 3.53.0 |
| random | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.53.0 |
| random | >= 3.1.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| [aws_s3_bucket_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) |
| [random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| organization | An identifier for the organization to which the S3 example website belongs. This will be used as a component in the name of the S3 bucket created. | `string` | n/a | yes |
| stage | An identifier for the development stage to which the S3 example website belongs. This will be used as a component in the name of the S3 bucket created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| s3\_website\_url | The HTTP URL of the example S3 website created. |

<!-- END_TF_DOCS -->
