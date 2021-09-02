output "terraform_remote_states" {
  description = <<-EOT
    A map of objects describing the Terraform states created by this module. The
    parent terragrunt.hcl expects an output with this name in any configuration
    pointed to by the `path` config option of the virtual "terragrunt" backend.
  EOT

  value = {
    for key, value in var.terraform_remote_states : key => {
      backend = "local"

      config = {
        path = value.path
      }
    }
  }
}
