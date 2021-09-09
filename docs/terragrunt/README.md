# Terragrunt Usage in This Repository

Terragrunt currently only supports one level of includes via the `include`
block in `terragrunt.hcl` files. This means that it is not easily possible, for
example, to override only the `remote_state` block at different levels of the
directory hierarchy.

To overcome this limitation and to implement other features that Terragrunt
currently does not provide directly, we use a single [parent `terragrunt.hcl` file](../../terragrunt.hcl)
which loads all `terragrunt.yml` files in the directory hierarchy between the
child `terragrunt.hcl` and the parent `terragrunt.hcl` in order to adjust the
behaviour of the included parent `terragrunt.hcl` at different directory levels.

## Parent `terragrunt.hcl` features

- [Hierarchical inputs based on the directory hierarchy](#the-inputs-attribute)
- [Automatic inputs based on directory names in the hierarchy](#the-layer-attribute)
- [Terraform-managed remote state configuration based on the directory hierarchy](#the-remote_state-attribute)
- [Automatic Terraform root module source selection based on the directory hierarchy](#the-terraform-attribute)

## Attributes in `terragrunt.yml` files

### The `inputs` attribute

**Attribute Type:** `any`

[//]: # (TODO: use "Terraform's `function` function" consistently)
[//]: # (TODO: use "Terragrunt's `example` attribute/block" consistently)

The `inputs` attribute from all `terragrunt.yml` files within the directory
hierarchy is merged using Terraform's [`merge()` function](https://www.terraform.io/docs/language/functions/merge.html)
and passed to Terragrunt's [`inputs` attribute](https://terragrunt.gruntwork.io/docs/features/inputs/).

For example, given the following `terragrunt.yml` files in the directory
hierarchy:

[//]: # (TODO: sort example inputs alphabetically)
[//]: # (TODO: add example input demonstrating the shallow merge effect)

```yaml
# prod/terragrunt.yml
inputs:
  enabled: false
  stage: prod
```

```yaml
# prod/website/terragrunt.yml
inputs:
  enabled: true
  domain: example.com
```

Our parent `terragrunt.hcl` would effectively provide the following `inputs`
attribute to any child `terragrunt.hcl` below the `prod/website` directory:

[//]: # (TODO: use canonical formatting in HCL examples)

```hcl
inputs = {
  enabled = true
  domain = "example.com"
  stage = "prod"
}
```

### The `layer` attribute

**Attribute Type:** `string`

The `layer` attribute defines the name of an optional input variable that will
receive the name of any subdirectories at the current directory layer. You can
also think of it as the name of an entity that the directory layer describes.

For example, given the following files in the root of a project that also
contains our parent `terragrunt.hcl` file:

```yaml
# terragrunt.yml
layer: region
```

```hcl
# eu-central-1/terragrunt.hcl
include {
  path = find_in_parent_folders()
}
```

```hcl
# eu-west-3/terragrunt.hcl
include {
  path = find_in_parent_folders()
}
```

The two child `terragrunt.hcl` would automatically receive an input variable
named `region`. The value would be either `eu-central-1` or `eu-west-3`,
depending on the next subdirectory relative to the `terragrunt.yml` file.

Since the input variable is provided via the [`inputs` attribute](https://terragrunt.gruntwork.io/docs/features/inputs/)
in `terragrunt.hcl` and thus via the `TF_VAR_region` environment variable, the
Terraform root module for each configuration is not required to actually have
a `region` variable.

Any explicitly defined input variables will take precedence over input variables
defined via `layer` attributes. In the above example, the `region` input
variable derived from the directory layer could be overridden with an `inputs`
attribute in either a `terragrunt.yml` within the directory hierarchy or in a
child `terragrunt.hcl` file:

```yaml
# A terragrunt.yml file
inputs:
  region: us-central-1
```

```hcl
# A child terragrunt.hcl file
inputs = {
  region = "us-central-1"
}
```

### The `remote_state` attribute

**Attribute Type:** `object({
  backend = string,
  config = any
})`

Our parent `terragrunt.hcl` defines the [`remote_state` block](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#remote_state)
for Terragrunt automatically, based on the `remote_state` attributes
within `terragrunt.yml` files in the directory hierarchy.

The remote state configuration is also made available as input variables to any
Terraform root module, so that it can customize the remote state which might
have been automatically created by Terragrunt.

The `remote_state` blocks of all `terragrunt.yml` files is merged using the
Terragrunt [`merge()` function](https://www.terraform.io/docs/language/functions/merge.html)
and cam define any backed or configuration supported natively by Terraform.

[//]: # (TODO: add a subsection for the virtual `terragrunt` backend)
[//]: # (TODO: find a better description than "pseudo-backend")

Additionally, a pseudo-backend named `terragrunt` can be specified in
`terragrunt.yml` files in order to define the Terragrunt `remote_state` block
based on the outputs of another Terragrunt configuration. This allows us to
manage all Terraform remote states within Terraform itself, except for a single
remote state that we let Terragrunt create for us during the bootstrapping phase.

The `terragrunt` pseudo-backend should be configured as follows:

```yaml
# terragrunt.yml
remote_state:
  backend: terragrunt
  config:
    path: boot                                     # required
    output: terraform_remote_states                # optional
    key: default                                   # required
```

With the above example configuration, the outputs of the `boot` configuration
are expected to contain an output map named `terraform_remote_states` that has
a key named `default` pointing to an object which has a `backend` and `config`
attribute that is supported by Terragrunt and Terraform.

### The `terraform` attribute

**Attribute Type:** `object({ source = string | object({ append = string }))`

If the child terragrunt.hcl does not specify a [`terraform` block](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#terraform),
or that block doesn't have the `source` attribute set, then the logic in our
parent `terragrunt.hcl` automatically determines which root module to use for
the configuration, based on the directory hierarchy and defined configuration
layers in `terragrunt.yml`.

The `terraform.source` attribute in `terragrunt.yml` files can either be a
string or an object with the `append` attribute. If it is a string, then it
specifies an exact value for the Terragrunt attribute `terraform.source`,
replacing any preview value specified in another `terragrunt.yml` files that
exists higher up in the directory hierarchy.

Alternatively, the `terraform.source` attribute in `terragrunt.yml` files can
also be an object with a string-valued `append` attribute.

The Terragrunt attribute `terraform.source` is computed from the
`terraform.source` attribute value with the concatenated values of the
`terraform.source.append` attribute from all `terragrunt.yml` files appended.

The final value passed to Terragrunt is the result of a format string
interpretation where all occurrences of the pattern `${layer}` are replaced with
the value of the layer input variable named `layer`. See the [`layer`
attribute](#the-layer-attribute) for details on how to define layer input
variables.

In addition to the automatic layer input variables, the special
variable `root_dir` may also be used in the format string. Its value is the
absolute path of the directory that contains our parent `terragrunt.ycl` file.

For example, given the following files:

```yaml
# terragrunt.yml

layer: platform

terraform:
  source: '${root_dir}/modules//${platform}-'
```

```yaml
# aws/terragrunt.yml

layer: stage
```

```yaml
# aws/prod/terragrunt.yml

layer: stack

terraform:
  source:
    append: '${stack}'
```

A hypothetical child `terragrunt.hcl` file in the `aws/prod/website` directory
would use a module path of `modules//aws-website` relative to the root directory
of the repository.
