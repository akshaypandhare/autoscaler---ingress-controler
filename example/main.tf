data "aws_eks_cluster" "this" {
  name = var.eks_cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_id
}

provider "aws" {
    region = "us-west-2"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    token                  = data.aws_eks_cluster_auth.this.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  }
}

provider "kubernetes" {
  token                  = data.aws_eks_cluster_auth.this.token
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
}

module "scaling" {
  source                               = "../"
  eks_cluster_identity_oidc_issuer     = var.eks_cluster_identity_oidc_issuer
  eks_cluster_identity_oidc_issuer_arn = var.eks_cluster_identity_oidc_issuer_arn
  eks_cluster_id                       = var.eks_cluster_id
  providers = {
    kubernetes.eks = kubernetes
    helm.eks       = helm
  }
}


