locals {
  env = {
    demo = {
      vpc_name           = "lab-demo-vpc"
      vpc_cidr           = "10.0.0.0/16"
      azs                = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
      private_subnets    = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
      public_subnets     = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]
      single_nat_gateway = "true"
      enable_nat_gateway = "true"
      enable_vpn_gateway = "false"
    }
    test = {
      vpc_name           = "lab-test-vpc"
      vpc_cidr           = "10.1.0.0/16"
      azs                = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
      private_subnets    = ["10.1.0.0/19", "10.1.32.0/19", "10.1.64.0/19"]
      public_subnets     = ["10.1.96.0/19", "10.1.128.0/19", "10.1.160.0/19"]
      single_nat_gateway = "true"
      enable_nat_gateway = "true"
      enable_vpn_gateway = "false"
    }
  }
  tags = {
    ProjectName = "tf-eks-lab",
  }
  workspace = local.env[terraform.workspace]
}
