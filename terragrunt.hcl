# Parent terragrunt.hcl (not an actual configuration)
#
# This terragrunt.hcl file is not an actual Terragrunt configuration, but meant
# to be included by (all) other terragrunt.hcl files in this repository via the
# `include` block.
#
# For example:
#
#     # Child terragrunt.hcl
#     include {
#       path = find_in_parent_folders()
#     }
#
# Apart from dependencies, and possibly an `inputs` attribute based on those
# dependencies, the child terragrunt.hcl file should be perfectly functional
# with just an `include` block, without `terraform` or `remote_state` blocks.
# Those blocks will be assembled by this parent terragrunt.hcl file from the
# terragrunt.yml files in the directory hierarchy.
#
# See the rest of this file, or the documentation in this repository to learn
# which attributes are supported in terragrunt.yml files.

# Tell Terragrunt that this isn't an actual, runnable configuration, in case
# we want to run `terragrunt run-all` from the root directory.
skip = true

# All the "heavy-lifting" to provide the above features to child terragrunt.hcl
# files is done by function calls and conditional logic in this `locals` block.
locals {
  ##
  ## General information about special directories in this repository, and the
  ## relationship between the parent and child terragrunt.hcl files.
  ##

  # The directory where this terragrunt.hcl file is located, which is assumed
  # to be the root of the configuration repository.
  root_dir = get_parent_terragrunt_dir()

  # A list that starts with the absolute path to the directory in which this
  # terragrunt.hcl file resides, followed by all relative path components from
  # that base directory the current Terragrunt configuration directory which
  # included this file via an `include` block.
  path_components = concat(
    [local.root_dir],

    # We're using compact() here to handle possible double slashes in the path
    # ("a//b"), although that is unlikely to occur if this file was included
    # via the find_in_parent_folders() function.
    compact(split("/", path_relative_to_include()))
  )

  ##
  ## Variables describing the special directory layers that have a dedicated
  ## YAML configuration file (layers.yml).
  ##

  # The list of absolute paths of all the directories that can possibly contain
  # a terragrunt.yml file. The first directory is the directory which contains
  # this terragrunt.hcl file and the last directory in the list is the directory
  # in which Terragrunt is working, the one from which this file was included.
  possible_layer_directories = [
    for i in range(0, length(local.path_components)) :
      join("/", concat(slice(local.path_components, 0, i + 1)))
  ]

  # A list of absolute paths of all possibly existing terragrunt.yml files.
  possible_layer_config_files = [
    for dir in local.possible_layer_directories : "${dir}/terragrunt.yml"
  ]

  # A list of objects describing the directory layers which actually have a
  # terragrunt.yml file. The first layer should be the root directory, if it
  # has a terragrunt.yml file. The last layer should normally be the parent
  # directory of the current Terraform configuration directory, if the
  # configuration is relying on the implicit root module naming convention
  # rather than defining its own `terraform` block with a `source` attribute.
  # Directories which do not contain a layers.yml are excluded from this list.
  layers = [
    for i in range(0, length(local.possible_layer_config_files)) :
      merge({
        layer = try(local.path_components[i - 1], "root")
        remote_state = {}
      }, yamldecode(file(local.possible_layer_config_files[i])), {
        directory = local.possible_layer_directories[i]
        path_component = local.path_components[i]
        path_component_index = i
      }) if fileexists(local.possible_layer_config_files[i])
  ]

  ##
  ## Define the remote state backend and configuration to use, based on the
  ## terragrunt.yml configuration files in the directory hierarchy. Lower layers
  ## inherit default backend configuration values from the upper layers, but
  ## the lowest layer which has a `remote_state.backend` attribute controls
  ## the default bucket name and object path within the bucket.
  ##

  layer_remote_state = merge([
    for i in range(0, length(local.layers)) :
      merge(local.layers[i].remote_state, {
        path_component_index = local.layers[i].path_component_index
      }) if try(local.layers[i].remote_state.backend != "", false)
  ]...)

  # Relative path from the root to the layer which defines the `remote_state`
  # configuration, but including only layers that have a configuration.
  remote_state_bucket_default = "${join("-", [
    for i in range(1, try(local.layer_remote_state.path_component_index, 1)) :
      local.path_components[i]
  ])}-terraform-state"

  # The relative path from the most nested directory layer that provides a
  # `remote_state` configuration object to the current component configuration
  # directory.
  # TODO: ignore non-layer path components and use only layers' path components
  remote_state_config_path = "${join("/", [
    for i in range(
      try(local.layer_remote_state.path_component_index, 1),
      length(local.path_components)
    ) : local.path_components[i]
  ])}/terraform.tfstate"

  remote_state_config_defaults = {
    s3 = {
      bucket = local.remote_state_bucket_default
      key = local.remote_state_config_path
      dynamodb_table = local.remote_state_bucket_default
      encrypt = true
    }

    terragrunt = {
      output = "terraform_remote_states"
    }
  }

  remote_state_backend = lookup(local.layer_remote_state, "backend", "local")

  remote_state_config = merge(
    try(local.remote_state_config_defaults[local.remote_state_backend], {}),
    try(local.layer_remote_state.config, {})
  )

  # The absolute path to the directory of the most nested directory layer
  # that provides a `remote_state` configuration object.
  remote_state_layer_dir = local.possible_layer_directories[lookup(local.layer_remote_state, "path_component_index", 0)]

  state_dependency_config_path = join("/", [
    local.remote_state_layer_dir,
    lookup(local.remote_state_config, "path", ".")
  ])

  remote_state_generate = lookup(local.layer_remote_state, "generate", {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  })

  remote_state_disable_init = lookup(local.layer_remote_state, "disable_init", false)

  ##
  ## Construct the default inputs for the root module.
  ##

  layer_inputs = merge([
    for layer in local.layers : merge({
      (layer.layer) = layer.path_component
    }, try(layer.inputs, {}))
  ]...)

  github_branch = trimprefix(trimprefix(trimprefix(get_env("GITHUB_REF", ""), "refs/"), "heads/"), "tags/")

  git_commit = run_cmd("--terragrunt-quiet", "git", "rev-parse", "--short", "HEAD")
  git_branch = try(run_cmd("--terragrunt-quiet", "git", "symbolic-ref", "-q", "--short", "HEAD"), local.github_branch)
  git_branch_remote = try(run_cmd("--terragrunt-quiet", "git", "config", "--get", "branch.${local.git_branch}.remote"), "origin")
  git_remote_url = try(run_cmd("--terragrunt-quiet", "git", "config", "--get", "remote.${local.git_branch_remote}.url"), "")

  git_inputs = {
    git_commit = local.git_commit
    git_branch = local.git_branch
    git_repository = trimsuffix(local.git_remote_url, ".git")
  }

  inputs = merge(
    local.layer_inputs,
    local.git_inputs
  )

  ##
  ## Define the default root module source to be used if the current Terragrunt
  ## configuration doesn't define a `terraform` block with a `source` attribute.
  ##

  # A format string that will be used to generate the default `terraform.source`
  # value. The format string may contain references to layer names via `${name}`,
  # or the special substitution `${root_dir}` to interpolate the root directory.
  terraform_source_prefix_format = concat([
    for layer in reverse(local.layers) : layer.terraform.source
      if try(tostring(layer.terraform.source) != "", false)
  ], [""])[0]

  # Similar to `terraform_source_prefix_format`, but this is a string that will
  # be appended to the generated `terraform.source`.
  terraform_source_suffix_format = join("", [
    for layer in local.layers : layer.terraform.source.append
      if try(layer.terraform.source.append, "") != ""
  ])

  terraform_source_format = join("", [
    local.terraform_source_prefix_format,
    local.terraform_source_suffix_format
  ])

  terraform_source = join("", [
    for part in regexall(
      "(?P<prefix>[^$]*)[$]{(?P<variable>[^}]+)}(?P<suffix>[^$]*)",
      local.terraform_source_format
    ) : join("", [
      part.prefix,
      merge(local.layer_inputs, {
        root_dir = local.root_dir
      })[part.variable],
      part.suffix
    ])
  ])

  ##
  ## Variables which control debugging functions in this terragrunt.hcl file.
  ##
  ## Debug output will be printed only when `local.debug` is true and you run
  ## `terragrunt validate`.
  ##

  debug_vars = {
    inputs = local.inputs
    terraform_source = local.terraform_source
  }

  debug = false
}

terraform {
  source = local.terraform_source

  extra_arguments "auto-migrate-state" {
    commands = ["init"]
    arguments = ["-backend=true", "-migrate-state"]
  }

  after_hook "fix-backend-config" {
    commands = local.remote_state_backend == "s3" ? ["init"] : []
    execute = ["sed", "-E", "-i~", "-e", "s/(encrypt[ \\t]*=[ \\t]*)\"([^\"]+)\"/\\1\\2/", local.remote_state_generate.path]
  }

  after_hook "debug" {
    commands = local.debug ? ["validate"] : []
    run_on_error = true

    # https://github.com/hashicorp/terraform/issues/23322#issuecomment-716627898
    execute = ["echo", "-n", replace(yamlencode(local.debug_vars), "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:")]
  }

  after_hook "state_dependency_debug" {
    commands = local.debug ? ["validate"] : []
    run_on_error = true

    # https://github.com/hashicorp/terraform/issues/23322#issuecomment-716627898
    execute = ["echo", "-n", replace(yamlencode(try(dependency.state.outputs, {})), "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:")]
  }
}

dependency "state" {
  config_path = local.remote_state_backend != "terragrunt" ? "${local.root_dir}/.terragrunt/null" : local.state_dependency_config_path
  skip_outputs = local.remote_state_backend != "terragrunt" || abspath("${local.root_dir}/${path_relative_to_include()}") == abspath(local.state_dependency_config_path)
}

remote_state {
  backend = local.remote_state_backend != "terragrunt" ? local.remote_state_backend : dependency.state.outputs[local.remote_state_config.output][local.remote_state_config.key].backend

  config = local.remote_state_backend != "terragrunt" ? local.remote_state_config : merge(
    lookup(local.remote_state_config_defaults, dependency.state.outputs[local.remote_state_config.output][local.remote_state_config.key].backend, {}),
    dependency.state.outputs[local.remote_state_config.output][local.remote_state_config.key].config
  )

  generate = local.remote_state_generate
  disable_init = local.remote_state_backend != "terragrunt" ? local.remote_state_disable_init : true
}

inputs = merge(local.inputs, {
  terraform_remote_state_backend = local.remote_state_backend != "terragrunt" ? local.remote_state_backend : dependency.state.outputs[local.remote_state_config.output][local.remote_state_config.key].backend
  terraform_remote_state_config = local.remote_state_backend != "terragrunt" ? local.remote_state_config : merge(
    lookup(local.remote_state_config_defaults, dependency.state.outputs[local.remote_state_config.output][local.remote_state_config.key].backend, {}),
    dependency.state.outputs[local.remote_state_config.output][local.remote_state_config.key].config
  )
})
