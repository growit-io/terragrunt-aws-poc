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
  policy_arns = merge(var.policy_arns, {
    for name, policy in aws_iam_policy.this : name => aws_iam_policy.this[name].arn
  })
}

resource "aws_iam_policy" "this" {
  for_each = var.policies

  name = each.key
  path = lookup(each.value, "path", "/")
  description = each.value["description"]
  policy = jsonencode(each.value["policy"])
}

resource "aws_iam_group" "this" {
  for_each = var.groups

  name = each.key
  path = each.value.path
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each = merge([for group in keys(var.groups) : {
  for policy in var.groups[group].policies : "${group}/${policy}" => {
    group = group
    policy = policy
  }
  }]...)

  group = aws_iam_group.this[each.value.group].name

  # Theoretically, we could assume that all unqualified policy names are simply
  # references to policies in this account, without going through the lookup in
  # var.policy_arns. However, this helps to ensure the referential integrity of
  # our configuration base, as it reminds us to retrieve the ARNs of generated
  # IAM policies from the outputs of some configuration in order to pass them to
  # this module where they will be assigned to IAM groups.
  policy_arn = length(regexall("^arn:", each.value.policy)) > 0 ? each.value.policy : local.policy_arns[each.value.policy]
}
