
# --------------------------------------------------
# KMS KEY FOR RDS MASTER PASSWORD
# --------------------------------------------------

resource "aws_kms_key" "rds_secret" {
  description             = "KMS key for RDS master password in Secrets Manager"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-secret-key"
    Environment = var.environment
  }
}

# Friendly alias for the KMS key
resource "aws_kms_alias" "rds_secret" {
  name          = "alias/${var.project_name}-${var.environment}-rds-secret"
  target_key_id = aws_kms_key.rds_secret.key_id
}

# --------------------------------------------------
# RDS DB SUBNET GROUP
# --------------------------------------------------

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# --------------------------------------------------
# RDS SECURITY GROUP
# --------------------------------------------------

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Allow MySQL access from private application subnets"
  vpc_id      = var.vpc_id

  ingress {
    description = "MySQL access from private application subnets"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_app_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-sg"
    Environment = var.environment
  }
}

# --------------------------------------------------
# RDS MYSQL DATABASE INSTANCE
# --------------------------------------------------

resource "aws_db_instance" "mysql" {
  identifier = "${var.project_name}-${var.environment}-mysql"

  engine         = "mysql"
  engine_version = var.mysql_engine_version
  instance_class = var.db_instance_class

  db_name  = var.database_name
  username = var.db_username

  # RDS generates and manages the master password.
  # The password is stored in AWS Secrets Manager.
  manage_master_user_password = true

  # Encrypt the Secrets Manager secret using our KMS key.
  master_user_secret_kms_key_id = aws_kms_key.rds_secret.arn

  allocated_storage     = 20
  storage_type          = "gp3"
  max_allocated_storage = 100
  storage_encrypted     = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period    = 1
  auto_minor_version_upgrade = true

  deletion_protection = false
  skip_final_snapshot = true

  apply_immediately = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-mysql"
    Environment = var.environment
  }

  depends_on = [
    aws_kms_key.rds_secret
  ]
}
