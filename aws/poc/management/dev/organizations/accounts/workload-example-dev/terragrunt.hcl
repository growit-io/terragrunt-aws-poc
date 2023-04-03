include "root" {
  path = find_in_parent_folders()
}

dependency "parent" {
  config_path = "../../units/workloads-dev"
}

inputs = {
  roles = {
    WebsiteAdministrator = yamldecode(file("roles/website-administrator.yml"))
  }

  parent = dependency.parent.outputs
}
