variable "terraform_remote_states" {
  type = map(object({
    path = string
  }))
}
