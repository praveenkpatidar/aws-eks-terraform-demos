variable "github_token" {
  description = "github_token supposed to be in environment variable"
  type        = string
  sensitive   = true
}

resource "kubernetes_namespace_v1" "actions-runner-system" {
  metadata {
    annotations = {
      name = "actions-runner-system"
    }

    labels = {
      project = local.workspace.cluster_name
    }

    name = "actions-runner-system"
  }
}


resource "kubernetes_secret" "controller-manager" {
  metadata {
    name      = "controller-manager"
    namespace = "actions-runner-system"
  }

  data = {
    github_token = var.github_token
  }
  type       = "kubernetes.io/generic"
  depends_on = [kubernetes_namespace_v1.actions-runner-system]
}

resource "helm_release" "actions-runner-controller" {
  name       = "actions-runner-controller"
  repository = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart      = "actions-runner-controller"
  namespace  = "actions-runner-system"
  values = [
    file("${path.module}/values/actions-runner-controller.yaml")
  ]
  depends_on = [
    kubernetes_namespace_v1.actions-runner-system,
    helm_release.karpenter,
    helm_release.cert-manager,
  ]
}
