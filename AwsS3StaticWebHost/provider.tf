terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.71.0"
    }
  }
}

provider "aws" {
  secret_key = var.secret_key_id
  access_key = var.access_key_id
  region     = var.region_name
}


