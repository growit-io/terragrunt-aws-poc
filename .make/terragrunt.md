# terragrunt.mk

The `terragrunt.mk` fragment extends [`subdir.mk`](subdir.md) and invokes
Terragrunt, normally to process a single configuration directory.

The [`terragrunt.run-all.mk`](terragrunt.run-all.md)
fragment can be used instead to process a collection of related Terragrunt
configuration directories recursively.

## Variables

### TERRAFORM

The command to execute in order to invoke Terraform.

Default: `terraform`

### TERRAFORM_LOCK_TIMEOUT

The maximum duration that Terraform will wait to acquire a state lock before
giving up. The value `0s` can be used to give up immediately.

Default: `5m`

### TERRAGRUNT

The command to execute in order to invoke Terragrunt.

Default: `terragrunt`

### TERRAGRUNT_LOG_LEVEL

The logging level for Terragrunt specified via `--terragrunt-log-level`.

**Note:** The actual default log level for Terragrunt (`warn`) is still a bit
too verbose for frequent interactive use, so this Makefile fragment sets it
to `error`. However, at this level Terragrunt may hide some information that
interactive prompts may refer to. For example, when asking the user for
confirmation before executing the `destroy` command.

Default: `error`

### TERRAGRUNT_FLAGS

Additional options and arguments to pass to all Terragrunt commands. The default
value shown here will always be appended.

Default: `--terragrunt-log-level '$(TERRAGRUNT_LOG_LEVEL)' --terragrunt-tfpath '$(TERRAGRUNT_TFPATH)'`

### TERRAGRUNT_INIT_FLAGS

Additional options and arguments to pass only to the `init` command of
Terragrunt. The default value shown here will always be appended.

Default: `$(TERRAGRUNT_FLAGS) -upgrade`

### TERRAGRUNT_PLAN_FLAGS

Additional options and arguments to pass only to the `plan` command of
Terragrunt. The default value shown here will always be appended.

Default: `$(TERRAGRUNT_FLAGS) -lock-timeout=$(TERRAFORM_LOCK_TIMEOUT)`

### TERRAGRUNT_PLAN_OUT

If set, the argument `-out=$(TERRAGRUNT_PLAN_OUT)` will be automatically
appended to `TERRAGRUNT_PLAN_FLAGS` and the generated plan output file will
also be added to `TERRAGRUNT_OUTPUTS` so that the **clean** goal will also
remove it again.

Default: None

### TERRAGRUNT_APPLY_FLAGS

Additional options and arguments to pass only to the `apply` command of
Terragrunt. The default value shown here will always be appended.

Default: `$(TERRAGRUNT_FLAGS) -lock-timeout=$(TERRAFORM_LOCK_TIMEOUT)`

### TERRAGRUNT_DESTROY_FLAGS

Additional options and arguments to pass only to the `destroy` command of
Terragrunt. The default value shown here will always be appended.

Default: `$(TERRAGRUNT_FLAGS) -lock-timeout=$(TERRAFORM_LOCK_TIMEOUT)`

### TERRAGRUNT_OUTPUTS

List of files and directories created by Terragrunt which should be removed by
the **clean** goal.

Default: `.terragrunt-cache`

## Goals

### all

The default goal and alias for the **test** goal.

### lint

This goal invokes the **lint** goal recursively.

### fmt-check

Runs `terraform fmt -check -diff` (with a workaround to treat `.hcl` and `.tf`
file extensions as the same) in order to detect violations of the
[Terraform Configuration Language Style Conventions][canonical-style].

[canonical-style]: https://www.terraform.io/docs/language/syntax/style.html

**Note**: We intentionally avoid the `terragrunt hclfmt` command in the
implementation of this goal because its current output feels more noisy and
less helpful.

### fix

This goal invokes the **fmt** goal recursively.

### fmt

Runs `terraform fmt` to reformat `.hcl` and `.tf` files according to
the [Terraform Configuration Language Style Conventions][canonical-style].

**Note**: We avoid the `terragrunt hclfmt` command in the implementation of
this goal for the same reason as stated under the **fmt-check** goal.

### test

Shorthand for specifying the **lint** and **validate** goals. This goal is
processed recursively.

### init

Executes the `init` command of Terragrunt.

### validate

Executes the `validate` command of Terragrunt.

### plan

Executes the `plan` command of Terragrunt.

### apply

Executes the `apply` command of Terragrunt.

### destroy

Executes the `destroy` command of Terragrunt.

### clean

Removes any files and directories created by Terragrunt from the working tree,
and also processes subdirectories recursively.
