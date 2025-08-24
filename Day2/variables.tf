variable "owner_name" {
  type    = string
  default = "shreyank"
}

variable "department" {
  type    = string
  default = "DevOps"
}

variable "environment" {
  type    = string
  default = "DEV"
}

variable "project" {
  type    = string
  default = "Test"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "region" {
  default = "us-east-1"
}