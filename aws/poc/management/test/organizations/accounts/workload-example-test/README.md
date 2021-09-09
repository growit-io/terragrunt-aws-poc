# Workload-Example-Test Account

This configuration uses the
[aws-management-organizations-account](../../../../../../../modules/poc/aws-management-organizations-account)
root module to create an organization member account.

## Roles

The member account will be used to host a static website in an S3 bucket.
Therefore, this configuration creates an IAM role named
[WebsiteAdministratorRole](roles/website-administrator.yml)
which grants only the permission to manage S3 buckets. Additionally, because
developers should have the ability to create and review Terraform execution
plans for test accounts, a second role named
[WebsiteDeveloperRole](roles/website-developer.yml) grants read-only access to
to S3.

## Dependencies

This configuration depends on the [Workloads/Test OU](../../units/workloads-test)
configuration to specify the parent OU for this member account.

![Dependency graph](graph.svg)
