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
#
# However, since locals are evaluated after dependencies, some conditional logic
# has to be repeated in the dependency block after this locals block.
locals {
  ##
  ## Variables describing the directory hierarchy between the parent and child
  ## terragrunt.hcl files. Additional data about each hierarchy element will ##
  ## loaded from terragrunt.yml files into the `config_hierarchy` variable.
  ##

  # The directory where this terragrunt.hcl file is located, which is assumed
  # to be the root of the configuration repository.
  root_dir = get_parent_terragrunt_dir()

  # Special directories passed to the Terraform root module as inputs.
  directory_inputs = {
    root_dir = local.root_dir
  }

  # A list that starts with the absolute path to the directory in which this
  # terragrunt.hcl file resides, followed by all relative path components from
  # that base directory to the current Terragrunt configuration directory which
  # included this file via an `include` block.
  subdirectory_hierarchy = concat(
    [local.root_dir],
    # We're using compact() here to handle possible double slashes in the path
    # ("a//b"), although that is unlikely to occur if this file was included
    # via the find_in_parent_folders() function.
    compact(split("/", path_relative_to_include()))
  )

  # The list of absolute paths of all the directories that can possibly contain
  # a terragrunt.yml file. The first directory is the directory which contains
  # this terragrunt.hcl file and the last directory in the list is the directory
  # in which Terragrunt is working, the one from which this file was included.
  directory_hierarchy = [
    for i in range(0, length(local.subdirectory_hierarchy)) :
      join("/", concat(slice(local.subdirectory_hierarchy, 0, i + 1)))
  ]

  # The list of absolute paths of all possibly existing terragrunt.yml files.
  config_file_hierarchy = [
    for dir in local.directory_hierarchy : "${dir}/terragrunt.yml"
  ]

  # A list of objects describing the directory hierarchy with metadata loaded
  # from optional terragrunt.yml files.
  config_data_hierarchy = [
    for i in range(0, length(local.config_file_hierarchy)) :
      merge({
        remote_state = {}
        terraform = {}
        inputs = {}
      }, try(yamldecode(file(local.config_file_hierarchy[i])), {}))
  ]

  # A list of objects describing the directory hierarchy with metadata loaded
  # from optional terragrunt.yml files, and some internal attributes added to
  # aid further processing of the configuration hierarchy.
  config_hierarchy = [
    for i in range(0, length(local.config_data_hierarchy)) :
      merge(local.config_data_hierarchy[i], {
        directory = local.directory_hierarchy[i]
        subdirectory = try(local.subdirectory_hierarchy[i + 1], "")
        leading_subdirectories = [
          for j in range(1, i + 1) :
            local.subdirectory_hierarchy[j]
        ]
        leading_layer_subdirectories = [
          for j in range(1, i + 1) :
            local.subdirectory_hierarchy[j]
            if try(local.config_data_hierarchy[j - 1].layer, "") != ""
        ]
        trailing_subdirectories = [
          for j in range(i + 1, length(local.config_file_hierarchy)) :
            local.subdirectory_hierarchy[j]
        ]
      })
  ]

  # Merged `inputs` from all configurations in the directory hierarchy.
  config_inputs = merge([for config in local.config_hierarchy : config.inputs]...)

  ##
  ## Variables derived from directories which contain a terragrunt.yml file
  ## with a `layer` attribute. These directories are of special significance
  ## for the `remote_state` and `terraform` blocks, and they also provide
  ## an automatic input named after the value of the `layer` attribute.
  ##

  # Elements of the configuration hierarchy which have a `layer` attribute.
  layer_config_hierarchy = [
    for config in local.config_hierarchy :
      config if lookup(config, "layer", "") != ""
  ]

  # Automatic input variables derived from the `layer` attributes and the
  # hierarchy of subdirectory names.
  layer_inputs = merge([
    for config in local.layer_config_hierarchy : {
      (config.layer) = config.subdirectory
    }
  ]...)

  ##
  ## Define the remote state to use for the Terragrunt configuration based on
  ## the configuration hierarchy.
  ##

  # The merged value of the `remote_state` attribute from all configurations.
  config_remote_state = merge([for config in local.config_hierarchy : config.remote_state]...)

  # The last configuration in the hierarchy which specifies a value for either
  # the `remote_state.backend`, or `remote_state.config` attribute. Defaults to
  # the child terragrunt.hcl directory's configuration.
  config_remote_state_context = flatten([[
    for config in reverse(local.config_hierarchy) : config
      if lookup(config.remote_state, "backend", "") != "" ||
         lookup(config.remote_state, "config", {}) != {}
  ], reverse(local.config_hierarchy)[0]])[0]

  # The last value of the `remote_state.backend` attribute in the configuration
  # hierarchy. If the value is `terragrunt`, then the actual backend to use will
  # be determined from the outputs of another Terragrunt configuration.
  remote_state_backend = lookup(local.config_remote_state, "backend", "local")

  # Default value for `bucket` config attribute of the GCS backend.
  remote_state_config_defaults_gcs_bucket = join("-", flatten([
    local.config_remote_state_context.leading_layer_subdirectories,
    "terraform-state"
  ]))

  # Default value for the `prefix` config attribute of the GCS backend.
  remote_state_config_defaults_gcs_prefix = join("/", flatten([
    local.config_remote_state_context.trailing_subdirectories
  ]))

  # Default value for the `bucket` attribute of the S3 backend.
  remote_state_config_defaults_s3_bucket = join("-", flatten([
    local.config_remote_state_context.leading_layer_subdirectories,
    "terraform-state"
  ]))

  # Default value for the `dynamodb_table` attribute of the S3 backend.
  remote_state_config_defaults_s3_dynamodb_table = local.remote_state_config_defaults_s3_bucket

  # Default value for the `key` attribute of the S3 backend.
  remote_state_config_defaults_s3_key = join("/", flatten([
    local.config_remote_state_context.trailing_subdirectories,
    "terraform.tfstate"
  ]))

  # Default value for the `key` attribute in the Terragrunt backend config.
  remote_state_config_defaults_terragrunt_key = basename(local.config_remote_state_context.directory)

  remote_state_config_defaults = {
    gcs = {
      bucket = local.remote_state_config_defaults_gcs_bucket
      prefix = local.remote_state_config_defaults_gcs_prefix
    }

    s3 = {
      dynamodb_table = local.remote_state_config_defaults_s3_dynamodb_table
      bucket = local.remote_state_config_defaults_s3_bucket
      key = local.remote_state_config_defaults_s3_key
      encrypt = true
    }

    terragrunt = {
      output = "terraform_remote_states"
      key = local.remote_state_config_defaults_terragrunt_key
    }
  }

  # Defaults for the last specified remote state backend, merged with the last
  # value of the `remote_state.config` attribute in the configuration hierarchy.
  remote_state_config = merge([
    lookup(local.remote_state_config_defaults, local.remote_state_backend, {}),
    lookup(local.config_remote_state, "config", {})
  ]...)

  state_dependency_config_path = local.remote_state_backend == "terragrunt" ? join("/", [
    local.config_remote_state_context.directory,
    local.remote_state_config.path
  ]) : ""

  remote_state_generate = merge({
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }, lookup(local.config_remote_state, "generate", {}))

  remote_state_disable_init = lookup(local.config_remote_state, "disable_init", false)

  ##
  ## Construct the default inputs for the root module in hte `inputs` variable.
  ##

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

  # Automatic input variables passed to the Terraform root module and available
  # for substitutions in the `terraform_source_format` variable.
  inputs = merge(
    local.directory_inputs,
    local.layer_inputs,
    local.config_inputs,
    local.git_inputs
  )

  ##
  ## Define the default root module source to be used if the current Terragrunt
  ## configuration doesn't define a `terraform` block with a `source` attribute.
  ##

  # A format string that will be used to generate the default `terraform.source`
  # value. The format string may contain references to inputs via `${input}`.
  terraform_source_prefix_format = concat([
    for config in reverse(local.config_hierarchy) : config.terraform.source
      if try(tostring(config.terraform.source) != "", false)
  ], [""])[0]

  # Similar to `terraform_source_prefix_format`, but this is a string that will
  # be appended to the generated `terraform.source`.
  terraform_source_suffix_format = join("", [
    for config in local.config_hierarchy : config.terraform.source.append
      if try(config.terraform.source.append, "") != ""
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
      local.inputs[part.variable],
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
    config_hierarchy = local.config_hierarchy
    config_remote_state = local.config_remote_state
    config_remote_state_context = local.config_remote_state_context
    remote_state_config_defaults = local.remote_state_config_defaults
    remote_state_backend = local.remote_state_backend
    remote_state_config = local.remote_state_config
    terraform_source = local.terraform_source
    inputs = local.inputs
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
  config_path = local.remote_state_backend != "terragrunt" ? "${local.root_dir}/.terragrunt/mock" : local.state_dependency_config_path
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
