
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
}

variable "availability_zones" {
  description = "AWS Availability Zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "Private application subnet CIDRs"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "Private database subnet CIDRs"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Use one NAT Gateway for development"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "Your public IP in CIDR format, for example 203.0.113.10/32"
  type        = list(string)
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "studentadmin"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}