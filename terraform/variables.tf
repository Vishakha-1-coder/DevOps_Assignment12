variable "aws_region" {
  description = "AWS region to deploy"
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  default     = "default"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "Ubuntu 20.04 LTS AMI"
  default     = "ami-0c2b8ca1dad447f8a"  # Update for your region
}
