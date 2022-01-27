terraform {
  required_version = "=1.0.11"
  backend "s3" {
    bucket = "iaac-tf-scripts"
    key            = "terraform-ci-app.tf"
    #key            = var.tf-state var not allowed here
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
    encrypt        = "true"

  }
}