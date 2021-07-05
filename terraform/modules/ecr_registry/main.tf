module "ecr" {
  source = "cloudposse/ecr/aws"
  version     = "0.32.2"

  encryption_configuration = var.encryption_configuration

  context = module.this.context
}