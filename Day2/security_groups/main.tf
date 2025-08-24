resource "aws_security_group" "custom_sg" {
    tags = {
      "Name" = var.sg_name
    }
    name = var.sg_name
    vpc_id = var.vpc_id
    description = var.description
    
}

resource "aws_vpc_security_group_egress_rule" "sg_outbound_rule" {
    security_group_id = aws_security_group.custom_sg.id
    cidr_ipv4         = "0.0.0.0/0"
    ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "sg_inboud_rule" {
    security_group_id = aws_security_group.custom_sg.id
    cidr_ipv4 = var.cidr_block
    from_port = var.allowed_port
    to_port = var.allowed_port_to
    ip_protocol = var.protocol
    description = var.description
}