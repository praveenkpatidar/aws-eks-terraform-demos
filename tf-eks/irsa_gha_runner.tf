
# SAMPLE CODE FOR IRSA ROLES FOR EACH POD.
# module "gha_default_runner_with_oidc" {
#  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#  version                       = "v5.17.0"
#  create_role                   = true
#  role_name                     = join("_", [module.eks.cluster_name, "vpc_cni"])
#  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
#  role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
#  oidc_fully_qualified_subjects = ["system:serviceaccount:actions-runner-system:aws-node"]
#}
