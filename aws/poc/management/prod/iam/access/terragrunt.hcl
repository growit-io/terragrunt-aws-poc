include "root" {
  path = find_in_parent_folders()
}

dependency "boot_terraform_state" {
  config_path = "../../../boot/terraform-state"
}

dependency "workload_example_dev_account" {
  config_path = "../../../dev/organizations/accounts/workload-example-dev"
}

dependency "workload_example_test_account" {
  config_path = "../../../test/organizations/accounts/workload-example-test"
}

dependency "workload_example_prod_account" {
  config_path = "../../../prod/organizations/accounts/workload-example-prod"
}

inputs = {
  groups = yamldecode(file("groups.yml"))

  policies = {
    AccountAdministratorAccess   = yamldecode(file("policies/account-administrator-access.yml"))
    SecurityAdministratorAccess  = yamldecode(file("policies/security-administrator-access.yml"))
    TerraformAdministratorAccess = yamldecode(file("policies/terraform-administrator-access.yml"))
  }

  policy_arns = merge([
    dependency.boot_terraform_state.outputs.access_policy_arns,
    dependency.workload_example_dev_account.outputs.policy_arns,
    dependency.workload_example_test_account.outputs.policy_arns,
    dependency.workload_example_prod_account.outputs.policy_arns,
  ]...)
}
