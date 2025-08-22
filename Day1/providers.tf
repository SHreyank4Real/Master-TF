terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.10.0"
    }
    tls = {
        version = "4.1.0"
    }
    local = {
        version = "2.5.3"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}