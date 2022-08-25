# aws-workloads-website

This Terraform module creates a static example website hosted in an S3 bucket.

The `aws` provider will be configured to use the current AWS credentials to
assume the `WebsiteAdministrator` role in the specified target account.

<!-- BEGIN_TF_DOCS -->


## Required Inputs

The following input variables are required:

### <a name="input_account"></a> [account](#input\_account)

Description:     An object describing the AWS account in which the S3 website should be deployed. This should normally be the outputs of the [aws-management-organizations-account](../aws-management-organizations-account/README.md) module.

    Specifically, this module expects an output named `role_arns.${role}`, whose value will be passed to the `role_arn` attribute of the default `aws` provider.

    The `name` attribute of this object is used as the value of the `Acount` tag for all resources created by this module.

Type:

```hcl
object({
    name      = string
    role_arns = map(string)
  })
```

### <a name="input_git_repository"></a> [git\_repository](#input\_git\_repository)

Description: The value of the `GitRepository` tag for all resources created by this module.

Type: `string`

### <a name="input_layer"></a> [layer](#input\_layer)

Description: The value of the `Layer` tag for all resources created by this module.

Type: `string`

### <a name="input_organization"></a> [organization](#input\_organization)

Description: The value of the `Organization` tag for all resources created by this module.

Type: `string`

### <a name="input_region"></a> [region](#input\_region)

Description: The region in which to deploy the website.

Type: `string`

### <a name="input_stage"></a> [stage](#input\_stage)

Description: The value of the `Stage` tag for all resources created by this module.

Type: `string`

### <a name="input_tier"></a> [tier](#input\_tier)

Description: The value of the `Tier` tag for all resources created by this module.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_role"></a> [role](#input\_role)

Description: The role to assume in the target account.

Type: `string`

Default: `"WebsiteAdministrator"`

## Outputs

The following outputs are exported:

### <a name="output_url"></a> [url](#output\_url)

Description: The HTTP URL of the S3 website.
<!-- END_TF_DOCS -->
