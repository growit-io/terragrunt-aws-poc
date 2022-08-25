# s3-website-example

This Terraform module deploys a simple, static example website hosted in an S3
bucket. The website will only have a static index, and an error page.

<!-- BEGIN_TF_DOCS -->
## Resources

The following resources are used by this module:

- [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) (resource)
- [aws_s3_bucket_object.error_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) (resource)
- [aws_s3_bucket_object.index_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) (resource)
- [random_id.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_organization"></a> [organization](#input\_organization)

Description: An identifier for the organization to which the S3 example website belongs. This will be used as a component in the name of the S3 bucket created.

Type: `string`

### <a name="input_stage"></a> [stage](#input\_stage)

Description: An identifier for the development stage to which the S3 example website belongs. This will be used as a component in the name of the S3 bucket created.

Type: `string`

## Outputs

The following outputs are exported:

### <a name="output_s3_website_url"></a> [s3\_website\_url](#output\_s3\_website\_url)

Description: The HTTP URL of the example S3 website created.
<!-- END_TF_DOCS -->
