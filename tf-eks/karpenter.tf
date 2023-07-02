module "karpenter" {
  source                          = "terraform-aws-modules/eks/aws//modules/karpenter"
  cluster_name                    = local.workspace.cluster_name
  iam_role_name                   = "eks-${local.workspace.cluster_name}-karpenter-instance-profile"
  iam_role_use_name_prefix        = false
  irsa_name                       = "eks-${local.workspace.cluster_name}-karpenter-irsa"
  irsa_use_name_prefix            = false
  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
  irsa_namespace_service_accounts = ["platform:karpenter"]
  tags = {
    Environment = terraform.workspace
  }
}
