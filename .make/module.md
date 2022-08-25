# module.mk

The `module.mk` fragment extends [`config.mk`](config.md)
and [`subdir.mk`](subdir.md) to add goals which check and/or fix source code
formatting, common violations of best practices, and automatically generated
module documentation.

This fragment should be included in the top-level `Makefile` of any Terraform
module, except for nested child modules, unless you want to ensure that those
child modules also adhere to the same conventions as their parent module.

## Variables

The `module.mk` fragment adds the following variables in addition to the
variables supported by the [`config.mk`](config.md) and [`subdir.mk`](subdir.md)
fragments.

### DEFAULT_GOAL

Specifies the goal which should be assumed when no goal has been provided on
the command-line. See also the documentation of [`subdir.mk`](subdir.md).

Default: `lint`

### TERRAFORM

The command to execute in order to invoke Terraform. This could be set to
`terragrunt` in order to invoke Terragrunt instead of Terraform, for example.

Default: `terraform`

### TERRAFORM_DOCS

The command to execute in order to invoke terraform-docs.

Default: `terraform-docs`

### TFLINT

The command to execute in order to invoke TFLint.

Default: `tflint`

### TFLINT_CONFIG

The configuration file to pass to TFLint as the value of the `--config` option.

Default: `$(TOP_DIR)/.tflint.hcl`, where `$(TOP_DIR)` evaluates to the root of
this repository

### REQUIRED_FILES

A list of possibly empty files that should be present in every Terraform module
according to best practices. If any files in this list are missing, the **lint**
goal will fail, but the **required-files** goal should create them.

## Goals

### all

This is the default goal and an alias for **lint**.

### lint

This goal first evaluates the **fmt-check**, **tflint**, and **docs-check**
goals and then invokes the **lint** goal recursively in any subdirectories
according to the rules of the [`subdir.mk`](subdir.md) fragment.

### fix

This goal first evaluates the **fmt**, **missing**, and **docs** goals and then
invokes the **fix** goal recursively in any subdirectories according to the
rules of the [`subdir.mk`](subdir.md) fragment.

### test

This goal first evaluates the **lint** goal and then invokes the **test** goal
recursively in any subdirectories according to the rules of the
[`subdir.mk`](subdir.md) fragment.

### fmt-check

Runs `terraform fmt -check -diff` to detect violations of
the [Terraform Configuration Language Style Conventions][canonical-style] in
`.tf` files.

[canonical-style]: https://www.terraform.io/docs/language/syntax/style.html

### fmt

Runs `terraform fmt` to reformat `.tf` files according to
the [Terraform Configuration Language Style Conventions][canonical-style].

### tflint

Invokes TFLint to check for common violations of best practices for writing
Terraform modules according to the rules defined in the **TFLINT_CONFIG** file.

Since the default rules for this repository require the presence of certain
`.tf` files in every module, this goal also verifies their existence before
invoking TFLint and instructs the user to invoke the **missing** goal in order
to create them, if necessary.

### missing

Creates missing required files for TFLint to pass the default rules defined
for this repository.

### docs-check

Invokes terraform-docs to verify that the automatically generated documentation
sections in the module's `README.md` file are present and up-to-date; otherwise,
instructs the user to invoke the **docs** goal to update the documentation.

### docs

Invokes terraform-docs to inject documentation extracted from the module's
source code into the Terraform module's `README.md` file between `<--
BEGIN_TF_DOCS -->` and `<-- END_TF_DOCS -->` markers, or at the end of the file
if those markers are missing.
