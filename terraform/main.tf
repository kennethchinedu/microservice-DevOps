provider "aws" {
  region = var.region

}


module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  subnet_cidr        = var.subnet_cidr
  region             = var.region
  availability_zones = var.availability_zones
  # lb_sg_id = module.security.lb_sg_id  
  
  # eks_node_group_id = module.eks.eks_node_group_id
  # eks_node_group_name = module.eks.eks_node_group_name

}

module "eks" {
  source = "./modules/eks"
  # vpc_id = module.vpc.vpc_id
  prisub2 = module.vpc.prisub2
  prisub1 = module.vpc.prisub1
  pubsub1 = module.vpc.pubsub1
  pubsub2 = module.vpc.pubsub2
  eks_nodes_sg = module.security.eks_nodes_sg
  vpc_id           = module.vpc.vpc_id 
  
}


module "security" {
  source             = "./modules/security"
  vpc_id           = module.vpc.vpc_id 
  vpc_cidr = module.vpc.vpc_cidr
  cluster_name = module.eks.eks_cluster_name



}