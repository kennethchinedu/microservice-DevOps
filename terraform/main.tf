provider "aws" {
  region = var.region

}


module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  subnet_cidr        = var.subnet_cidr
  region             = var.region
  availability_zones = var.availability_zones

}

module "eks" {
  source = "./modules/eks"
  # vpc_id = module.vpc.vpc_id
  prisub2 = module.vpc.prisub2
  prisub1 = module.vpc.prisub1
  security_group_id = module.security.security_group_id


}


module "security" {
  source             = "./modules/security"
  vpc_id           = module.vpc.vpc_id 
  vpc_cidr = module.vpc.vpc_cidr


}