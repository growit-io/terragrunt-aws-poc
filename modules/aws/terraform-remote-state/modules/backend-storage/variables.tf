variable "bucket" {
  type = string
}

variable "encrypt" {
  type    = bool
  default = true
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "dynamodb_table" {
  type = string
}
