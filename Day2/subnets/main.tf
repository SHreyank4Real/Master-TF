resource "aws_subnet" "mysubnets" {
  count = length(var.subnet_cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = var.public_subnet
  tags = {
    Name = "${var.subnet_name}-${count.index + 1}"
  }
}