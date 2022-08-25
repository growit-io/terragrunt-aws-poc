include {
  path = find_in_parent_folders()
}

dependency "parent" {
  config_path = "../../../../boot/organizations/units/workloads"
}

inputs = {
  name   = "Prod"
  parent = dependency.parent.outputs
}
