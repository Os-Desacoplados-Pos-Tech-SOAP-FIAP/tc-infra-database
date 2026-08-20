variable "aws_region" {
  description = "Região AWS onde a stack é provisionada."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente lógico (usado em tags e nomes)."
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Prefixo dos recursos (mantém o padrão de nomes da fase 2)."
  type        = string
  default     = "oficina-mecanica"
}

variable "db_name" {
  description = "Nome do banco de dados inicial criado no RDS."
  type        = string
  default     = "oficina"
}

variable "db_username" {
  description = "Usuário master do RDS."
  type        = string
  default     = "oficina"
}

variable "db_instance_class" {
  description = "Classe da instância RDS."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Armazenamento alocado (GB) para o RDS."
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "Versão do PostgreSQL no RDS."
  type        = string
  default     = "16"
}

# Defaults sandbox-friendly (destroy simples). Em produção real: multi_az e
# deletion_protection habilitados, skip_final_snapshot desabilitado.
variable "db_multi_az" {
  description = "Habilita Multi-AZ no RDS."
  type        = bool
  default     = false
}

variable "db_deletion_protection" {
  description = "Habilita proteção contra exclusão do RDS."
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  description = "Pula o snapshot final ao destruir o RDS."
  type        = bool
  default     = true
}
