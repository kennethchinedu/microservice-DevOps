#EKS outputs


output "endpoint" {
  value = aws_eks_cluster.cluster_node.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster_node.certificate_authority[0].data
} 

output "eks_node_group_id" {
  value = aws_eks_node_group.eks-node-group.id 
}

output "eks_node_group_name" {
  value = aws_eks_node_group.eks-node-group.node_group_name
  
}