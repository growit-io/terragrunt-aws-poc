terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.53.0"
    }
  }
}

provider "aws" {
  region = var.default_region

  default_tags {
    tags = {
      Organization = var.organization
      Tier         = var.tier
      Stage        = var.stage
      Layer        = var.layer
      Stack        = var.stack

      TerraformModule    = path.module != "." ? path.module : basename(abspath(path.module))
      TerraformRoot      = path.root != "." ? path.root : basename(abspath(path.root))
      TerraformWorkspace = terraform.workspace

      GitRepository = var.git_repository
    }
  }
}

provider "aws" {
  alias  = "member"
  region = var.default_region

  assume_role {
    role_arn = "arn:aws:iam::${local.member_account_id}:role/OrganizationAccountAccessRole"
  }

  default_tags {
    tags = {
      Organization = var.organization
      Tier         = var.tier
      Stage        = var.stage
      Layer        = var.layer
      Stack        = var.stack

      TerraformModule    = path.module != "." ? path.module : basename(abspath(path.module))
      TerraformRoot      = path.root != "." ? path.root : basename(abspath(path.root))
      TerraformWorkspace = terraform.workspace

      GitRepository = var.git_repository
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  management_account_id = data.aws_caller_identity.current.account_id
  member_account_id     = aws_organizations_account.this.id

  email_local_part = split("@", var.parent.management_account_email)[0]
  email_domain     = split("@", var.parent.management_account_email)[1]

  email_user   = try(split(var.email_separator, local.email_local_part)[0], local.email_local_part)
  email_detail = join("-", compact([try(split(var.email_separator, local.email_local_part)[1], ""), var.account]))

  email = coalesce(var.email, "${local.email_user}${var.email_separator}${local.email_detail}@${local.email_domain}")
}

resource "aws_organizations_account" "this" {
  name      = var.account
  email     = local.email
  parent_id = var.parent.organizational_unit.id
}

resource "aws_iam_role" "this" {
  for_each = var.roles
  provider = aws.member

  name        = "${each.key}Role"
  path        = lookup(each.value, "path", "/")
  description = each.value["description"]

  dynamic "inline_policy" {
    for_each = each.value["inline_policies"]

    content {
      name   = inline_policy.value["name"]
      policy = jsonencode(inline_policy.value["policy"])
    }
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          # Fully trust the management account to control access to this role
          AWS = "arn:aws:iam::${local.management_account_id}:root"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "this" {
  for_each = var.roles

  name        = "${replace(title(replace(var.account, "-", " ")), " ", "")}${each.key}Access"
  path        = "/"
  description = "Grants the privilege to assume the ${aws_iam_role.this[each.key].name} role in the ${aws_organizations_account.this.name} account."

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.this[each.key].arn
      }
    ]
  })
}

resource "aws_organizations_policy" "this" {
  for_each = var.organization_policies

  name        = each.key
  description = each.value["description"]

  type    = each.value["type"]
  content = jsonencode(each.value["content"])
}

resource "aws_organizations_policy_attachment" "this" {
  for_each = var.organization_policies

  policy_id = aws_organizations_policy.this[each.key].id
  target_id = local.member_account_id
}
