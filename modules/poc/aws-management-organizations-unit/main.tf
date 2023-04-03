terraform {
  required_version = "~> 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.53.0"
    }
  }
}

provider "aws" {
  region = var.region

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

resource "aws_organizations_organizational_unit" "this" {
  name      = coalesce(var.name, title(var.organizational_unit))
  parent_id = var.parent.organizational_unit.id
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
  target_id = aws_organizations_organizational_unit.this.id
}
