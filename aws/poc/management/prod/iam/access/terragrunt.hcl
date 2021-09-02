include {
  path = find_in_parent_folders()
}

# Provides the TerraformStateRead{Only,Write}Access{Boot,Dev,Prod} policies
dependency "boot_state" {
  config_path = "../../../boot/state"
}

dependency "workload_example_dev_account" {
  config_path = "../../../dev/organizations/accounts/workload-example-dev"
}

dependency "workload_example_prod_account" {
  config_path = "../../../prod/organizations/accounts/workload-example-prod"
}

inputs = {
  groups = yamldecode(file("groups.yml"))

  policies = {
    AccountAdministratorAccess = yamldecode(file("policies/account-administrator-access.yml"))
    SecurityAdministratorAccess = yamldecode(file("policies/security-administrator-access.yml"))
    TerraformAdministratorAccess = yamldecode(file("policies/terraform-administrator-access.yml"))
  }

  policy_arns = merge([
    dependency.boot_state.outputs.access_policy_arns,
    dependency.workload_example_dev_account.outputs.policy_arns,
    dependency.workload_example_prod_account.outputs.policy_arns,
  ]...)
}
