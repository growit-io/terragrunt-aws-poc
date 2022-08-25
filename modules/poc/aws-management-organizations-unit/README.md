# aws-management-organizations-unit

This Terraform module creates an
[AWS Organizations](https://aws.amazon.com/organizations/)
organizational unit (OU), and optionally creates and attaches policies to the
OU.

The `aws` provider will be configured to use the current AWS credentials which
are expected to provide administrative access to the organization management
account.

<!-- BEGIN_TF_DOCS -->
## Resources

The following resources are used by this module:

- [aws_organizations_organizational_unit.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) (resource)
- [aws_organizations_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) (resource)
- [aws_organizations_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_git_repository"></a> [git\_repository](#input\_git\_repository)

Description: The value of the `GitRepository` tag for all resources created by this module.

Type: `string`

### <a name="input_layer"></a> [layer](#input\_layer)

Description: The value of the `Layer` tag for all resources created by this module.

Type: `string`

### <a name="input_organization"></a> [organization](#input\_organization)

Description: The value of the `Organization` tag for all resources created by this module.

Type: `string`

### <a name="input_organizational_unit"></a> [organizational\_unit](#input\_organizational\_unit)

Description: Used to construct the name of the organizational unit if the `name` variable is not given explicitly. This value should normally be provided automatically via the parent terragrunt.hcl file in this repository.

Type: `string`

### <a name="input_parent"></a> [parent](#input\_parent)

Description: An object describing the parent of the organizational unit to create. This should be the outputs of either this module, or the [aws-management-organizations-root](../aws-management-organizations-root) module.

Type:

```hcl
object({
    management_account_id    = string
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

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the organizational unit to create. If empty, the name will be automatically generated based on the value of the `organization_unit` variable.

Type: `string`

Default: `""`

### <a name="input_organization_policies"></a> [organization\_policies](#input\_organization\_policies)

Description: A map of objects describing organization policies to create and attach to the organizational unit.

The map keys should be usable as Terraform resource names and the objects must have the following attributes:

- **type** (string): The type of policy to create. For example, `SERVICE_CONTROL_POLICY`.
- **description** (string): A description of the policy.
- **content** (string): The policy document itself as an object suitable for [`jsonencode`](https://www.terraform.io/docs/language/functions/jsonencode.html).

Type:

```hcl
map(object({
    type        = string
    description = string
    content     = any
  }))
```

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_management_account_email"></a> [management\_account\_email](#output\_management\_account\_email)

Description: The email address of the organization's management account root user.

### <a name="output_management_account_id"></a> [management\_account\_id](#output\_management\_account\_id)

Description: The AWS account ID of the organization's management account.

### <a name="output_organizational_unit"></a> [organizational\_unit](#output\_organizational\_unit)

Description: An object describing the organizational unit created by this module.
<!-- END_TF_DOCS -->
