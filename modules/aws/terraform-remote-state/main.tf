resource "random_pet" "this" {
  count = var.bucket == "" ? 1 : 0
}

locals {
  bucket = var.bucket == "" ? random_pet.this[0].id : var.bucket
  dynamodb_table = coalesce(var.dynamodb_table, local.bucket)
}

module "backend_storage" {
  source = "./modules/backend-storage"

  count = var.create ? 1 : 0

  bucket = local.bucket
  encrypt = var.encrypt
  force_destroy = var.force_destroy
  dynamodb_table = local.dynamodb_table
}

data "aws_region" "current" {}

module "access_policies" {
  source = "./modules/access-policies"

  count = var.create_access_policies ? 1 : 0

  region = data.aws_region.current.id
  bucket = local.bucket
  encrypt = var.encrypt
  dynamodb_table = local.dynamodb_table
  name_prefix = var.policy_name_prefix
  name_suffix = var.policy_name_suffix
  path = var.policy_path
  read_only_name = var.read_only_policy_name
  read_write_name = var.read_write_policy_name
}
