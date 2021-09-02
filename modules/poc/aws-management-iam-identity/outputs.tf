output "users" {
  value = keys(aws_iam_user.this)
}

output "access_keys" {
  value = {
    for user, access_key in aws_iam_access_key.this : user => access_key.id
  }
}

output "plaintext_access_keys" {
  value = {
    for user, access_key in aws_iam_access_key.this : user => {
      id = access_key.id
      secret = access_key.secret
    } if access_key.secret != null
  }

  sensitive = true
}

output "encrypted_access_keys" {
  value = {
    for user, access_key in aws_iam_access_key.this : user => {
      id = access_key.id
      encrypted_secret = access_key.encrypted_secret
    } if access_key.encrypted_secret != null
  }
}

output "default_region" {
  value = var.default_region
}

output "organization" {
  value = var.organization
}

output "tier" {
  value = var.tier
}

output "stage" {
  value = var.stage
}

output "layer" {
  value = var.layer
}

output "stack" {
  value = var.stack
}

output "git_repository" {
  value = var.git_repository
}
