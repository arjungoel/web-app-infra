terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "web-app" {
  source               = "./web-app"
  region               = var.region
  role_arn             = var.role_arn
  cidr_block           = var.cidr_block
  default_tags         = var.default_tags
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  instance_type        = var.instance_type
  generated_key_name   = var.generated_key_name
  health_check         = var.health_check
}
