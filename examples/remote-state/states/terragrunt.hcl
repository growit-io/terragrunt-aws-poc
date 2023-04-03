include "root" {
  path = find_in_parent_folders()
}

inputs = {
  terraform_remote_states = {
    apples = {
      path = "../states/apples.tfstate"
    }

    oranges = {
      path = "../states/oranges.tfstate"
    }
  }
}
