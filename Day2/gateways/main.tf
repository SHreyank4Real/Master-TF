resource "aws_internet_gateway" "ig" {
    vpc_id = var.vpc_id
    tags = {
      "Name" = var.ig_name
    }
}

resource "aws_eip" "eip_for_natg" {
    domain   = "vpc"
    tags = {
      "Name" = "eip_for_nat-gateway"
    }
}

resource "aws_nat_gateway" "natg" {
    subnet_id = var.subnet_id_for_nat
    allocation_id = aws_eip.eip_for_natg.id
    tags = {
      "Name" : var.nat_name
    }
}