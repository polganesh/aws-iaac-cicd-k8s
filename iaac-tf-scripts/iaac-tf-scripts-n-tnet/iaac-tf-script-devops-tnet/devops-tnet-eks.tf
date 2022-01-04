module "ekscluster" {
  source      = "git@github.com:polganesh/terraform-aws-eks-cluster.git?ref=new-features"
  eks_version = local.eks_version

  #---------------------------------------------------------------------------------------------------------------------
  # Security - (encryption at rest, transit  and  access control etc)
  #---------------------------------------------------------------------------------------------------------------------
  cluster_encryption_config = [
    {
      provider_key_arn = data.aws_kms_key.n-core-kms.arn
      resources        = ["secrets"]
    }
  ]
  # fargate currently run in private subnet
  fargate_subnets = local.fargate_subnet_ids_list
  # this will control who can invoke kubectl commands. ideally some developer groups from org.
  eks_public_access_cidrs = ["0.0.0.0/0"]

  #--------------------------------------------------------------------------------------------------------------------
  # Cost
  #--------------------------------------------------------------------------------------------------------------------
  # for non prod accounts we are running worker nodes on spot instances for checking how spot nodes configured
  # refer local-data.tf
  #https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html
  node_groups = [
    local.spot-node-group
  ]

  # we are running batch jobs, spikes in fargate which are short running tasks.
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "batch-jobs"
        },
        {
          namespace = "default"
          labels = {
            WorkerType = "fargate"
          }
        }
      ]

      tags = {
        Owner = "default"
      }

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
  }

  #--------------------------------------------------------------------------------------------------------------------
  # Maintainability - (helpful for creating tags, resources names)
  #--------------------------------------------------------------------------------------------------------------------
  region      = local.region
  region_id   = local.region_id
  cost_centre = local.cost_centre
  vpc_seq_id  = local.vpc_seq_id
  seq_id      = local.seq_id
  environment = local.environment
  app_service = local.app_service
  build_date  = local.build_date
  # log management
  log_retention_in_days     = 7
  cluster_enabled_log_types = ["api", "authenticator", "controllerManager", "scheduler", "audit"]
}
output "kubeconfig" {
  value = module.ekscluster.kubeconfig
}


output "config_map_aws_auth" {
  value = module.ekscluster.config_map_aws_auth
}