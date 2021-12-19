module "vpc" {
  source                  = "git@github.com:polganesh/terraform-aws-vpc.git?ref=latest-features"
  vpc_cidr_block          = "10.10.0.0/16"
  public_subnet_cidr_list = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_app_subnet_list = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
  private_db_subnet_list  = ["10.10.7.0/24", "10.10.8.0/24", "10.10.9.0/24"]
  region                  = "eu-central-1"
  region_id               = "euc1"
  az_list                 = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_seq_id              = "001"
  seq_id                  = "001"
  environment             = "dev"
  cost_centre             = "tech"
  build_date              = "19-12-2021"
  version_id              = "001"
}