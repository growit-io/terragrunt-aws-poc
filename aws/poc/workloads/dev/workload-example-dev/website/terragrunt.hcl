include {
  path = find_in_parent_folders()
  expose = true
}

dependency "account" {
  config_path = "../../../../management/${include.inputs.stage}/organizations/accounts/${include.inputs.account}"
}

inputs = {
  account = dependency.account.outputs
}
