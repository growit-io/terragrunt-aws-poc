output "management_account_id" {
  value = aws_organizations_organization.this.master_account_id
}

output "management_account_email" {
  value = aws_organizations_organization.this.master_account_email
}

output "organizational_unit" {
  value = {
    id = one(aws_organizations_organization.this.roots).id
    name = one(aws_organizations_organization.this.roots).name
  }
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
