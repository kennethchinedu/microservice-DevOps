# 

output "subnet_cidr" {
  value = aws_subnet.pubsub1.cidr_block
}

output "prisub2" {
  value = aws_subnet.prisub2.id
}
output "prisub1" {
  value = aws_subnet.prisub1.id
}

output "pubsub2" {
  value = aws_subnet.prisub2.id
}
output "pubsub1" {
  value = aws_subnet.prisub1.id
}

output "vpc_cidr" {

  value = var.vpc_cidr
}

output "vpc_id" {
  value = aws_vpc.main.id
}