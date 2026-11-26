# RDS endpoint (hostname and port)
output "db_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.mysql.endpoint
}

# RDS hostname only
output "db_hostname" {
  description = "RDS database hostname"
  value       = aws_db_instance.mysql.address
}

# RDS port
output "db_port" {
  description = "RDS database port"
  value       = aws_db_instance.mysql.port
}

# Database name
output "db_name" {
  description = "Initial database name"
  value       = aws_db_instance.mysql.db_name
}

# RDS security group ID
output "db_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}

# RDS master password secret ARN from Secrets Manager
output "master_secret_arn" {
  description = "Secrets Manager ARN containing the RDS master credentials"
  value       = aws_db_instance.mysql.master_user_secret[0].secret_arn
}

# KMS key ARN used to encrypt the RDS master password secret
output "kms_key_arn" {
  description = "KMS key ARN used to encrypt the RDS master secret"
  value       = aws_kms_key.rds_secret.arn
}
