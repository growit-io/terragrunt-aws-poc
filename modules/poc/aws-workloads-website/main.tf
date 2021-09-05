terraform {
  required_version = "~> 1.0.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.53.0"
    }
  }
}

provider "aws" {
  region = var.region

  assume_role {
    role_arn = var.account.role_arns.WebsiteAdministrator
  }

  default_tags {
    tags = {
      Organization = var.organization
      Tier         = var.tier
      Stage        = var.stage
      Account      = var.account.name
      Layer        = var.layer

      TerraformModule    = path.module != "." ? path.module : basename(abspath(path.module))
      TerraformRoot      = path.root != "." ? path.root : basename(abspath(path.root))
      TerraformWorkspace = terraform.workspace

      GitRepository = var.git_repository
    }
  }
}

module "this" {
  source = "../../aws/s3-website-example"

  organization = var.organization
  stage        = var.stage
}
