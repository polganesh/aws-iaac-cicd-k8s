locals {
  region                    = "eu-central-1"
  region_id                 = "euc1"
  cost_centre               = "tech"
  vpc_seq_id                = "001"
  seq_id                    = "001"
  environment               = "dev"
  app_service               = "tnet"
  build_date                = "21-12-2021"
  eks_version               = "1.19"
  fargate_subnet_ids_string = join(",", data.aws_subnet_ids.private_app_subnets.ids)
  fargate_subnet_ids_list   = split(",", local.fargate_subnet_ids_string)

  spot-node-group = {
    node_group_name                          = "spot-example"
    scaling_config_desired_capacity          = 2
    scaling_config_max_capacity              = 5
    scaling_config_min_capacity              = 2
    update_config_max_unavailable_percentage = 50
    instance_types                           = [ "t3a.medium", "t3a.large", "m5.large"]
    capacity_type                            = "SPOT"
  }
  on-demand-node-group = {
    node_group_name                          = "on-demand-example"
    scaling_config_desired_capacity          = 1
    scaling_config_max_capacity              = 2
    scaling_config_min_capacity              = 1
    update_config_max_unavailable_percentage = 50
    instance_types                           = ["t2.micro"]
    capacity_type                            = "ON_DEMAND"
  }
}


data "aws_kms_key" "n-core-kms" {
  key_id = "arn:aws:kms:eu-central-1:373612170290:key/593d6491-add5-4c62-a6ed-ddbd715dcb61"
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${local.region_id}*-${local.cost_centre}-${local.vpc_seq_id}"]
  }
}

# get reference of subnet which contains name as privApp
data "aws_subnet_ids" "private_app_subnets" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "*-privApp-*"
  }
}

