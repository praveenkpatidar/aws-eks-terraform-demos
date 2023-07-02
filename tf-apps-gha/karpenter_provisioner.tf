
data "aws_security_groups" "node" {
  filter {
    name   = "group-name"
    values = ["eks-cluster-sg-${local.workspace.cluster_name}-*"]
  }
  filter {
    name   = "vpc-id"
    values = [module.vpc_data.vpc_id]
  }
}

resource "kubernetes_manifest" "gha_nodetemplate" {
  manifest = yamldecode(
    templatefile("${path.module}/values/karpenter/default_nodetemplate.tftpl", {
      name                   = "default-provider"
      cluster_name           = local.workspace.cluster_name
      subnet_selecter        = "${local.workspace.vpc_name}-private*",
      security_groups        = "${join(",", data.aws_security_groups.node.ids)}",
      security_groups_filter = "eks-cluster-sg-${local.workspace.cluster_name}-*"
      instance_profile_name  = "eks-${local.workspace.cluster_name}-karpenter-instance-profile"
    })
  )
}

resource "kubernetes_manifest" "gha_provisioner" {
  computed_fields = ["spec.limits.resources", "spec.requirements"]
  manifest = yamldecode(
    templatefile("${path.module}/values/karpenter/default_provisioner.tftpl", {
      name         = "github-runner",
      provider_ref = "default-provider",
      taint_value  = "github-runner"
    })
  )
}

resource "kubernetes_manifest" "cluster_core_provisioner" {
  computed_fields = ["spec.limits.resources", "spec.requirements"]
  manifest = yamldecode(
    templatefile("${path.module}/values/karpenter/default_provisioner.tftpl", {
      name         = "cluster-core",
      provider_ref = "default-provider",
      taint_value  = "cluster-core"
    })
  )
}
