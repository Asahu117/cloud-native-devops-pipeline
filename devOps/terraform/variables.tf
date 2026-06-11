#AWS Region
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

#S3 Bucket Name for Terraform State
variable "s3_bucket" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
}
#DynamoDB Table Name for State Locking
variable "dynamodb_table" {
  description = "The name of the DynamoDB table for Terraform state locking"
  type        = string
}
#DynamoDB Table Name for State Locking Backup
variable "dynamodb_table_backup" {
  description = "The name of the DynamoDB table for Terraform state locking backup"
  type        = string
}
#Availability Zone
variable "availability_zone" {
  description = "The availability zone to deploy resources"
  type        = list(string)
}
#VPC CIDR Block
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}
#Public Subnet CIDR Blocks
variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}
#Private Subnet CIDR Blocks
variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}
#Cluster Name
variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}
#Number of Availability Zones
variable "num_availability_zones" {
  description = "The number of availability zones to use"
  type        = number
}
#EKS Cluster Version
variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
}
#EKS Node Groups
variable "node_groups" {
  description = "Map of EKS Node Groups with their configurations"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
}