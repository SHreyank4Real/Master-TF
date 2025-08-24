variable "sg_name" {}
variable "cidr_block" {}
variable "allowed_port" {}
variable "vpc_id" {}
variable "description" {
    default = "Managed by terrafrom"
}
variable "allowed_port_to" {}
variable "protocol" {
    default = "tcp"
}
variable "rule_description" {
    default = "Managed by TF"
}