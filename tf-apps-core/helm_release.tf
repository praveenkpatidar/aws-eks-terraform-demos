


resource "helm_release" "metrics_server" {
  name       = "bitnami"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  namespace  = "platform"
  values = [
    file("${path.module}/values/metrics-server.yaml")
  ]
  set {
    name  = "apiService.create"
    value = "true"
  }
  depends_on = [kubernetes_namespace_v1.platform, helm_release.alb]
}

resource "helm_release" "dashboard" {
  name       = "dashboard"
  repository = "https://kubernetes.github.io/dashboard"
  chart      = "kubernetes-dashboard"
  namespace  = "platform"
  values = [
    file("${path.module}/values/dashboard.yaml")
  ]
  depends_on = [kubernetes_namespace_v1.platform, helm_release.karpenter]
}

resource "helm_release" "alb" {
  name       = "eks"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  values = [
    file("${path.module}/values/alb.yaml")
  ]
  set {
    name  = "clusterName"
    value = local.workspace.cluster_name
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-${local.workspace.cluster_name}-alb-irsa"
  }
}


resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "https://charts.karpenter.sh/"
  chart      = "karpenter"
  namespace  = "platform"
  values = [
    file("${path.module}/values/karpenter.yaml")
  ]
  set {
    name  = "clusterName"
    value = local.workspace.cluster_name
  }
  set {
    name  = "clusterEndpoint"
    value = data.aws_eks_cluster.cluster.endpoint
  }
  set {
    name  = "aws.defaultInstanceProfile"
    value = "eks-${local.workspace.cluster_name}-karpenter-instance-profile"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-${local.workspace.cluster_name}-karpenter-irsa"
  }
  depends_on = [kubernetes_namespace_v1.platform, helm_release.cert-manager]
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "platform"
  version    = "1.11.2"
  values = [
    file("${path.module}/values/cert-manager.yaml")
  ]
  depends_on = [kubernetes_namespace_v1.platform, helm_release.alb]
}
