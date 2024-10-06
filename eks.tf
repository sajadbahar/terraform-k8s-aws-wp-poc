#
##
### EKS
##
#
data "aws_eks_cluster" "eks-cluster" {
  name = module.eks.cluster_name
  depends_on = [
  module.eks
  ]
}

data "aws_eks_cluster_auth" "eks-cluster" {
  name = module.eks.cluster_name
  depends_on = [
  module.eks
  ]
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                             = var.eks-cluster-name
  cluster_version                          = "1.30"
  subnet_ids                               = module.vpc.private_subnets
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  vpc_id = module.vpc.vpc_id

  eks_managed_node_groups = {
    alpha = {
      desired_size   = 1
      max_size       = 3
      min_size       = 1
      disk_size      = var.wn-disk-size
      instance_types = var.wn-instance-types[var.stage]
      subnets        = [module.vpc.private_subnets[0]]
    }

    beta = {
      desired_size   = 1
      max_size       = 3
      min_size       = 1
      disk_size      = var.wn-disk-size
      instance_types = var.wn-instance-types[var.stage]
      subnets        = [module.vpc.private_subnets[1]]
    }

    gamma = {
      desired_size   = 1
      max_size       = 3
      min_size       = 1
      disk_size      = var.wn-disk-size
      instance_types = var.wn-instance-types[var.stage]
      subnets        = [module.vpc.private_subnets[2]]
    }
  }

  iam_role_additional_policies = {
    additional = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
  }

}