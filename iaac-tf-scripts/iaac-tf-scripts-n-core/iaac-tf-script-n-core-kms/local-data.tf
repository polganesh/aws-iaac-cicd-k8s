locals {
  region      = "eu-central-1"
  region_id   = "euc1"
  cost_centre = "tech"
  seq_id      = "001"
  environment = "n"
  app_service = "core"

  tags = merge(
    {
      Name        = "kms-${local.region_id}-${local.environment}-${local.cost_centre}-${local.app_service}-${local.seq_id}"
      RegionId    = local.region_id
      Environment = local.environment
      CostCentre  = local.cost_centre
      AppService = local.app_service
      AppRole     = "security-identity-compliance"
    })
}


