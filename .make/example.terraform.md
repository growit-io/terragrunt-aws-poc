# example.terraform.mk

The `example.terraform.mk` fragment includes [`config.mk`](config.md) and
[`help.mk`](help.md) and ensures that a (typically) non-root module example
scenario can be applied without errors using Terraform.

This fragment is normally included indirectly via
the [`example.mk`](example.md) fragment.

## Variables

### TERRAFORM

The command to execute in order to invoke Terraform.

Default: `terraform`

### TERRAFORM_INIT_FLAGS

Additional command-line arguments to pass to the `init` command of Terraform.
The default value shown here is always appended.

Default: `-upgrade`

### TERRAFORM_PLAN_FLAGS

Additional command-line arguments to pass to the `plan` command of Terraform.
The default value shown here is always appended.

Default: `-input=false`

### TERRAFORM_APPLY_FLAGS

Additional command-line arguments to pass to the `apply` and `destroy` commands
of Terraform. The default value shown here is always appended.

Default: `-input=false -auto-approve`

### TERRAFORM_DESTROY_FLAGS

Additional command-line arguments to pass to the `destroy` command of Terraform.
The default value shown here is always appended.

Default: `$(TERRAFORM_APPLY_FLAGS)`

### TERRAFORM_MODULE_DIR

The path to the Terraform module to which the example scenario applies.

Default: `$(CURDIR)/../..`

### TERRAFORM_SOURCES

The list of source files which should trigger re-execution of the example
scenario when changed.

Default: All files matching `*.tf` in the example scenario, the Terraform module
directory, and in child modules of the Terraform module within the `modules`
subdirectory

### TERRAFORM_OUTPUTS

A list of files created by Terraform when applying the example scenario and
which should be removed after successful execution of the **test** goal.

Default: `.terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup`

## Goals

### all

This is the default goal and an alias for the **test** goal.

### test

Invokes the **init**, **validate**, **apply**, and **clean** goals. The
**clean** goal is always invoked, even on failure to avoid leaking resources
created by the example and to leave the source tree in a clean state.

### clean

Invokes the **destroy** goal and then removes all output files to leave the
working tree in a clean state and prepare for another execution of the example
scenario.

### init

Executes the `init` command of Terraform unless it has already been executed
successfully or the files listed in **TERRAFORM_SOURCES** have changed.

### validate

Executes the `validate` command of Terraform unless it has already been executed
successfully or the files listed in **TERRAFORM_SOURCES** have changed.

### plan

Executes the `plan` command of Terraform unless it has already been executed
successfully or the files listed in **TERRAFORM_SOURCES** have changed.

### apply

Executes the `apply` command of Terraform unless it has already been executed
successfully or the files listed in **TERRAFORM_SOURCES** have changed.

### destroy

Executes the `destroy` command of Terraform, but only if there was a previous
attempt to run `apply`.

### shell

Invokes an interactive subshell with the same environment variables set as when
executing other Make goals. This should make it easy for you to run Terraform
(or Terragrunt) commands directly, without going through a Make goal.
