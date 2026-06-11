#cluster name
variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}
#VPC CIDR block
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}
#VPC availability zone
variable "availability_zone" {
  description = "The availability zone for the subnet"
  type        = list(string)
}
#VPC private subnet CIDR blocks
variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}
#VPC public subnet CIDR block
variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}


