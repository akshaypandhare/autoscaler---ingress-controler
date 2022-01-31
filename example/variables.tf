variable "eks_cluster_id" {
  type        = string
  description = "The name of the cluster where Kubernetes workload is deployed"
}

variable "eks_cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster where Kubernetes workload is deployed"
}

variable "eks_cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer's ARN for the cluster where Kubernetes workload is deployed"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to the AWS resources"
}

variable "chart_version" {
  type        = string
  default     = "1.3.2"
  description = "The exact version of aws-load-balancer-controller chart to install"
}