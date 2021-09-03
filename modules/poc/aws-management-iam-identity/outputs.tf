output "users" {
  value       = keys(aws_iam_user.this)
  description = "The set of names of all IAM users managed by this module."
}

output "access_keys" {
  value       = { for user, access_key in aws_iam_access_key.this : user => access_key.id }
  description = "A mapping between IAM user name and access key ID for each user that has an access key managed by this module."
}

output "plaintext_access_keys" {
  value = { for user, access_key in aws_iam_access_key.this : user => {
    id     = access_key.id
    secret = access_key.secret
  } if access_key.secret != null }

  sensitive   = true
  description = <<-EOT
    A mapping between IAM user name and access key, where the secret access key is stored unencrypted in the Terraform state.

    These access keys are directly suitable for consumption by other Terraform root modules, but will be stored in plain text in the Terraform state, which means the current Terraform state must be treated as sensitive as well and be readable only by authorized users.
  EOT
}

output "encrypted_access_keys" {
  value = { for user, access_key in aws_iam_access_key.this : user => {
    id               = access_key.id
    encrypted_secret = access_key.encrypted_secret
  } if access_key.encrypted_secret != null }

  description = <<-EOT
    A mapping between IAM user name and access key, where the secret access key is a base64-encoded value encrypted with the PGP key given in the `pgp_key` attribute in the `users` input variable.

    These access keys can not be used directly by other Terraform root modules without decrypting them first.
  EOT
}
