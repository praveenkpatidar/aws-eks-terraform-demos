module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  cluster_name                   = local.workspace.cluster_name
  cluster_version                = local.workspace.cluster_version
  enable_irsa                    = true
  cluster_endpoint_public_access = true
  # IPV6
  #cluster_ip_family          = "ipv6"
  #create_cni_ipv6_iam_policy = true
  tags = {
    Environment = "training"
  }

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent              = true
      before_compute           = true
      service_account_role_arn = module.vpc_cni_irsa_role.iam_role_arn
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id     = module.vpc_data.vpc_id
  subnet_ids = module.vpc_data.private_tier_subnet_ids

  manage_aws_auth_configmap = true
  aws_auth_roles = [
    # We need to add in the Karpenter node IAM role for nodes launched by Karpenter
    {
      rolearn  = module.karpenter.role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
      ]
    },
  ]
  eks_managed_node_group_defaults = {
    ami_type                   = "AL2_x86_64"
    iam_role_attach_cni_policy = true
    intance_types              = ["t3.xlarge", "t3.2xlarge"]
  }
  eks_managed_node_groups = {
    # Default node group - as provided by AWS EKS
    spot_cluster_core = {
      # By default, the module creates a launch template to ensure tags are propagated to instances, etc.,
      # so we need to disable it to use the default template provided by the AWS EKS managed node group service
      use_custom_launch_template = false
      capacity_type              = "SPOT"
      force_update_version       = true
      disk_size                  = 100
      min_size                   = 1
      max_size                   = 7
      desired_size               = 2
      labels = {
        dedicated = "cluster-core"
      }

      taints = [
        {
          key    = "node-role.kubernetes.io/master"
          effect = "NO_SCHEDULE"
        }
      ]
      iam_role_attach_cni_policy = true
      iam_role_additional_policies = {
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      }
    }
  }
}


data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}
