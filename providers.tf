terraform {
  required_version = ">= 1.0.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    kubernetes = {
      source                = "hashicorp/kubernetes"
      version               = ">= 2.5.0"
      configuration_aliases = [kubernetes.eks]
    }
    helm = {
      source                = "hashicorp/helm"
      version               = ">= 2.3.0"
      configuration_aliases = [helm.eks]
    }
  }
}