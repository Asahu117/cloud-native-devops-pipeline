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