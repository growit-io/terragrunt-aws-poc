output "backend" {
  value       = "s3"
  description = "The name of the [Terraform remote state backend](https://www.terraform.io/docs/language/settings/backends/index.html) that this module created the required resources for. This will always be the value `\"s3\"`."
}

output "config" {
  value = {
    region         = data.aws_region.current.id
    bucket         = local.bucket
    encrypt        = var.encrypt
    dynamodb_table = local.dynamodb_table
  }

  description = "An object describing the [S3 backend](https://www.terraform.io/docs/language/settings/backends/s3.html) configuration."
}

output "read_only_access_policy_name" {
  value       = one(module.access_policies[*].read_only_policy_name)
  description = "The name of the managed IAM policy which grants read-only access to the S3 bucket. If the `create_access_policies` variable is `false`, then this value will be an empty string."
}

output "read_write_access_policy_name" {
  value       = one(module.access_policies[*].read_write_policy_name)
  description = "The name of the managed IAM policy which grants read-write access to the S3 bucket and DynamoDB table. If the `create_access_policies` variable is `false`, then this value will be an empty string."
}

output "access_policy_arns" {
  value       = one(module.access_policies[*].policy_arns)
  description = "A mapping between the names of all IAM policies managed by this module and their corresponding ARNs."
}
