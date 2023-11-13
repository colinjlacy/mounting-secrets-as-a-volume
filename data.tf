
data "aws_eks_cluster" "selected" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "selected" {
  name = var.cluster_name
}

data "aws_caller_identity" "account" {}
