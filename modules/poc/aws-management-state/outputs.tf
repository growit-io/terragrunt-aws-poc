output "access_policy_arns" {
  value = merge([
    for key, value in module.terraform_remote_state : value.access_policy_arns
  ]...)
}

output "terraform_remote_states" {
  value = module.terraform_remote_state
}

output "organization" {
  value = var.organization
}

output "tier" {
  value = var.tier
}

output "stage" {
  value = var.stage
}

output "layer" {
  value = var.layer
}

output "git_repository" {
  value = var.git_repository
}
