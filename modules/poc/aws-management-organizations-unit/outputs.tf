output "management_account_id" {
  value = var.parent.management_account_id
}

output "management_account_email" {
  value = var.parent.management_account_email
}

output "organizational_unit" {
  value = {
    id = aws_organizations_organizational_unit.this.id
    name = aws_organizations_organizational_unit.this.name
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
