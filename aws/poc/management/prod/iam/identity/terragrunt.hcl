include {
  path = find_in_parent_folders()
}

dependency "access" {
  config_path = "../access"
}

inputs = {
  users  = yamldecode(file("users.yml"))
  groups = dependency.access.outputs.groups
}
