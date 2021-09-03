output "read_only_policy_name" {
  value       = aws_iam_policy.read_only.name
  description = "The name of the managed IAM policy which grants read-only access to the S3 bucket."
}

output "read_write_policy_name" {
  value       = aws_iam_policy.read_write.name
  description = "The name of the managed IAM policy which grants read-write access to the S3 bucket and DynamoDB table."
}

output "policy_arns" {
  value = {
    (aws_iam_policy.read_only.name)  = aws_iam_policy.read_only.arn,
    (aws_iam_policy.read_write.name) = aws_iam_policy.read_write.arn
  }

  description = "A mapping between the names of managed IAM policies and their ARNs."
}
