output "rds_endpoint" {
  description = "Endpoint (host:porta) da instância RDS Postgres."
  value       = aws_db_instance.this.endpoint
}

output "database_url_secret_name" {
  description = "Nome do secret DATABASE_URL no Secrets Manager (consumido pelo CD do app e pela Lambda)."
  value       = aws_secretsmanager_secret.database_url.name
}

output "jwt_secret_name" {
  description = "Nome do secret JWT_SECRET no Secrets Manager (consumido pelo CD do app e pela Lambda)."
  value       = aws_secretsmanager_secret.jwt_secret.name
}

output "rds_security_group_id" {
  description = "SG do RDS (a Lambda de auth adiciona regra de ingress a partir dele)."
  value       = aws_security_group.rds.id
}
