#
# cache s3 bucket
#
resource "aws_s3_bucket" "codebuild-cache" {
  bucket = local.s3_code_build_cache
  acl    = "private"
}

resource "aws_s3_bucket" "demo-artifacts" {
  bucket = local.s3_artifacts
  acl    = "private"

  lifecycle_rule {
    id      = "clean-up"
    enabled = "true"

    expiration {
      days = 90
    }
  }
}
#
#resource "random_string" "random" {
#  length  = 8
#  special = false
#  upper   = false
#}
