locals {
  env = {
    demo = {
      aws_region       = "ap-southeast-2"
      cluster_name     = "lab-demo-cluster"
      application_name = "tf-eks-lab"
    }
    test = {
      aws_region       = "ap-southeast-2"
      cluster_name     = "lab-test-cluster"
      application_name = "tf-eks-lab"
    }
  }
  tags = {
    ProjectName = "tf-eks-lab",
  }
  workspace = local.env[terraform.workspace]
}
