# states

## Dependencies

![Dependency graph](graph.svg)

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |

## Providers

No provider.

## Modules

No Modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| terraform\_remote\_states | A map of objects describing the Terraform states (regardless of whether<br>they are actually remote or local) to create and include in the module's<br>outputs. | <pre>map(object({<br>    path = string<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| terraform\_remote\_states | A map of objects describing the Terraform states created by this module. The<br>parent terragrunt.hcl expects an output with this name in any configuration<br>pointed to by the `path` config option of the virtual "terragrunt" backend. |

<!--- END_TF_DOCS --->
