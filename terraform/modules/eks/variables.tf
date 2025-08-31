variable "prisub1" {
  description = "ID of the primary subnet 1"
  type        = string

}

variable "prisub2" {
  description = "ID of the primary subnet 2"
  type        = string

}

variable "pubsub1" {
  description = "ID of the public subnet 1"
  type        = string

}

variable "pubsub2" {
  description = "ID of the public subnet 2"
  type        = string

}

variable "eks_nodes_sg" {
  description = "ID of the security group"
  type        = string
  
}

variable "eks_addons" {
  default = ["coredns", "kube-proxy", "vpc-cni", "eks-pod-identity-agent"]
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  
}