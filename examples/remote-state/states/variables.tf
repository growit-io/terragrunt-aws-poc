variable "terraform_remote_states" {
  description = <<-EOT
    A map of objects describing the Terraform states (regardless of whether
    they are actually remote or local) to create and include in the module's
    outputs.
  EOT

  type = map(object({
    path = string
  }))
}
