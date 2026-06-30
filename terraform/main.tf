terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "asahu117-ecommerce-platform-s3-statelock-ap-south-1"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "asahu117-ecommerce-platform-dynamodb-ap-south-1"
    encrypt        = true
  }

}

module "vpc" {
  source = "./modules/vpc"


  cluster_name         = var.cluster_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zone    = var.availability_zone
  environment          = var.environment


}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  node_groups = var.node_groups

  environment = var.environment

}


