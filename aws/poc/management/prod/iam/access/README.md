# IAM Access

This configuration uses the
[aws-management-iam-access](../../../../../../modules/poc/aws-management-iam-access)
root module to create IAM policies, and IAM groups in the management account.

Access to organization member accounts by IAM users should be controlled via
membership in one of the groups defined in this configuration. The IAM policy
documents are defined in the [`policies`](policies) subdirectory, and the IAM
groups that may refer to these policies are defined in the
[`groups.yml`](groups.yml) file.

## Dependencies

This configuration depends on any configuration which provides IAM policies in
the management account that should be attached to an IAM group to provide access
to resources in organization member accounts.

![Dependency graph](graph.svg)
