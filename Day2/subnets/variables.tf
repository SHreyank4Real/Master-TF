variable "vpc_id" { type = string }

variable "subnet_cidrs" { type  = list(string) }

variable "azs" { type   = list(string)}

variable "subnet_name" {  type = string}

variable "public_subnet" {
  type        = bool
  default     = true
}
