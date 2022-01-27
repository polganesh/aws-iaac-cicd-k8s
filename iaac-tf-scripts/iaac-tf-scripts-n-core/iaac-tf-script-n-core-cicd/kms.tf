#
# kms
#
data "aws_iam_policy_document" "demo-artifacts-kms-policy" {
  policy_id = "key-default-1"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:*",
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_kms_key" "demo-artifacts" {
  description = "kms key for  artifacts for CI CD by AWS code pipeline"
  policy      = data.aws_iam_policy_document.demo-artifacts-kms-policy.json
  #deletion_window_in_days = 7 default is 30 days
  enable_key_rotation = true
  tags = merge(
    {
      Name    = local.kms-key
      AppRole = "security-identity-compliance"
    },
    local.common_tags
  )
}

resource "aws_kms_alias" "demo-artifacts" {
  name          = "alias/${local.kms-key}"
  target_key_id = aws_kms_key.demo-artifacts.key_id

}