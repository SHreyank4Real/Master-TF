terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.10.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "mycompany-terraform-state-prod-sh001"

  versioning {
    enabled = true   # keeps old states
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = "terraform-locks-prod"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-locks-prod"
    Environment = "prod"
  }
}
