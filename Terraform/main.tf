# VPC Configuration
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name           = "weather-app-vpc"
  cidr           = "10.0.0.0/16"
  azs            = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

# EKS Configuration
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.0.0"

  cluster_name    = "weather-cluster"
  cluster_version = "1.21"
  subnets         = module.vpc.private_subnets  
  vpc_id          = module.vpc.vpc_id           

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_size         = 3
      min_size         = 1
      instance_type    = "t3.medium"
    }
  }
}

