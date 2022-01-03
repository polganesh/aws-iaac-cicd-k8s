#ideally it should not be eks but core kms key
resource "aws_kms_key" "eks" {
  description             = "kms encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags = local.tags
}

resource "aws_kms_alias" "core-kms-key" {
  name          = local.kms_alias
  target_key_id = aws_kms_key.eks.key_id
}