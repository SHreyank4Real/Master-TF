output "public_routetable_id" {
    value = aws_route_table.pub_route_table.id
}

output "private_routetable_id" {
    value = aws_route_table.pvt_route_table.id
}