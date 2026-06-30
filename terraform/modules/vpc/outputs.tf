output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  value = aws_subnet.priv_subnet[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.pub_subnet[*].id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.nat_gateway[*].id
}