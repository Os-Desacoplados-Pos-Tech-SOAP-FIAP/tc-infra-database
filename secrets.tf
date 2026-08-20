# Credenciais consumidas pelo app (CD injeta como Secret k8s) e pela Lambda de auth.
# ATENÇÃO: valores ficam em texto plano no state — o backend S3 é criptografado e
# de acesso restrito; nunca versionar state local.

resource "random_password" "jwt_secret" {
  length  = 48
  special = false
}

resource "aws_secretsmanager_secret" "jwt_secret" {
  name                    = "${var.project_name}/JWT_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = random_password.jwt_secret.result
}

# DATABASE_URL no formato do Prisma. urlencode() protege contra chars reservados.
locals {
  database_url = "postgresql://${urlencode(var.db_username)}:${urlencode(random_password.db.result)}@${aws_db_instance.this.address}:${aws_db_instance.this.port}/${var.db_name}?schema=public"
}

resource "aws_secretsmanager_secret" "database_url" {
  name                    = "${var.project_name}/DATABASE_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "database_url" {
  secret_id     = aws_secretsmanager_secret.database_url.id
  secret_string = local.database_url
}
