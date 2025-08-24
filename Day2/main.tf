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