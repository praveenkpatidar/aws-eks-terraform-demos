locals {
  env = {
    demo = {
      aws_region      = "ap-southeast-2"
      cluster_name    = "lab-demo-cluster"
      cluster_version = "1.25"
      instance_types  = ["t3a.large", "t3.large", "m5a.large", "t2.large", "m5.large", "m4.large"]

      vpc_name             = "lab-demo-vpc"
      private_subnet_names = ["lab-demo-vpc-private-ap-southeast-2a", "lab-demo-vpc-private-ap-southeast-2b"]
      public_subnet_names  = ["lab-demo-vpc-public-ap-southeast-2a", "lab-demo-vpc-public-ap-southeast-2b"]
    }
    test = {
      aws_region      = "ap-southeast-2"
      cluster_name    = "lab-test-cluster"
      cluster_version = "1.25"
      instance_types  = ["t3a.large", "t3.large", "m5a.large", "t2.large", "m5.large", "m4.large"]

      vpc_name             = "lab-test-vpc"
      private_subnet_names = ["lab-test-vpc-private-ap-southeast-2a", "lab-test-vpc-private-ap-southeast-2b"]
      public_subnet_names  = ["lab-test-vpc-public-ap-southeast-2a", "lab-test-vpc-public-ap-southeast-2b"]
    }
  }
  workspace = local.env[terraform.workspace]
  tags = {
    ProjectName = "tf-eks-lab",
  }
}
