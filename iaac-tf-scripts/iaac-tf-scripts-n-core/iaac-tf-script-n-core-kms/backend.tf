terraform {
  required_version = "=1.0.11"
  backend "s3" {
    bucket         = "iaac-tf-scripts"
    key            = "iaac-tf-script-n-core-kms.tf"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
    encrypt        = "true"
  }
}