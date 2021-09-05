# Management Tier

This directory contains Terragrunt configurations for resources belonging
to the [AWS Organizations](https://aws.amazon.com/organizations/) management
account. Each subdirectory represents a distinct "stage" in the development
of the infrastructure configuration.

## Access control requirements

A restricted subset of special resources in the management account, such as
the resources created in the [**boot**](boot) and [**dev**](dev) stages, must
be readable by unprivileged IAM users, but normally privileged access to the
management is required in order to plan or apply any configuration changes.

## Terragrunt configuration conventions

The [`terragrunt.yml`](terragrunt.yml) file in this directory modifies the
conventions for all Terragrunt configurations below this hierarchy level.

### Terraform root module inputs

The following additional inputs are provided to all Terraform root modules via
`TF_VAR_` environment variables:

- **stage** (`string`): The name of the subdirectory which defines the
  respective configuration stage.
