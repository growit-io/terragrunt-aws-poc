# Website

This configuration uses the
[aws-workloads-website](../../../../../../../modules/poc/aws-workloads-website)
root module to create a static example website hosted in an S3 bucket in the
**eu-west-3** region.

## Dependencies

This configuration depends on the
[workload-example-test](../../../../../management/test/organizations/accounts/workload-example-test)
configuration to specify the AWS account in which the website is to be deployed.

![Dependency graph](graph.svg)
