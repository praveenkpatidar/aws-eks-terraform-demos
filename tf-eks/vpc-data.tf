data "aws_region" "current" {}

module "vpc_data" {
  source               = "./modules/vpc_data"
  private_subnet_names = local.workspace["private_subnet_names"]
  public_subnet_names  = local.workspace["public_subnet_names"]
  vpc_name             = local.workspace["vpc_name"]
}
