resource "aws_route_table" "pub_route_table" {
    tags = {
      "Name" = var.table_for_pub_subnet
    }
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.ig_gateway_id
    }
}

resource "aws_route_table" "pvt_route_table" {
    tags = {
      "Name" = var.table_for_pvt_subnet
    }
    vpc_id = var.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = var.nat_gateway_id
    }
}

# resource "aws_route_table_association" "pub_association" {
#     for_each = toset(var.subnets_for_pubrt)
#     route_table_id = aws_route_table.pub_route_table.id
#     subnet_id = each.value
# }

# resource "aws_route_table_association" "pvt_association" {
#     for_each = toset(var.subnets_for_pvtrt)
#     route_table_id = aws_route_table.pvt_route_table.id
#     subnet_id = each.value
# }

resource "aws_route_table_association" "pub_association" {
  count          = length(var.subnets_for_pubrt)
  subnet_id      = var.subnets_for_pubrt[count.index]
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "pvt_association" {
  count          = length(var.subnets_for_pvtrt)
  subnet_id      = var.subnets_for_pvtrt[count.index]
  route_table_id = aws_route_table.pvt_route_table.id
}