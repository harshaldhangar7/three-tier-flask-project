
output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  value = module.networking.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  value = module.networking.private_db_subnet_ids
}

output "nat_gateway_ids" {
  value = module.networking.nat_gateway_ids
}

output "internet_gateway_id" {
  value = module.networking.internet_gateway_id
}

output "frontend_ecr_url" {
  value = module.ecr.frontend_repository_url
}

output "backend_ecr_url" {
  value = module.ecr.backend_repository_url
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_node_group_name" {
  value = module.eks.node_group_name
}


# RDS MySQL endpoint
output "db_endpoint" {
  description = "Complete RDS MySQL endpoint"
  value       = module.rds.db_endpoint
}

# RDS hostname
output "db_hostname" {
  description = "RDS MySQL hostname"
  value       = module.rds.db_hostname
}

# RDS port
output "db_port" {
  description = "RDS MySQL port"
  value       = module.rds.db_port
}

# Database name
output "db_name" {
  description = "RDS database name"
  value       = module.rds.db_name
}

# RDS security group
output "db_security_group_id" {
  description = "RDS security group ID"
  value       = module.rds.db_security_group_id
}
