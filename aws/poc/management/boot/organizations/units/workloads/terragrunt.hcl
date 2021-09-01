include {
  path = find_in_parent_folders()
}

dependency "parent" {
  config_path = "../../roots/organization"
}

inputs = {
  parent = dependency.parent.outputs
}
