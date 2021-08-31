# Example Terragrunt Configurations

- [**hello-world**](hello-world): A minimal example that shows how to use the
  [parent `terragrunt.hcl`](../terragrunt.hcl) in this repository in combination
  with the [`terragrunt.yml`](terragrunt.yml) file in this directory to define
  automatic, optional input variables for the Terraform root module.

- [**remote-state**](remote-state): An example that demonstrates the use of the
  virtual `terragrunt` backend in `terragrunt.yml` to define the Terragrunt
  remote state configuration indirectly, based on the outputs of an implicit
  dependency.
