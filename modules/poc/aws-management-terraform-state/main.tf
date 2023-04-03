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
  region = var.region

  default_tags {
    tags = {
      Organization = var.organization
      Tier         = var.tier
      Stage        = var.stage
      Layer        = var.layer

      TerraformModule    = path.module != "." ? path.module : basename(abspath(path.module))
      TerraformRoot      = path.root != "." ? path.root : basename(abspath(path.root))
      TerraformWorkspace = terraform.workspace

      GitRepository = var.git_repository
    }
  }
}

module "terraform_remote_state" {
  source = "../../aws/terraform-remote-state"

  for_each = var.terraform_remote_states

  bucket                 = lookup(each.value, "bucket", "")
  create                 = lookup(each.value, "create", true)
  create_access_policies = lookup(each.value, "create_access_policies", true)
  dynamodb_table         = lookup(each.value, "dynamodb_table", "")
  force_destroy          = lookup(each.value, "force_destroy", false)

  policy_name_prefix = lookup(each.value, "policy_name_prefix", replace(title(replace(each.key, "/[-_]/", " ")), " ", ""))
  policy_name_suffix = lookup(each.value, "policy_name_suffix", "")
}
