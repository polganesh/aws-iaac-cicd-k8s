resource "aws_kms_key" "eks" {
  description             = "kms encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags = local.tags
}