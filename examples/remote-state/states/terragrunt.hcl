include {
  path = find_in_parent_folders()
}

inputs = {
  terraform_remote_states = {
    apples = {
      path = "${get_terragrunt_dir()}/apples.tfstate"
    }

    oranges = {
      path = "${get_terragrunt_dir()}/oranges.tfstate"
    }
  }
}
