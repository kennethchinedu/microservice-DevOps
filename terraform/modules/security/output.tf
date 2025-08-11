# output "lb_sg_id" {
#   value = aws_security_group.lb_sg.id
# }


output "eks_nodes_sg" {
  value = aws_security_group.eks_nodes_sg.id
}
