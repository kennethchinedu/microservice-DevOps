# #=---------------------------EKS
# #=---------------------------EKS
# resource "aws_iam_role" "eks-cluster-role" {
#   name = "eks-cluster-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "sts:AssumeRole",
#         ]
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"

#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks-cluster-role.name
# }





# resource "aws_eks_cluster" "cluster_node" {
#   name     = "my-cluster"
#   role_arn = aws_iam_role.eks-cluster-role.arn

#   vpc_config {
#     endpoint_private_access = true
#     endpoint_public_access  = true
#     subnet_ids = [
#       var.prisub1, #!!!!!!CHANGE THIS TO  PRIVATE SUBNETS!!!!!!!!!!
#       var.prisub2

#     ]
#   } 
#   access_config {
#     authentication_mode                         = "API"
#     bootstrap_cluster_creator_admin_permissions = true 
#   }

#   bootstrap_self_managed_addons = true 

#   version = "1.32"
#   upgrade_policy {
#     support_type = "STANDARD"
#   }
#   depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
# }




# resource "aws_eks_addon" "addons" {
#   for_each                    = toset(var.eks_addons)

#   cluster_name                = aws_eks_cluster.cluster_node.name
#   addon_name                  = each.value
#   resolve_conflicts_on_update = "PRESERVE"
# }





# resource "aws_iam_role" "eks-ng-role" {
#   name = "eks-node-group-role"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks-ng-WorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.eks-ng-role.name
# }

# resource "aws_iam_role_policy_attachment" "eks-ng-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.eks-ng-role.name
# }

# resource "aws_iam_role_policy_attachment" "eks-ng-ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.eks-ng-role.name
# }




# resource "aws_eks_node_group" "eks-node-group" {
#   cluster_name    = "my-cluster"
#   node_role_arn   = aws_iam_role.eks-ng-role.arn
#   node_group_name = "eks-node-group"
#   subnet_ids = [
#     var.pubsub1,           #!!!!!!CHANGE THIS TO  PRIVATE SUBNETS!!!!!!!!!!
#     var.pubsub2

#   ]
#   # launch_template {
#   #   id      = aws_launch_template.eks_node_group_lt.id
#   #   version = "$Latest"
#   # }
#   scaling_config {
#     desired_size = 1
#     max_size     = 4
#     min_size     = 1
#   }
#   update_config {
#     max_unavailable = 1
#   }

#   remote_access {
#     source_security_group_ids = [var.eks_nodes_sg]
#     ec2_ssh_key               = "kube-demo" 
    
#   }
#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
    
#     aws_iam_role_policy_attachment.eks-ng-WorkerNodePolicy,
#     aws_iam_role_policy_attachment.eks-ng-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.eks-ng-ContainerRegistryReadOnly,
#     aws_eks_cluster.cluster_node
#   ]
# }




### Using module to create EKS cluster and node group




#Managed node group

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "my-cluster"
  kubernetes_version = "1.33"
  

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = var.vpc_id
  subnet_ids               = [var.pubsub1, var.pubsub2]
  control_plane_subnet_ids =  [var.prisub1, var.prisub2]
  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    node-group = {
      
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 2
      max_size     = 4
      desired_size = 2
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}