remote_state {
  backend = "local"
  config = {}

  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
