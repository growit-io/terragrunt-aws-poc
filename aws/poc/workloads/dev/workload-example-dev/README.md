# Workload-Example-Dev Account

This directory defines the configuration of the AWS Organizations member account
that contains development versions of an S3 website. Each subdirectory
represents a distinct "layer" of the account configuration.

## Terragrunt configuration conventions

The [`terragrunt.yml`](terragrunt.yml) file in this directory modifies the
conventions for all Terragrunt configurations below this hierarchy level.

### Terraform root module source

This directory extends the Terraform module source convention. The source of all
Terraform root modules used in configurations below this directory must include
the `${layer}` suffix.

### Terraform root module inputs

The following additional inputs are provided to all Terraform root modules via
`TF_VAR_` environment variables:

- **layer** (`string`): The name of the subdirectory which defines a particular
  configuration layer.
