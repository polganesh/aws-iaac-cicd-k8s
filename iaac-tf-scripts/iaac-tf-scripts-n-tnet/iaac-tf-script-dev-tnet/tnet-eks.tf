#eks-euc1-dev-tech-vpc001-tnet-001-dedicated-node-group-example

# https://mklein.io/2019/09/30/terraform-import-role-policy/
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
#https://github.com/Young-ook/terraform-aws-eks/blob/1.6.0/modules/alb-ingress/main.tf
#https://alite-international.com/minimal-viable-ci-cd-with-terraform-aws-codepipeline/
# https://github.com/JamesWoolfenden/terraform-aws-codepipeline/blob/master/aws_pipeline.pipe.tf
# IAM FOR SECRET  encryption enabled https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md
# https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/
# https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md
# https://learn.hashicorp.com/tutorials/terraform/eks
# flow for ingress
# https://aws.amazon.com/blogs/opensource/kubernetes-ingress-aws-alb-ingress-controller/

# alb notes https://kubernetes-sigs.github.io/aws-load-balancer-controller/v1.1/guide/walkthrough/echoserver/
# https://kubernetes-sigs.github.io/aws-load-balancer-controller/v1.1/guide/walkthrough/echoserver/
# https://dmaas.medium.com/amazon-eks-ingress-guide-8ec2ec940a70
module "ekscluster" {
  source      = "git@github.com:polganesh/terraform-aws-eks-cluster.git?ref=new-features"
  eks_version = local.eks_version

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
  #enable_ingress_config = true
  # log management
  log_retention_in_days     = 7
  cluster_enabled_log_types = ["api", "authenticator", "controllerManager", "scheduler", "audit"]

  #--------------------------------------------------------------------------------------------------------------------
  # Security - (encryption at rest, transit  and  access control etc)
  #--------------------------------------------------------------------------------------------------------------------
  #The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the
  #log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data
  #remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested.
  #https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html
  #cluster_log_kms_key_id = data.aws_kms_key.n-core-kms.arn # to do get it from data source
  #encrypt_cloudwatch_logs_with_kms_key=true
  # for more info refer encryption config
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster#encryption_config
  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md
  cluster_encryption_config = [
    {
      provider_key_arn = data.aws_kms_key.n-core-kms.arn
      resources        = ["secrets"]
    }
  ]
  fargate_subnets = local.fargate_subnet_ids_list
  #--------------------------------------------------------------------------------------------------------------------
  # Cost
  #--------------------------------------------------------------------------------------------------------------------
  # managed worker node
  # https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html
  #manage node configuration
#  node_group_names = ["on-demand-ngrp", "spot-ngrp"]
#  node_group_scaling_config = [
#    {
#      desired_capacity = 1
#      max_capacity     = 1
#      min_capacity     = 1
#    },
#    {
#      desired_capacity = 1
#      max_capacity     = 10
#      min_capacity     = 1
#    }
#  ]
#    node_groups = [
#      local.on-demand-node-group,
#      local.spot-node-group
#    ]
  node_groups = [
    local.spot-node-group
  ]

  #  node_groups_defaults = {
  #    ami_type  = "AL2_x86_64" # AL2_x86_64 | AL2_x86_64_GPU | AL2_ARM_64 | CUSTOM | BOTTLEROCKET_ARM_64 | BOTTLEROCKET_x86_64
  #    disk_size = 50
  #  }

  #  node_groups = {
  #    spot-ng={
  #      desired_capacity = 1
  #      max_capacity     = 10
  #      min_capacity     = 1
  #      instance_types = ["t3.large","t3a.large"]
  #      capacity_type  = "SPOT"
  #      # labels to be applied to node group
  #      k8s_labels = {
  #        Example    = "managed_node_groups_spot",
  #        Repo       = "eks terraform"
  #      }
  #      #https://docs.aws.amazon.com/eks/latest/APIReference/API_Taint.html
  #      taints = [
  #        {
  #          key    = "dedicated"
  #          value  = "gpuGroup"
  #          effect = "NO_SCHEDULE"
  #        }
  #      ]
  #      # https://docs.aws.amazon.com/eks/latest/APIReference/API_NodegroupUpdateConfig.html
  #      update_config = {
  #        #The maximum percentage of nodes unavailable during a version update. This percentage of nodes will be updated
  #        #in parallel, up to 100 nodes at once. This value or maxUnavailable is required to have a value.
  #        max_unavailable_percentage = 50 # or set `max_unavailable`
  #      }
  #    }
  #    dedt-ng={
  #      desired_capacity = 1
  #      max_capacity     = 10
  #      min_capacity     = 1
  #      instance_types = ["t3.large","t3a.large"]
  #      #capacity_type  = "ON_DEMAND" # default is on demand
  #      # labels to be applied to node group
  #      k8s_labels = {
  #        Example    = "managed_node_groups_spot",
  #        Repo       = "eks terraform"
  #      }
  #      #https://docs.aws.amazon.com/eks/latest/APIReference/API_Taint.html
  #      taints = [
  #        {
  #          key    = "dedicated"
  #          value  = "gpuGroup"
  #          effect = "NO_SCHEDULE"
  #        }
  #      ]
  #      # https://docs.aws.amazon.com/eks/latest/APIReference/API_NodegroupUpdateConfig.html
  #      update_config = {
  #        #The maximum percentage of nodes unavailable during a version update. This percentage of nodes will be updated
  #        #in parallel, up to 100 nodes at once. This value or maxUnavailable is required to have a value.
  #        max_unavailable_percentage = 50 # or set `max_unavailable`
  #      }
  #    }
  #  }
  #---- fargate
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

    #    secondary = {
    #      name = "secondary"
    #      selectors = [
    #        {
    #          namespace = "default"
    #          labels = {
    #            Environment = "test"
    #            GithubRepo  = "terraform-aws-eks"
    #            GithubOrg   = "terraform-aws-modules"
    #          }
    #        }
    #      ]
    #
    #      # Using specific subnets instead of the ones configured in EKS (`subnets` and `fargate_subnets`)
    #      subnets = [data.aws_subnet_ids.private_app_subnets.ids]
    #
    #      tags = {
    #        Owner = "secondary"
    #      }
    #    }
    #  }
  }

  #depends_on = [aws_kms_key.eks]



}

# please note
# how vpc selected
#   it select vpc which has name  vpc-${var.region_id}*-${var.cost_centre}-${var.vpc_seq_id}"
# please note for simplicity it is ignoring env. we assume it vpc seq id will be incremental if needed.
# for more information about how worker nodes, alb selected refer
# https://github.com/polganesh/terraform-aws-eks-cluster/blob/master/data.tf#L19
# https://github.com/polganesh/terraform-aws-eks-cluster/blob/master/data.tf#L28
#module "ekscluster" {
#  source  = "polganesh/eks-cluster/aws"
#  version = "1.0.1"
#  # these are EKS optimized images more information about ami id based on k8s cluster and region at
#  # https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
#  image_id = "ami-0f85d2eeb0bea62a7"
#  # it supports X.xx but does not support X.xx.x
#  eks_version = "1.19"
#
#  #--------------------------------------------------------------------------------------------------------------------
#  # Security
#  #--------------------------------------------------------------------------------------------------------------------
#  key_name = "devops-infra-key"
#  # in real life it must be company specific CIDR,enable access only from it
#  inbound_cidr_rules_for_workstation_https = [["95.91.240.28/32"]]
#  control_plane_logging_to_be_enabled      = ["api", "authenticator", "controllerManager", "scheduler"]
#
#  #--------------------------------------------------------------------------------------------------------------------
#  # Cost Control
#  #--------------------------------------------------------------------------------------------------------------------
#  desired_capacity = "1"
#  min_size         = "1"
#  max_size         = "1"
#  worker_node_instance_types = [
#    {
#      instance_type = "t3a.medium"
#    },
#    {
#      instance_type = "t3.medium"
#    },
#    {
#      instance_type = "t2.medium"
#    },
#    {
#      instance_type = "t2.micro"
#    }
#  ]
#  #---------
#  # This will
#  # enable 6 instances to be SPOT while 4 instances on demand instance when total count is 10
#  #
#  #----------
#  # 0% has to be on on_demand instances for base capacity
#  worker_node_on_demand_base_capacity = "0"
#  #40 percent above base capacity has to be run on on_demand instances
#  worker_node_on_demand_percentage_above_base_capacity = "40"
#  # it is used for running spot instances else capacity-optimized
#  worker_node_spot_allocation_strategy = "lowest-price"
#  worker_node_spot_max_price           = "0.030"
#
#  #--------------------------------------------------------------------------------------------------------------------
#  # Maintainability - (helpful for creating tags, resources names)
#  #--------------------------------------------------------------------------------------------------------------------
#  region      = "eu-central-1"
#  region_id   = "euc1"
#  cost_centre = "tech"
#  vpc_seq_id  = "001"
#  seq_id      = "001"
#  environment = "iaac-tf-script-dev-common"
#  app_service = "tnet"
#  build_date  = "19-12-2021"
#}
#
output "kubeconfig" {
  value = module.ekscluster.kubeconfig
}


output "config_map_aws_auth" {
  value = module.ekscluster.config_map_aws_auth
}