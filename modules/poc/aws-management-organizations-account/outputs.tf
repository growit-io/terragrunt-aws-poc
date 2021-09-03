output "id" {
  value       = aws_organizations_account.this.id
  description = "The ID of the managed AWS Organizations member account."
}

output "name" {
  value       = aws_organizations_account.this.name
  description = "The name of the managed AWS Organizations member account."
}

output "email" {
  value       = aws_organizations_account.this.email
  description = "The email address of the root user of the managed AWS Organizations member account."
}

output "role_arns" {
  value       = { for name, role in aws_iam_role.this : name => role.arn }
  description = "A mapping between role name and ARN for each IAM role managed by this module."
}

output "policy_arns" {
  value       = { for policy in values(aws_iam_policy.this) : policy.name => policy.arn }
  description = "A mapping between policy name and ARN for each IAM policy managed by this module."
}
