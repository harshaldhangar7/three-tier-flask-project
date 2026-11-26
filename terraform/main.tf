
module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr = var.vpc_cidr

  availability_zones = var.availability_zones

  public_subnet_cidrs = var.public_subnet_cidrs

  private_app_subnet_cidrs = var.private_app_subnet_cidrs

  private_db_subnet_cidrs = var.private_db_subnet_cidrs

  single_nat_gateway = var.single_nat_gateway
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}


# -------------------------------
# EKS MODULE
# -------------------------------

module "eks" {
  source = "./modules/eks"

  cluster_name       = "${var.project_name}-${var.environment}"
  kubernetes_version = "1.37"

  # Private application subnets.
  private_subnet_ids = module.networking.private_app_subnet_ids

  environment = var.environment

  # Kubernetes API access restriction.
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  # RDS Secrets Manager integration.
  rds_secret_arn         = module.rds.master_secret_arn
  rds_secret_kms_key_arn = module.rds.kms_key_arn
}

# --------------------------------------------------
# RDS MYSQL MODULE
# --------------------------------------------------

module "rds" {
  source = "./modules/rds"

  # Project details
  project_name = var.project_name
  environment  = var.environment

  # Reuse existing networking resources
  vpc_id                = module.networking.vpc_id
  private_db_subnet_ids = module.networking.private_db_subnet_ids

  # Permit MySQL access from private application subnets
  allowed_app_cidr_blocks = var.private_app_subnet_cidrs

  # Database configuration
  mysql_engine_version = "8.0.46"
  db_instance_class    = "db.t3.micro"
  database_name        = "student_db"

  # Credentials
  db_username = var.db_username

}
