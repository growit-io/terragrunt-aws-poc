# Workloads Tier

This directory contains Terragrunt configurations for resources belonging to
to member accounts designated as workload accounts. Each subdirectory represents
a distinct "stage" in the development of the infrastructure configuration.

## Terragrunt configuration conventions

The [`terragrunt.yml`](terragrunt.yml) file in this directory modifies the
conventions for all Terragrunt configurations below this hierarchy level.

### Terraform root module inputs

The following additional inputs are provided to all Terraform root modules via
`TF_VAR_` environment variables:

- **stage** (`string`): The name of the subdirectory which defines the
  respective configuration stage.
