include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  terraform_remote_states = {
    management_boot = {
      create         = false
      bucket         = include.root.inputs.terraform_remote_state_config.bucket
      dynamodb_table = include.root.inputs.terraform_remote_state_config.dynamodb_table
    }

    management_dev  = {}
    management_test = {}
    management_prod = {}

    workloads_dev  = {}
    workloads_test = {}
    workloads_prod = {}
  }
}
