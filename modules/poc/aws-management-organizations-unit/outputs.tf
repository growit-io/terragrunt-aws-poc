output "management_account_id" {
  value       = var.parent.management_account_id
  description = "The AWS account ID of the organization's management account."
}

output "management_account_email" {
  value       = var.parent.management_account_email
  description = "The email address of the organization's management account root user."
}

output "organizational_unit" {
  value = {
    id   = aws_organizations_organizational_unit.this.id
    name = aws_organizations_organizational_unit.this.name
  }

  description = "An object describing the organizational unit created by this module."
}
