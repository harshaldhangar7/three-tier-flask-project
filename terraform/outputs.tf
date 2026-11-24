
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