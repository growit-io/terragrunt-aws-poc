output "terraform_remote_states" {
  value = {
    for key, value in var.terraform_remote_states : key => {
      backend = "local"

      config = {
        path = value.path
      }
    }
  }
}
