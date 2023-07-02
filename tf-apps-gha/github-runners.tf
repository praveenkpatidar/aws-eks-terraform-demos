resource "kubernetes_manifest" "default_runner_test" {
  computed_fields = ["spec.limits.resources", "spec.replicas"]
  manifest = yamldecode(
    templatefile("${path.module}/values/github-runners/default-runner.tftpl", {
      name                 = "default-github-runner",
      cluster_name         = local.workspace.cluster_name,
      service_account_name = "actions-runner-controller",
      environment          = terraform.workspace,
      group                = local.workspace.gh_default_runner_group,
      organization         = local.workspace.gh_organization
    })
  )
}

resource "kubernetes_manifest" "default_runner_test_hra" {
  manifest = yamldecode(
    templatefile("${path.module}/values/github-runners/default-runner-hra.tftpl", {
      name = "default-github-runner",
    })
  )
}
