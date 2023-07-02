locals {
  env = {
    demo = {
      aws_region              = "ap-southeast-2"
      cluster_name            = "lab-demo-cluster"
      application_name        = "tf-eks-lab"
      vpc_name                = "lab-demo-vpc"
      private_subnet_names    = ["lab-demo-vpc-private-ap-southeast-2a", "lab-demo-vpc-private-ap-southeast-2b"]
      public_subnet_names     = ["lab-demo-vpc-public-ap-southeast-2a", "lab-demo-vpc-public-ap-southeast-2b"]
      gh_organization         = "praveenkpatidar-org"
      gh_default_runner_group = "default"
    }
    test = {
      aws_region              = "ap-southeast-2"
      cluster_name            = "lab-test-cluster"
      application_name        = "tf-eks-lab"
      vpc_name                = "lab-test-vpc"
      private_subnet_names    = ["lab-test-vpc-private-ap-southeast-2a", "lab-test-vpc-private-ap-southeast-2b"]
      public_subnet_names     = ["lab-test-vpc-public-ap-southeast-2a", "lab-test-vpc-public-ap-southeast-2b"]
      gh_organization         = "praveenkpatidar-org"
      gh_default_runner_group = "default"
    }
  }
  workspace = local.env[terraform.workspace]
}
