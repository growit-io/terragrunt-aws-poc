include "root" {
  path = find_in_parent_folders()
}

inputs = {
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY"
  ]

  organization_policies = {
    AllowOnlyApprovedRegions = yamldecode(file("policies/allow-only-approved-regions.yml"))
  }
}
