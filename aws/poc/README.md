# Proof-of-Concept Organization

This directory contains Terragrunt configurations for a hypothetical
[AWS Organizations](https://aws.amazon.com/organizations/)
organization named "poc." Each subdirectory represents a distinct "tier" of the
configuration.

## Tiers

- [**management**](management): Defines the configuration of the AWS
  Organizations management account. A restricted subset of special resources in
  the management account is accessible to unprivileged IAM users, but normally
  privileged access to the management is required in order to plan or apply any
  configuration changes.
- [**workloads**](workloads): Defines all workloads that the organization is
  deploying on AWS. The level of access required in order to plan or apply
  changes depends on the member account and [IAM Access](management/prod/iam/access)
  configuration defined in the **management** tier.

## Terraform root modules

### Naming convention

This directory introduces a Terraform module naming convention. All Terraform
root modules are expected to reside in the [../../modules/poc](../../modules/poc)
directory, and their names must start with the prefix `aws-`.

### Additional inputs

The following inputs are provided to all Terraform root modules used in
configurations below this directory layer via `TF_VAR_` environment variables:

- **default_region** (`string`): The default AWS region in which to operate
  when no other region is explicitly passed to the root module.
