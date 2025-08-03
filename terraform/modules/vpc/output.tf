# 

output subnet_cidr {
  value = aws_subnet.pubsub1.cidr_block
}

output "prisub2" {
    value = aws_subnet.prisub2.id
}
output "prisub1" {
    value = aws_subnet.prisub1.id
}