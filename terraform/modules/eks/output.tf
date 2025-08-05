#EKS outputs


output "endpoint" {
  value = aws_eks_cluster.cluster_node.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster_node.certificate_authority[0].data
} 

