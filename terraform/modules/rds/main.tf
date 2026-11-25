
# --------------------------------------------------
# RDS DB SUBNET GROUP
# --------------------------------------------------

resource "aws_db_subnet_group" "main" {
  # Name of the DB subnet group
  name = "${var.project_name}-${var.environment}-db-subnet-group"

  # Use the existing private database subnets
  subnet_ids = var.private_db_subnet_ids

  # Add resource tags
  tags = {
    Name        = "${var.project_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# --------------------------------------------------
# RDS SECURITY GROUP
# --------------------------------------------------

resource "aws_security_group" "rds" {
  # Security group name
  name = "${var.project_name}-${var.environment}-rds-sg"

  # Security group description
  description = "Allow MySQL access from private application subnets"

  # Attach security group to existing VPC
  vpc_id = var.vpc_id

  # Allow MySQL traffic from application subnet CIDRs
  ingress {
    description = "MySQL access from private application subnets"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    # Only the specified private application CIDRs
    cidr_blocks = var.allowed_app_cidr_blocks
  }

  # Allow outbound traffic
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
  # Unique RDS instance identifier
  identifier = "${var.project_name}-${var.environment}-mysql"

  # Database engine and version
  engine         = "mysql"
  engine_version = var.mysql_engine_version

  # Small instance for development and learning
  instance_class = var.db_instance_class

  # Initial database name
  db_name = var.database_name

  # Database administrator username
  username = var.db_username

  # Password comes from a sensitive Terraform variable
  password = var.db_password

  # Allocate 20 GB of storage
  allocated_storage = 20

  # Use General Purpose SSD storage
  storage_type = "gp3"

  # Do not allow storage to shrink
  max_allocated_storage = 100

  # Encrypt database storage
  storage_encrypted = true

  # Use the private DB subnet group
  db_subnet_group_name = aws_db_subnet_group.main.name

  # Attach the RDS security group
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Disable public internet access
  publicly_accessible = false

  # Single-AZ deployment for development
  multi_az = false

  # Keep one day of automated backups
  backup_retention_period = 1

  # Automatically apply minor engine upgrades
  auto_minor_version_upgrade = true

  # Enable deletion for this development database
  deletion_protection = false

  # Skip final snapshot when destroying this development DB.
  # IMPORTANT: destroying the instance will permanently delete its data.
  skip_final_snapshot = true

  # Apply configuration changes immediately
  apply_immediately = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-mysql"
    Environment = var.environment
  }
}
