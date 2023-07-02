module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.workspace["vpc_name"]
  cidr = local.workspace["vpc_cidr"]

  azs             = local.workspace["azs"]
  private_subnets = local.workspace["private_subnets"]
  public_subnets  = local.workspace["public_subnets"]


  single_nat_gateway                            = local.workspace["single_nat_gateway"]
  enable_nat_gateway                            = local.workspace["enable_nat_gateway"]
  enable_vpn_gateway                            = local.workspace["enable_vpn_gateway"]
  enable_dns_hostnames                          = true
  enable_dns_support                            = true
  enable_ipv6                                   = true
  public_subnet_assign_ipv6_address_on_creation = true
  create_egress_only_igw                        = true

  public_subnet_ipv6_prefixes  = [0, 1, 2]
  private_subnet_ipv6_prefixes = [3, 4, 5]


  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    Environment = terraform.workspace
  }
}
