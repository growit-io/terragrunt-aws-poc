output "backend" {
  value = "s3"
}

output "config" {
  value = {
    region = data.aws_region.current.id
    bucket = local.bucket
    encrypt = var.encrypt
    dynamodb_table = local.dynamodb_table
  }
}

output "read_only_access_policy_name" {
  value = one(module.access_policies[*].read_only_policy_name)
}

output "read_write_access_policy_name" {
  value = one(module.access_policies[*].read_write_policy_name)
}

output "access_policy_arns" {
  value = one(module.access_policies[*].policy_arns)
}
