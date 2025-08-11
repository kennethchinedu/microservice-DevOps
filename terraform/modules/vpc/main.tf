#Resouce for VPC



resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

###### RESOURCES FOR AVAILABILITY ZONES ######

#Public Subnet for az zone 1
resource "aws_subnet" "pubsub1" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.availability_zones[0]
  cidr_block              = var.subnet_cidr[0]
  map_public_ip_on_launch = true
}
#Private Subnet for az zone 1
resource "aws_subnet" "prisub1" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.availability_zones[0]
  cidr_block              = var.subnet_cidr[1]
  map_public_ip_on_launch = false
}

#Public Subnet for az zone 2
resource "aws_subnet" "pubsub2" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.availability_zones[1]
  cidr_block              = var.subnet_cidr[2]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "prisub2" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.availability_zones[1]
  cidr_block              = var.subnet_cidr[3]
  map_public_ip_on_launch = false
}


#internet gateway for vpc
resource "aws_internet_gateway" "i-gateway" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    # local.common_tags,
  { Name = "k8s-igw" })

}

# #Route table for our subnets using the internet gateway
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.i-gateway.id
  }

  # tags = local.common_tags
}



# Associating public route table with our public subnet
resource "aws_route_table_association" "rt_association1" {
  for_each       = local.public_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.public_subnet_rt.id
}


#Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {


  tags = merge(
    # local.common_tags,
    { Name = "nat-eip" }
  )
}



# NAT Gateway for private subnet to access the internet
resource "aws_nat_gateway" "n_gateway" {

  subnet_id     = local.public_subnet_ids["pubsub1"] # Using the first public subnet for NAT Gateway
  allocation_id = aws_eip.nat_eip.id

  # tags = local.common_tags
}

# Route table for private subnet using NAT gateway
resource "aws_route_table" "private_subnet_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.n_gateway.id
  }

  # tags = local.common_tags
}


resource "aws_route_table_association" "rt_association2" {
  for_each       = local.private_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.private_subnet_rt.id
}




###### LOAD BALANCER ########

# #Data for eks node group
data "aws_instances" "eks_nodes" {
  filter {
    name   = "tag:eks:eks-node-group"
    values = [var.eks_node_group_id]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }


  depends_on = [var.eks_node_group_name]
  
}


# resource "aws_lb" "app_load_balancer" {
#   name               = "app-load-balancer"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [var.lb_sg_id]
#   subnets            = values(local.public_subnet_ids) 

#   enable_deletion_protection = false

#   # access_logs {
#   #   bucket  = "loki-devops-clisha1"
#   #   prefix  = "test-lb"
#   #   enabled = true
#   # }

#   tags = {
#     Environment = "production"
#   }
# }

# #Load balancing target group for frontend service
# resource "aws_lb_target_group" "frontend_tg" {
#   name     = "app-load-balancer-tg"
#   port     = 30080
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id

#   health_check {
#     enabled             = true
#     path                = "/"
#     protocol            = "HTTP"
#     matcher             = "200"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#   }
# }

# #Getting the auto scaling group from eks node group and attaching to alb
# data "aws_autoscaling_groups" "eks_node_asgs" {
#   filter {
#     name   = "tag:ekseks-node-group"
#     values = [var.eks_node_group_name]  
#   }
# } 

# # ## Target group attachment to the EC2 instance
# resource "aws_lb_target_group_attachment" "frontend_tg_attach" {
#   for_each         = toset(data.aws_autoscaling_groups.eks_node_asgs.names)
#   target_group_arn = aws_lb_target_group.frontend_tg.arn
#   target_id        = each.value
#   port             = 30080
 
#   depends_on = [
#     aws_lb.app_load_balancer,
#     aws_lb_target_group.frontend_tg
#   ]
# }

# resource "aws_lb_listener" "frontend_listener" {
#   # for_each          = local.public_subnet_ids
#   load_balancer_arn = aws_lb.app_load_balancer.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.frontend_tg.arn
#   }
# }