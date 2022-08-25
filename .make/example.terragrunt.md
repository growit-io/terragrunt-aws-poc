# example.terragrunt.mk

The `example.terragrunt.mk` fragment extends
the [`example.terraform.mk`](example.terraform.md) fragment and ensures that a
(typically) root module example scenario can be applied without errors using
Terragrunt.

This fragment is normally included indirectly via
the [`example.mk`](example.md) fragment.

## Variables

This fragment supports the same variables as
the [`example.terraform.md`](example.terraform.md) fragment, except that it
overrides the value of the **TERRAFORM** variable and extends the default value
of the **TERRAFORM_SOURCES** and **TERRAFORM_OUTPUTS** variables.

The following additional variables are supported by this fragment.

### TERRAGRUNT

The command to execute in order to invoke Terragrunt.

Default: `terragrunt`

### TERRAGRUNT_FLAGS

Additional command-line arguments to pass to every Terragrunt command. The
default value shown here will always be appended.

Default: `--terragrunt-non-interactive --terragrunt-parallelism $(TERRAGRUNT_PARALLELISM)`

### TERRAGRUNT_DESTROY_FLAGS

Additional command-line arguments to pass to the `run-all destroy` command of
Terragrunt. The default value shown here will always be appended.

Default: `--terragrunt-ignore-dependency-errors`

### TERRAGRUNT_PARALLELISM

The maximum number of configurations that Terragrunt should process in parallel.

Without the `--terragrunt-parallelism` option, Terragrunt does not limit the
number of concurrent configurations and will mix the output parallel Terraform
runs, making it hard to follow the output and analyse failures.

Default `1`

## Goals

This fragment supports the same goals as
the [`example.terraform.md`](example.terraform.md) fragment, but will invoke
Terragrunt instead of Terraform, and it extends the cleanup rules for the
**test** goal to also remove the `.terragrunt-cache` directories created by
Terragrunt.
