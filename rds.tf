# Banco gerenciado externo ao cluster. Postgres 16 para parear com o local.

# Senha master gerada pelo Terraform (sem TF_VAR manual — a esteira roda sozinha).
# Persistida no state (criptografado no S3) e exposta ao app somente via
# Secrets Manager (DATABASE_URL). special=false evita problemas de URL-encoding.
resource "random_password" "db" {
  length  = 24
  special = false
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db"
  subnet_ids = local.private_subnets
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds"
  description = "Permite acesso ao Postgres apenas a partir dos nodes do EKS"
  vpc_id      = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_eks" {
  security_group_id            = aws_security_group.rds.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.node_security_group_id
  description                  = "Postgres 5432 a partir do SG dos nodes EKS"
}

resource "aws_db_instance" "this" {
  identifier     = "${var.project_name}-db"
  engine         = "postgres"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  allocated_storage = var.db_allocated_storage
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db.result

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false

  multi_az                  = var.db_multi_az
  deletion_protection       = var.db_deletion_protection
  skip_final_snapshot       = var.db_skip_final_snapshot
  final_snapshot_identifier = var.db_skip_final_snapshot ? null : "${var.project_name}-db-final"
}
