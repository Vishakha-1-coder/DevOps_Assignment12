terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.13"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile  # Optional if you use default AWS CLI config
}
