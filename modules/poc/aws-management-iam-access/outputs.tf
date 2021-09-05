output "groups" {
  value       = keys(aws_iam_group.this)
  description = "The names of IAM groups managed by this module."
}
