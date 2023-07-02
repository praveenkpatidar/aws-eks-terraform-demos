output "vpc_id" {
  description = "ID of the looked-up VPC"
  value       = data.aws_vpc.vpc.id
}

output "public_tier_subnet_ids" {
  description = "List of subnet ids for the public tier"
  value       = data.aws_subnets.public.ids
}

output "private_tier_subnet_ids" {
  description = "List of subnet ids for the private tier"
  value       = data.aws_subnets.private.ids
}

output "default_security_group_ids" {
  description = "List of default security group (returns single value)"
  value       = data.aws_security_groups.default.ids
}
