# terraform/provider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.6.6"
}

provider "aws" {
  region = "ap-south-1" # Mumbai Region
}
