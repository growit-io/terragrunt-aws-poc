output "groups" {
  value = keys(aws_iam_group.this)
}

output "default_region" {
  value = var.default_region
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

output "stack" {
  value = var.stack
}

output "git_repository" {
  value = var.git_repository
}
