module "vpc_resource" {
  source     = "./vpc"
  vpc_name   = "knightFall"
  cidr_block = "10.0.0.0/16"
}

module "pub_subnet_resource" {
  source        = "./subnets"
  depends_on    = [module.vpc_resource]
  vpc_id        = module.vpc_resource.myvpc_id
  subnet_cidrs  = ["10.0.0.0/20", "10.0.16.0/20"]
  azs           = ["us-east-1a", "us-east-1b"]
  subnet_name   = "public-subnet"
  public_subnet = true
}

module "pvt_subnet_resource" {
  source        = "./subnets"
  depends_on    = [module.vpc_resource]
  vpc_id        = module.vpc_resource.myvpc_id
  subnet_cidrs  = ["10.0.32.0/20", "10.0.48.0/20"]
  azs           = ["us-east-1c", "us-east-1d"]
  subnet_name   = "private-subnet"
  public_subnet = false
}

module "gateway" {
  source            = "./gateways"
  depends_on        = [module.pub_subnet_resource, module.pvt_subnet_resource]
  ig_name           = "ig_for_kightfall"
  nat_name          = "nat_for_knightfall"
  vpc_id            = module.vpc_resource.myvpc_id
  subnet_id_for_nat = module.pub_subnet_resource.subnet_ids[0]
}

module "route_tables" {
  source               = "./routetable"
  depends_on           = [module.vpc_resource, module.pub_subnet_resource, module.pvt_subnet_resource, module.gateway]
  table_for_pub_subnet = "public-rt-for-knightfall"
  table_for_pvt_subnet = "private-rt-for-knightfall"
  vpc_id               = module.vpc_resource.myvpc_id
  ig_gateway_id        = module.gateway.internet_gw_id
  nat_gateway_id       = module.gateway.nat_gw_id
  subnets_for_pubrt    = module.pub_subnet_resource.subnet_ids
  subnets_for_pvtrt    = module.pvt_subnet_resource.subnet_ids
}

module "sub-security_group" {
    #to-do seperate module needed for rule
    source = "./security_groups"
    depends_on = [ module.vpc_resource ]
    sg_name = "for-pub-ec2"
   cidr_block = "103.62.151.244/32"
   allowed_port = "22"
   vpc_id = module.vpc_resource.myvpc_id
   allowed_port_to = "22"
}

module "pvt-security_group" {
    #to-do seperate module needed for rule
    source = "./security_groups"
    depends_on = [ module.vpc_resource ]
    sg_name = "for-pvt-ec2"
   cidr_block = var.cidr_block
   allowed_port = "22"
   vpc_id = module.vpc_resource.myvpc_id
   allowed_port_to = "22"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

module "ec2-public" {
  source = "./ec2"
  security_grp = module.sub-security_group.security_group_id
  subnetid = module.pub_subnet_resource.subnet_ids[1]
  ami = data.aws_ami.ubuntu.id
  ec2_size = "t2.medium"
  ec2_name = "public-ec2"
  volumesize = "30"
  volumetype = "gp2"
  root_volume_size = "20"
}

module "ec2-private" {
  source = "./ec2"
  security_grp = module.pvt-security_group.security_group_id
  subnetid = module.pvt_subnet_resource.subnet_ids[1]
  ami = data.aws_ami.ubuntu.id
  ec2_size = "t2.medium"
  ec2_name = "private-ec2"
  volumesize = "30"
  volumetype = "gp2"
  root_volume_size = "20"
}