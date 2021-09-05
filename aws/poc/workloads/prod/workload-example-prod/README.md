# Workload-Example-Prod Account

This directory defines the configuration of the AWS Organizations member account
that contains production versions of an S3 website. Each subdirectory
represents a distinct AWS region.

## Terragrunt configuration conventions

The [`terragrunt.yml`](terragrunt.yml) file in this directory modifies the
conventions for all Terragrunt configurations below this hierarchy level.

### Terraform root module inputs

The following additional inputs are provided to all Terraform root modules via
`TF_VAR_` environment variables:

- **region** (`string`): The name of the subdirectory which defines the
  configuration within a particular AWS region of this account.
