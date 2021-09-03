output "read_only_policy_name" {
  value = aws_iam_policy.read_only.name
}

output "read_write_policy_name" {
  value = aws_iam_policy.read_write.name
}

output "policy_arns" {
  value = {
    (aws_iam_policy.read_only.name)  = aws_iam_policy.read_only.arn,
    (aws_iam_policy.read_write.name) = aws_iam_policy.read_write.arn
  }
}
