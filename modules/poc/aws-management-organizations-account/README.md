# aws-management-organizations-account

This Terraform module creates an
[AWS Organizations](https://aws.amazon.com/organizations/)
member account, and optionally creates and attaches policies to the account.

The `aws` provider will be configured to use the current AWS credentials which
are expected to provide administrative access to the organization management
account.

<!-- BEGIN_TF_DOCS -->
## Resources

The following resources are used by this module:

- [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_organizations_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) (resource)
- [aws_organizations_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) (resource)
- [aws_organizations_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) (resource)
- [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_account"></a> [account](#input\_account)

Description: The name of the AWS Organizations member account to create.

Type: `string`

### <a name="input_git_repository"></a> [git\_repository](#input\_git\_repository)

Description: The value of the `GitRepository` tag for all resources created by this module.

Type: `string`

### <a name="input_layer"></a> [layer](#input\_layer)

Description: The value of the `Layer` tag for all resources created by this module.

Type: `string`

### <a name="input_organization"></a> [organization](#input\_organization)

Description: The value of the `Organization` tag for all resources created by this module.

Type: `string`

### <a name="input_parent"></a> [parent](#input\_parent)

Description: An object describing the parent of the AWS Organizations member account to create. This should be the outputs of either the [aws-management-organizations-unit](../aws-management-organizations-unit), or the [aws-management-organizations-root](../aws-management-organizations-root) module.

Type:

```hcl
object({
    management_account_email = string

    organizational_unit = object({
      id = string
    })
  })
```

### <a name="input_region"></a> [region](#input\_region)

Description: The region to configure for the default `aws` provider in this module.

Type: `string`

### <a name="input_stack"></a> [stack](#input\_stack)

Description: The value of the `Stack` tag for all resources created by this module.

Type: `string`

### <a name="input_stage"></a> [stage](#input\_stage)

Description: The value of the `Stage` tag for all resources created by this module.

Type: `string`

### <a name="input_tier"></a> [tier](#input\_tier)

Description: The value of the `Tier` tag for all resources created by this module.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_email"></a> [email](#input\_email)

Description: An explicit email address to use for the root user of the member account. If unset, this will be generated automatically based on the management account's root user email address, and the member account name.

Type: `string`

Default: `""`

### <a name="input_email_separator"></a> [email\_separator](#input\_email\_separator)

Description: The separator string to expect in the management account email address, and to use when constructing the email address of the member account's root user.

Type: `string`

Default: `"+"`

### <a name="input_organization_policies"></a> [organization\_policies](#input\_organization\_policies)

Description: A map of objects describing organization policies to create and attach to the organization member account.

The map keys should be usable as Terraform resource names and the objects must have the following attributes:

- **type** (string): The type of policy to create. For example, `SERVICE_CONTROL_POLICY`.
- **description** (string): A description of the policy.
- **content** (string): The policy document itself as an object suitable for the [jsonencode](https://www.terraform.io/docs/language/functions/jsonencode.html) function.

Type:

```hcl
map(object({
    type        = string
    description = string
    content     = any
  }))
```

Default: `{}`

### <a name="input_roles"></a> [roles](#input\_roles)

Description: A map of objects describing IAM roles to create in the member account. The  
exclusive trusted principal of each role will be the AWS Organizations  
management account.

Map keys should be CamelCase role names. The suffix `Role` will be automatically appended to each name by this module.

Map values support the following attributes:

- **description** (`string`): A description of the role.
- **path** (`string`, default: `"/"`): The IAM path under which to create the role.
- **inline\_policies** (`set(object({name = string, policy=any}))`): A set of IAM policies to define as inline policies for the role. The `policy` attribute should be an IAM policy document object suitable for [`jsonencode`](https://www.terraform.io/docs/language/functions/jsonencode.html).

Type: `map(any)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_email"></a> [email](#output\_email)

Description: The email address of the root user of the managed AWS Organizations member account.

### <a name="output_id"></a> [id](#output\_id)

Description: The ID of the managed AWS Organizations member account.

### <a name="output_name"></a> [name](#output\_name)

Description: The name of the managed AWS Organizations member account.

### <a name="output_policy_arns"></a> [policy\_arns](#output\_policy\_arns)

Description: A mapping between policy name and ARN for each IAM policy managed by this module.

### <a name="output_role_arns"></a> [role\_arns](#output\_role\_arns)

Description: A mapping between role name and ARN for each IAM role managed by this module.
<!-- END_TF_DOCS -->
