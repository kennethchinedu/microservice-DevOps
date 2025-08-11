#=----- EKS
resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"

        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_eks_cluster" "cluster_node" {
  name     = "my-cluster"
  role_arn = aws_iam_role.eks-cluster-role.arn
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids = [
      var.prisub1, #!!!!!!CHANGE THIS TO  PRIVATE SUBNETS!!!!!!!!!!
      var.prisub2

    ]
  }
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
  bootstrap_self_managed_addons = true

  version = "1.32"
  upgrade_policy {
    support_type = "STANDARD"
  }
  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}




resource "aws_iam_role" "eks-ng-role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-ng-WorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-ng-role.name
}

resource "aws_iam_role_policy_attachment" "eks-ng-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-ng-role.name
}

resource "aws_iam_role_policy_attachment" "eks-ng-ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-ng-role.name
}



#Launch Template for EKS Node Group

# resource "aws_launch_template" "eks_node_group_lt" {
#   name_prefix   = "eks-node-"
#   # image_id      = "ami-xxxxxxxxxxxx" # EKS optimized AMI
#   instance_type = "t3.medium"

#   vpc_security_group_ids = [
#     var.security_group_id
#   ]

#   key_name = "kube-demo" 

#   lifecycle {
#     create_before_destroy = true
#   }
# }


resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = "my-cluster"
  node_role_arn   = aws_iam_role.eks-ng-role.arn
  node_group_name = "eks-node-group"
  subnet_ids = [
    var.pubsub1,           #!!!!!!CHANGE THIS TO  PRIVATE SUBNETS!!!!!!!!!!
    var.pubsub2

  ]
  # launch_template {
  #   id      = aws_launch_template.eks_node_group_lt.id
  #   version = "$Latest"
  # }
  scaling_config {
    desired_size = 1
    max_size     = 4
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }

  remote_access {
    source_security_group_ids = [var.eks_nodes_sg]
    ec2_ssh_key               = "kube-demo" 
    
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    
    aws_iam_role_policy_attachment.eks-ng-WorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-ng-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-ng-ContainerRegistryReadOnly,
    aws_eks_cluster.cluster_node
  ]
}