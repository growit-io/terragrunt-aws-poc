# terraform-remote-state

This module can be used to create the necessary resources to store
[Terraform state in an S3 bucket](https://www.terraform.io/docs/language/settings/backends/s3.html),
and to control locking of the state via a DynamoDB table. It can also create two
IAM policies which provide either read-only, or read-write access to these
resources.

The `backend` and `config` outputs of this module can be used to generate a
Terraform S3 backend configuration.

<!-- BEGIN_TF_DOCS -->
## Resources

The following resources are used by this module:

- [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) (data source)

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_bucket"></a> [bucket](#input\_bucket)

Description: The name of the S3 bucket that stores the Terraform state. If unset or empty, a random name will be generated automatically.

Type: `string`

Default: `""`

### <a name="input_create"></a> [create](#input\_create)

Description: Whether to actually manage the S3 bucket and DynamoDB table, or to only generate a backend configuration object based on the input variables.

Type: `bool`

Default: `true`

### <a name="input_create_access_policies"></a> [create\_access\_policies](#input\_create\_access\_policies)

Description: Whether to create customer managed IAM policies that govern access to the S3 bucket and DynamoDB table.

Type: `bool`

Default: `true`

### <a name="input_dynamodb_table"></a> [dynamodb\_table](#input\_dynamodb\_table)

Description: The name of the DynamoDB table that will be used to lock objects in the S3 bucket. Defaults to the name of the bucket.

Type: `string`

Default: `""`

### <a name="input_encrypt"></a> [encrypt](#input\_encrypt)

Description: Whether to enable server-side encryption on the S3 bucket (or to assume that it is enabled when `create` is `false`).

Type: `bool`

Default: `true`

### <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy)

Description: A boolean that indicates all objects (including any locked objects) should be deleted from the bucket before destroying the bucket, so that the bucket can be destroyed without error. These objects are not recoverable.

Type: `bool`

Default: `false`

### <a name="input_policy_name_prefix"></a> [policy\_name\_prefix](#input\_policy\_name\_prefix)

Description: A prefix to prepend to the names of all managed IAM policies.

Type: `string`

Default: `""`

### <a name="input_policy_name_suffix"></a> [policy\_name\_suffix](#input\_policy\_name\_suffix)

Description: A suffix to append to the names of all managed IAM policies.

Type: `string`

Default: `""`

### <a name="input_policy_path"></a> [policy\_path](#input\_policy\_path)

Description: The IAM path under which to create the IAM policies.

Type: `string`

Default: `"/"`

### <a name="input_read_only_policy_name"></a> [read\_only\_policy\_name](#input\_read\_only\_policy\_name)

Description: The middle part of the name of the IAM policy which grants read-only access to the S3 bucket.

Type: `string`

Default: `"TerraformStateReadOnlyAccess"`

### <a name="input_read_write_policy_name"></a> [read\_write\_policy\_name](#input\_read\_write\_policy\_name)

Description: The middle part of the name of the IAM policy which grants read-write access to the S3 bucket, and DynamoDB table.

Type: `string`

Default: `"TerraformStateReadWriteAccess"`

## Outputs

The following outputs are exported:

### <a name="output_access_policy_arns"></a> [access\_policy\_arns](#output\_access\_policy\_arns)

Description: A mapping between the names of all IAM policies managed by this module and their corresponding ARNs.

### <a name="output_backend"></a> [backend](#output\_backend)

Description: The name of the [Terraform remote state backend](https://www.terraform.io/docs/language/settings/backends/index.html) that this module created the required resources for. This will always be the value `"s3"`.

### <a name="output_config"></a> [config](#output\_config)

Description: An object describing the [S3 backend](https://www.terraform.io/docs/language/settings/backends/s3.html) configuration.

### <a name="output_read_only_access_policy_name"></a> [read\_only\_access\_policy\_name](#output\_read\_only\_access\_policy\_name)

Description: The name of the managed IAM policy which grants read-only access to the S3 bucket. If the `create_access_policies` variable is `false`, then this value will be an empty string.

### <a name="output_read_write_access_policy_name"></a> [read\_write\_access\_policy\_name](#output\_read\_write\_access\_policy\_name)

Description: The name of the managed IAM policy which grants read-write access to the S3 bucket and DynamoDB table. If the `create_access_policies` variable is `false`, then this value will be an empty string.
<!-- END_TF_DOCS -->
