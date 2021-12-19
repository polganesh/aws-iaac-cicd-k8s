# please note
# how vpc selected
#   it select vpc which has name  vpc-${var.region_id}*-${var.cost_centre}-${var.vpc_seq_id}"
# please note for simplicity it is ignoring env. we assume it vpc seq id will be incremental if needed.
# for more information about how worker nodes, alb selected refer
# https://github.com/polganesh/terraform-aws-eks-cluster/blob/master/data.tf#L19
# https://github.com/polganesh/terraform-aws-eks-cluster/blob/master/data.tf#L28
module "ekscluster" {
  source  = "polganesh/eks-cluster/aws"
  version = "1.0.1"
  # these are EKS optimized images more information about ami id based on k8s cluster and region at
  # https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
  image_id = "ami-0f85d2eeb0bea62a7"
  # it supports X.xx but does not support X.xx.x
  eks_version = "1.19"

  #--------------------------------------------------------------------------------------------------------------------
  # Security
  #--------------------------------------------------------------------------------------------------------------------
  key_name = "devops-infra-key"
  # in real life it must be company specific CIDR,enable access only from it
  inbound_cidr_rules_for_workstation_https = [["95.91.240.28/32"]]
  control_plane_logging_to_be_enabled      = ["api", "authenticator", "controllerManager", "scheduler"]

  #--------------------------------------------------------------------------------------------------------------------
  # Cost Control
  #--------------------------------------------------------------------------------------------------------------------
  desired_capacity = "1"
  min_size         = "1"
  max_size         = "1"
  worker_node_instance_types = [
    {
      instance_type = "t3a.medium"
    },
    {
      instance_type = "t3.medium"
    },
    {
      instance_type = "t2.medium"
    },
    {
      instance_type = "t2.micro"
    }
  ]
  #---------
  # This will
  # enable 6 instances to be SPOT while 4 instances on demand instance when total count is 10
  #
  #----------
  # 0% has to be on on_demand instances for base capacity
  worker_node_on_demand_base_capacity = "0"
  #40 percent above base capacity has to be run on on_demand instances
  worker_node_on_demand_percentage_above_base_capacity = "40"
  # it is used for running spot instances else capacity-optimized
  worker_node_spot_allocation_strategy = "lowest-price"
  worker_node_spot_max_price           = "0.030"

  #--------------------------------------------------------------------------------------------------------------------
  # Maintainability - (helpful for creating tags, resources names)
  #--------------------------------------------------------------------------------------------------------------------
  region      = "eu-central-1"
  region_id   = "euc1"
  cost_centre = "tech"
  vpc_seq_id  = "001"
  seq_id      = "001"
  environment = "dev"
  app_service = "tnet"
  build_date  = "19-12-2021"
}

output "kubeconfig" {
  value = module.ekscluster.kubeconfig
}


output "config_map_aws_auth" {
  value = module.ekscluster.config_map_aws_auth
}