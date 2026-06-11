#Output values for the EKS module
output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.eks_cluster.certificate_authority
}

output "eks_node_group_names" {
  value = { for node_group in aws_eks_node_group.eks_node_group : node_group.node_group_name => node_group }
}
