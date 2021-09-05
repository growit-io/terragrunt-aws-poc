# .tflint.hcl

#
# Enable all built-in rules that aren't already enabled by default.
#
# https://github.com/terraform-linters/tflint/tree/master/docs/rules

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true

}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

#
# Enable the AWS plugin and use mostly the rules which are enabled by default,
# with a few additional rules that are normally disabled.
#
# https://github.com/terraform-linters/tflint-ruleset-aws/tree/master/docs/rules

plugin "aws" {
  enabled = true
  version = "0.7.1"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "aws_s3_bucket_name" {
  enabled = true
}
