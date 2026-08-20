# Rede e SG dos nodes vêm do state do tc-infra-kubernetes (fonte única da VPC).
# Pré-requisito: o apply do tc-infra-kubernetes precisa ter rodado antes.
data "terraform_remote_state" "kubernetes" {
  backend = "s3"

  config = {
    bucket = "tc-fase3-tfstate-538880133939"
    key    = "infra-kubernetes/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  vpc_id                 = data.terraform_remote_state.kubernetes.outputs.vpc_id
  private_subnets        = data.terraform_remote_state.kubernetes.outputs.private_subnets
  node_security_group_id = data.terraform_remote_state.kubernetes.outputs.node_security_group_id
}
