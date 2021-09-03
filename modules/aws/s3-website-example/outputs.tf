output "s3_website_url" {
  value       = "http://${aws_s3_bucket.this.website_endpoint}"
  description = "The HTTP URL of the example S3 website created."
}
