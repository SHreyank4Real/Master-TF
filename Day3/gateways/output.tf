output "internet_gw_id" {
    value = aws_internet_gateway.ig.id
}

output "nat_gw_id" {
    value = aws_nat_gateway.natg.id
}