output "management_account_id" {
  value       = aws_organizations_organization.this.master_account_id
  description = "The AWS account ID of the organization's management account."
}

output "management_account_email" {
  value       = aws_organizations_organization.this.master_account_email
  description = "The email address of the organization's management account root user."
}

output "organizational_unit" {
  value = {
    id   = one(aws_organizations_organization.this.roots).id
    name = one(aws_organizations_organization.this.roots).name
  }

  description = "An object describing the root organizational unit of the organization."
}
