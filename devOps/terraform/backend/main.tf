provider "aws" {
  region = var.aws_region
}

#Create s3 bucket for backend state file

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "${var.s3_bucket}-${var.aws_region}"
  acl    = "private"
  tags = {
    Name        = "terraform-state-bucket"
    Environment = "production"
  }
}

#Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "${var.dynamodb_table}-${var.aws_region}"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-state-lock"
    Environment = "production"
  }
}