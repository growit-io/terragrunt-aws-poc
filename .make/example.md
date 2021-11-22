# example.mk

The `example.mk` fragment effectively defines goals which execute either
Terraform or Terragrunt in order to verify that the example can be applied and
destroyed without errors.

However, it delegates the definition of rules to either the
[`example.terragrunt.mk`](example.terragrunt.md) fragment, or to the
[`example.terraform.mk`](example.terraform.md) fragment, depending on whether
a file named `terragrunt.hcl` exists in the current directory.

This fragment should be included in every subdirectory of a Terraform module's
`examples` directory. The `examples` directory itself should only include the
[`subdir.mk`](subdir.md) fragment.

| [example.terragrunt.mk](example.terragrunt.md) | Ensures that a root module example scenario can be applied without errors using Terragrunt |
