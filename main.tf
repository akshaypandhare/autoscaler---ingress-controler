

locals {
  alb_ingress_controller_release_name = "aws-load-balancer-controller"
  namespace                           = "kube-system"
}

resource "aws_iam_role" "this" {
  name                  = "${var.eks_cluster_id}-alb-ctrl-role"
  description           = "Permissions required by the Kubernetes AWS ALB Ingress controller to do it's job"
  assume_role_policy    = data.aws_iam_policy_document.eks_oidc_assume_role.json
  force_detach_policies = true

  tags = var.tags
}

resource "aws_iam_policy" "this" {
  name        = "${var.eks_cluster_id}-alb-ctrl-policy"
  description = "Permissions that are required to manage AWS Application Load Balancers"
  policy      = data.aws_iam_policy_document.alb_management.json
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}

resource "kubernetes_service_account" "this" {
  provider = kubernetes.eks

  metadata {
    name      = local.alb_ingress_controller_release_name
    namespace = local.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
    }
  }
}

resource "helm_release" "this" {
  provider = helm.eks

  name       = local.alb_ingress_controller_release_name
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = local.namespace
  version    = var.chart_version

  timeout         = 600
  cleanup_on_fail = true
  force_update    = true
  recreate_pods   = true
  atomic          = true

  set {
    name  = "clusterName"
    value = var.eks_cluster_id
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.this.metadata.0.name
  }
}
