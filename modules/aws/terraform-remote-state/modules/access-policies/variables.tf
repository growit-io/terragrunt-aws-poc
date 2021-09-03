variable "name_prefix" {
  type    = string
  default = ""
}

variable "read_only_name" {
  type = string
}

variable "read_write_name" {
  type = string
}

variable "name_suffix" {
  type    = string
  default = ""
}

variable "path" {
  type    = string
  default = "/"
}

variable "region" {
  type = string
}

variable "bucket" {
  type = string
}

variable "encrypt" {
  type = bool
}

variable "dynamodb_table" {
  type = string
}
