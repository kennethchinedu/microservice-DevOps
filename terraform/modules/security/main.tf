# # Security group for the Load Balancer
# resource "aws_security_group" "lb_sg" {
#   name        = "lb-sg"
#   description = "Security group for the load balancer"
#   vpc_id      = var.vpc_id

#   # Allow inbound HTTP and HTTPS from anywhere
#   ingress {
#     description = "Allow HTTP from internet"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Allow HTTPS from internet"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Allow all outbound traffic
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "lb-sg"
#   }
# }


# Security group for EKS worker nodes
resource "aws_security_group" "eks_nodes_sg" {
  name        = "eks-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  # Only allow inbound traffic from Load Balancer SG on specific ports
  ingress {
    description      = "Allow traffic from LB SG to EKS node ports"
    from_port        = 30000
    to_port          = 32767
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"] ####!!!!! Change this to restrict access to specific IPs or CIDR blocks
    # security_groups  = [aws_security_group.lb_sg.id] # Restrict to LB SG
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-nodes-sg"
  }
}

