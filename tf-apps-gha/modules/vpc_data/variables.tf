variable "vpc_name" {
  type        = string
  description = "Name of the VPC to look up"
}

variable "public_subnet_names" {
  type        = list(string)
  description = "Names of public subnets to look up"
}

variable "private_subnet_names" {
  type        = list(string)
  description = "Names of private subnets to look up"
}
