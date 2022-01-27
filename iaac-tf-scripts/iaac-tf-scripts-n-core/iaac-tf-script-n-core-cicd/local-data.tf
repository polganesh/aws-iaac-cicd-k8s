locals {
  environment          = "mgmt"
  cost_centre          = "tnet"
  app_service          = "cicd"
  seq_id               = "001"
  region_id            = "euc1"
  role_name_pipeline   = "rol-glob-${local.environment}-${local.cost_centre}-${local.app_service}pipeline-${local.seq_id}"
  policy_name_pipeline = "pol-glob-${local.environment}-${local.cost_centre}-${local.app_service}pipeline-${local.seq_id}"

  role_name_codebuild   = "rol-glob-${local.environment}-${local.cost_centre}-${local.app_service}codebuild-${local.seq_id}"
  policy_name_codebuild = "pol-glob-${local.environment}-${local.cost_centre}-${local.app_service}codebuild-${local.seq_id}"

  s3_artifacts         = "s3-${local.region_id}-${local.environment}-${local.cost_centre}-${local.app_service}artifact-${local.seq_id}"
  s3_code_build_cache  = "s3-${local.region_id}-${local.environment}-${local.cost_centre}-${local.app_service}cachecodebuild-${local.seq_id}"
  kms-key              = "kms-${local.region_id}-${local.environment}-${local.cost_centre}-${local.app_service}-${local.seq_id}"

  common_tags = merge(
    {
      RegionId    = local.region_id
      Environment = local.environment
      CostCentre  = local.cost_centre
      AppService  = local.app_service
  })

}

data "aws_caller_identity" "current" {}

#resource "random_string" "cicd-iam-role-policy-suffix" {
#  length    = 3
#  special   = false
#  min_lower = 3
#}