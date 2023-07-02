data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = var.public_subnet_names
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

}

data "aws_subnets" "private" {

  filter {
    name   = "tag:Name"
    values = var.private_subnet_names
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

data "aws_security_groups" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}
