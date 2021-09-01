output "id" {
  value = aws_organizations_account.this.id
}

output "name" {
  value = aws_organizations_account.this.name
}

output "email" {
  value = aws_organizations_account.this.email
}

output "role_arns" {
  value = {for name, role in aws_iam_role.this : name => role.arn}
}

output "policy_arns" {
  value = {for policy in values(aws_iam_policy.this) : policy.name => policy.arn}
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
