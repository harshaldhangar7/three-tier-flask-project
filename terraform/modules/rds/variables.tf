
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

variable "private_db_subnet_ids" {
  description = "Private database subnet IDs"
  type        = list(string)
}

variable "allowed_app_cidr_blocks" {
  description = "Private application subnet CIDRs allowed to connect to MySQL"
  type        = list(string)
}

variable "mysql_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0.46"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "database_name" {
  description = "Initial database name"
  type        = string
  default     = "student_db"
}

variable "db_username" {
  description = "RDS administrator username"
  type        = string
}

variable "db_password" {
  description = "RDS administrator password"
  type        = string
  sensitive   = true
}
