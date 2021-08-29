terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.53.0"
    }
  }
}

provider "aws" {
  region = var.default_region

  default_tags {
    tags = {
      Organization = var.organization
      Tier = var.tier
      Stage = var.stage
      Layer = var.layer
      Stack = var.stack

      TerraformModule = path.module != "." ? path.module : basename(abspath(path.module))
      TerraformRoot = path.root != "." ? path.root : basename(abspath(path.root))
      TerraformWorkspace = terraform.workspace

      GitRepository = var.git_repository
    }
  }
}

locals {
  allowed_groups = {
    for group in var.groups : group => group
  }
}

resource "aws_iam_user" "this" {
  for_each = var.users

  name = each.key
  path = each.value.path
}

resource "aws_iam_user_group_membership" "this" {
  for_each = var.users

  user = aws_iam_user.this[each.key].name

  # Theoretically, we could just use the group name as it is, byt this helps to
  # ensure the referential integrity of our configuration by requiring the group
  # to be defined as an allowed group via the var.groups input variable.
  groups = [
    for group in each.value.groups : local.allowed_groups[group]
  ]
}

resource "aws_iam_access_key" "this" {
  for_each = merge([for k, v in var.users : { (k) = v } if v.access_key]...)

  user = aws_iam_user.this[each.key].name
  pgp_key = each.value.pgp_key
}
