# Production Stage

This directory contains Terragrunt configurations for resources belonging to
to member accounts designated as workload accounts for testing. Each
subdirectory represents a distinct account.

## Terragrunt configuration conventions

The [`terragrunt.yml`](terragrunt.yml) file in this directory modifies the
conventions for all Terragrunt configurations below this hierarchy level.

### Terraform remote state backend

All configurations below this directory will use the backend configuration
named `workloads_test` as defined by the
[../../management/boot/terraform-state](../../management/boot/terraform-state)
configuration.

### Terraform root module inputs

The following additional inputs are provided to all Terraform root modules via
`TF_VAR_` environment variables:

- **account** (`string`): The name of the subdirectory which defines the
  configuration of a particular account.
