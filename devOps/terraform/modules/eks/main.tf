#IAM role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.cluster_name}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
  tags = {
    Name                                        = "${var.cluster_name}-eks-cluster-role"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

#IAM role for EKS Node Group
resource "aws_iam_role" "eks_node_group_role" {
  name               = "${var.cluster_name}-eks-node-group-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_group_assume_role_policy.json
  tags = {
    Name                                        = "${var.cluster_name}-eks-node-group-role"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

#Attach policies to EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

#Attach policies to EKS Node Group Role with ec2 permissions
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

#Create EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {

  name    = var.cluster_name
  version = var.cluster_version

  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = concat(
      var.public_subnet_ids,
      var.private_subnet_ids
    )
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name = "${var.cluster_name}-eks-cluster"
  }
}



#Create EKS Node Group
resource "aws_eks_node_group" "eks_node_group" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group-${each.key}"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = each.value.instance_types
  capacity_type   = each.value.capacity_type
  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }
  depends_on = [aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
  aws_iam_role_policy_attachment.ecr_policy]
  tags = {
    Name                                        = "${var.cluster_name}-eks-node-group"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

