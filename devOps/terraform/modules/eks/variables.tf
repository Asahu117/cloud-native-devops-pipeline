#cluster name
variable "cluster_name" {
  description = "Name of the EKS cluster"
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
variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "cluster_version" {
  description = "EKS version"
  type        = string
}