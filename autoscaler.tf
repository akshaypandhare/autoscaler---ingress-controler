module "cluster_autoscaler" {
  source                           = "lablabs/eks-cluster-autoscaler/aws"
  version                          = "1.6.1"
  cluster_name                     = var.eks_cluster_id
  cluster_identity_oidc_issuer     = var.eks_cluster_identity_oidc_issuer
  cluster_identity_oidc_issuer_arn = var.eks_cluster_identity_oidc_issuer_arn
}

