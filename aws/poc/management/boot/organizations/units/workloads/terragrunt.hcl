include {
  path = find_in_parent_folders()
}

dependency "parent" {
  config_path = "../../root"
}

inputs = {
  parent = dependency.parent.outputs
}
