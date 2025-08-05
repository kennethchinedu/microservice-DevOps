variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for subnets "
  type        = list(string)
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = ""
  
}



variable "availability_zones" {
  description = "List of availability zones for the VPC"
  type        = list(string)
   
}


# defining route table association locals
locals {
  public_subnet_ids = {
   pubsub1 = aws_subnet.pubsub1.id,
   pubsub2 = aws_subnet.pubsub2.id
  }
}

locals {
  private_subnet_ids = {
   prisub1 = aws_subnet.prisub1.id,
   prisub2 = aws_subnet.prisub2.id
  }
}