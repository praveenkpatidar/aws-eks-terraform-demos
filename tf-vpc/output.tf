output "vpc_id" {
  description = "ID of the looked-up VPC"
  value       = module.vpc.vpc_id
}

output "public_tier_subnet_ids" {
  description = "List of subnet ids for the public tier"
  value       = module.vpc.public_subnets
}

output "private_tier_subnet_ids" {
  description = "List of subnet ids for the private tier"
  value       = module.vpc.private_subnets
}