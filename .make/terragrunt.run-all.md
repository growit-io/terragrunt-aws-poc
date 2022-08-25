# terragrunt.run-all.mk

The `terragrunt.run-all.mk` fragment extends [`terragrunt.mk`](terragrunt.md) to
prefix all Terragrunt commands with the `run-all` command, to add additional
flags to control recursion features of Terragrunt, and to clean up recursively
when the **clean** goal is invoked.

## Variables

### TERRAGRUNT_PARALLELISM

The value of the `--terragrunt-parallelism` option to pass to Terragrunt. The
actual default value of Terragrunt is unlimited, which would cause the output of
all Terraform runs to be intermixed and become hard to follow. You can set to to
a higher value if you want to speed up configuration processing and don't care
so much about the output.

Default: `1`

### TERRAGRUNT_FLAGS

Additional options and arguments to pass to all Terragrunt commands. The default
value shown here will always be appended in addition to the default value that
is appended by the [`terragrunt.mk`](terragrunt.md) fragment.

Default: `--terragrunt-parallelism '$(TERRAGRUNT_PARALLELISM)' --terragrunt-ignore-external-dependencies`

### TERRAGRUNT_DESTROY_EXCLUDE_DIRS

A list of configuration subdirectories to ignore when executing the `destroy`
command of Terragrunt. This can be useful in scenarios where your configuration
contains a layer which is would require manual intervention to re-create from
scratch, or which is too "costly" to re-create for other reasons, for example,
because you might easily exhaust your cloud provider's API quotas for the
managed resource types.

Default: None

### TERRAGRUNT_DESTROY_FLAGS

A list of arguments to pass to Terragrunt's `destroy` command.
The default value shown here will always be appended.

Default: `--terragrunt-ignore-dependency-errors`
