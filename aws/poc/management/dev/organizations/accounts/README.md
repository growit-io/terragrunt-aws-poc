# Accounts Stack

This directory contains the configuration of all AWS Organizations member
accounts that will contain development resources. Each subdirectory represents a
distinct account.

## Terragrunt configuration conventions

The [`terragrunt.yml`](terragrunt.yml) file in this directory modifies the
conventions for all Terragrunt configurations below this hierarchy level.

### Terraform root module source

All configurations below this directory level will use the
[aws-management-organizations-account](../../../../../../modules/poc/aws-management-organizations-account)
root module.

### Terraform root module inputs

The following additional inputs are provided to all Terraform root modules via
`TF_VAR_` environment variables:

- **account** (`string`): The name of the subdirectory which defines the
  respective account configuration.
