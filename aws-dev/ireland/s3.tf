module "s3_bucket" {
  source                  = "terraform-aws-modules/s3-bucket/aws"
  bucket                  = "bloomreach-dev-interviews-terraform-ayaelawdan"
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  tags                    = merge({ Name = "bloomreach-dev-interviews-terraform-ayaelawdan" }, local.dev-tags)
  versioning = {
    enabled = true
  }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle_rule = [
    {
      id      = "DeleteObjectVersions"
      enabled = true
      noncurrent_version_expiration = {
        days = 30
      }
    },
  ]
}