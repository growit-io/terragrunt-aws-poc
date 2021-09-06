include {
  path = find_in_parent_folders()
}

dependency "parent" {
  config_path = "../../units/workloads-test"
}

inputs = {
  roles = {
    WebsiteAdministrator = yamldecode(file("roles/website-administrator.yml"))
    WebsiteDeveloper = yamldecode(file("roles/website-developer.yml"))
  }

  parent = dependency.parent.outputs
}
