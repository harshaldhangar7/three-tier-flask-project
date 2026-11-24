
# Project name used in resource names and tags
variable "project_name" {
  description = "Name of the project"
  type        = string
}

# Deployment environment
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

# VPC IP address range
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Availability Zones
variable "availability_zones" {
  description = "Availability Zones used by the VPC"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Provide exactly two Availability Zones."
  }
}

# Public subnet IP ranges
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

# Private application subnet IP ranges
variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private application subnets"
  type        = list(string)
}

# Private database subnet IP ranges
variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private database subnets"
  type        = list(string)
}

# Use one NAT Gateway for development to reduce costs
variable "single_nat_gateway" {
  description = "Use one NAT Gateway instead of one per AZ"
  type        = bool
  default     = true
}
