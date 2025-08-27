variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  
}