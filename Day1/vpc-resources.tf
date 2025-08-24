#todo how to use same tags in multiple resource
# https://visualsubnetcalc.com
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name        = "sh-vpc"
    Description = "VPC for learning purposes"
    Department  = "IT"
  }
}

#todo use loops to create copies of subnets
#todo how to take diff az automatically
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.0.0/20"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    "Name" : "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.16.0/20"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags = {
    "Name" : "public-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.0.32.0/20"
  availability_zone = "us-east-1c"
  tags = {
    "Name" : "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.0.48.0/20"
  availability_zone = "us-east-1d"
  tags = {
    "Name" : "private-subnet-2"
  }
}

resource "aws_internet_gateway" "ig_custom_vpc" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    "Name" : "Custom VPC IG"
  }
}

resource "aws_eip" "eip_for_nat" {
    domain = "vpc"
    depends_on = [ aws_internet_gateway.ig_custom_vpc ]
    tags = {
      "Name" : "for custom VPC"
    }
}

resource "aws_nat_gateway" "nat_custom_vpc" {
  subnet_id  = aws_subnet.public_subnet_1.id
  allocation_id = aws_eip.eip_for_nat.id
  depends_on = [aws_internet_gateway.ig_custom_vpc]
}

resource "aws_route_table" "route_table_for_public_sg" {
    vpc_id = aws_vpc.custom_vpc.id
    tags = {
      "Name" : "Public sg routes"
    }
}
resource "aws_route" "public_route_for_interent" {
    route_table_id = aws_route_table.route_table_for_public_sg.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_custom_vpc.id
}
resource "aws_route_table_association" "public_route_assocation" {
    route_table_id = aws_route_table.route_table_for_public_sg.id
    for_each = {
      public1 = aws_subnet.public_subnet_1.id
      public2 = aws_subnet.public_subnet_2.id
    }
    subnet_id = each.value
}

resource "aws_route_table" "route_table_for_private_sg" {
    vpc_id = aws_vpc.custom_vpc.id
    tags = {
      "Name" : "private sg routes"
    }
}
resource "aws_route" "private_route_for_interent" {
    route_table_id = aws_route_table.route_table_for_private_sg.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_custom_vpc.id
}
resource "aws_route_table_association" "route_table_for_private_sg" {
    route_table_id = aws_route_table.route_table_for_private_sg.id
    for_each = {
      private1 = aws_subnet.private_subnet_1.id
      private2 = aws_subnet.private_subnet_2.id
    }
    subnet_id = each.value
}
