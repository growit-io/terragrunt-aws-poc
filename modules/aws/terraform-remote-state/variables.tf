variable "create" {
  type = bool
  default = true
}

variable "create_access_policies" {
  type = bool
  default = true
}

variable "bucket" {
  type = string
  default = ""
}

variable "dynamodb_table" {
  type = string
  default = ""
}

variable "encrypt" {
  type = bool
  default = true
}

variable "force_destroy" {
  type = bool
  default = false
}

variable "policy_name_prefix" {
  type = string
  default = ""
}

variable "policy_name_suffix" {
  type = string
  default = ""
}

variable "policy_path" {
  type = string
  default = "/"
}

variable "read_only_policy_name" {
  type = string
  default = "TerraformStateReadOnlyAccess"
}

variable "read_write_policy_name" {
  type = string
  default = "TerraformStateReadWriteAccess"
}
