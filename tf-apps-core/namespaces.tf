
resource "kubernetes_namespace_v1" "platform" {
  metadata {
    annotations = {
      name = "platform"
    }

    labels = {
      project = "lab-eks"
    }

    name = "platform"
  }
}
