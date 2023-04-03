include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "account" {
  config_path = "../../../../../management/${include.root.locals.inputs.stage}/organizations/accounts/${include.root.locals.inputs.account}"
}

inputs = merge({
  account = dependency.account.outputs
  }, get_env("CI", "") != "" ? {} : {
  role = "WebsiteDeveloper"
})
