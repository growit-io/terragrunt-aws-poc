# terragrunt.mk

The `terragrunt.mk` fragment extends [`help.mk`](help.md) and invokes
Terragrunt, normally to process a single configuration directory.

The [`terragrunt.run-all.mk`](terragrunt.run-all.md)
fragment can be used instead to process a collection of related Terragrunt
configuration directories recursively.

## Variables

### TERRAFORM

The command to execute in order to invoke Terraform.

Default: `terraform`

### TERRAGRUNT

The command to execute in order to invoke Terragrunt.

Default: `terragrunt`

### TERRAGRUNT_LOG_LEVEL

The logging level for Terragrunt specified via `--terragrunt-log-level`.

**Note:** The actual default log level for Terragrunt (`warn`) is still a bit
too verbose for frequent interactive use, so this Makefile fragment sets it
to `fatal`. However, at this level Terragrunt may hide some information that
interactive prompts may refer to. For example, when asking the user for
confirmation before executing the `destroy` command.

Default: `fatal`

### TERRAGRUNT_FLAGS

Additional options and arguments to pass to all Terragrunt commands. The default
value shown here will always be appended.

Default: `--terragrunt-log-level '$(TERRAGRUNT_LOG_LEVEL)' --terragrunt-tfpath '$(TERRAGRUNT_TFPATH)'`

### TERRAGRUNT_INIT_FLAGS

Additional options and arguments to pass only to the `init` command of
Terragrunt. The default value shown here will always be appended.

Default: `$(TERRAGRUNT_FLAGS) -upgrade`

### TERRAGRUNT_DESTROY_FLAGS

Additional options and arguments to pass only to the `destroy` command of
Terragrunt. The default value shown here will always be appended.

Default: `$(TERRAGRUNT_FLAGS)`

### TERRAGRUNT_OUTPUTS

List of files and directories created by Terragrunt which should be removed by
the **clean** goal.

Default: `.terragrunt-cache`

## Goals

### all

The default goal and alias for the **test** goal.

### lint

An alias for the **fmt-check** goal.

### fmt-check

Runs `terraform fmt -check -diff` (with a workaround to treat `.hcl` and `.tf`
file extensions as the same) in order to detect violations of the
[Terraform Configuration Language Style Conventions][canonical-style].

[canonical-style]: https://www.terraform.io/docs/language/syntax/style.html

**Note**: We intentionally avoid the `terragrunt hclfmt` command in the
implementation of this goal because its current output feels more noisy and
less helpful.

### fix

This goal is currently an alias for the **fmt** goal.

### fmt

Runs `terraform fmt` to reformat `.hcl` and `.tf` files according to
the [Terraform Configuration Language Style Conventions][canonical-style].

**Note**: We avoid the `terragrunt hclfmt` command in the implementation of
this goal for the same reason as stated under the **fmt-check** goal.

### test

Shorthand for specifying the **lint** and **validate** goals.

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

Removes any files and directories created by Terragrunt from the working tree.
