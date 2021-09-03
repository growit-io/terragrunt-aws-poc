output "access_policy_arns" {
  value = merge([
    for key, value in module.terraform_remote_state : value.access_policy_arns
  ]...)

  description = "A mapping between the keys used in the `terraform_remote_states` input variable and objects describing the corresponding managed IAM policies."
}

output "terraform_remote_states" {
  value       = module.terraform_remote_state
  description = "A mapping between the keys used in the `terraform_remote_states` input variable and objects describing the corresponding Terraform remote state backend."
}
