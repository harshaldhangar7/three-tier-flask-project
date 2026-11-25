variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.37"
}

variable "private_subnet_ids" {
  description = "Private application subnet IDs for EKS worker nodes"
  type        = list(string)
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "Public IP ranges allowed to access the Kubernetes API"
  type        = list(string)
}