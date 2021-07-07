module "ecr" {
  source = "cloudposse/ecr/aws"
  version     = "0.32.2"

  encryption_configuration = var.encryption_configuration
  image_tag_mutability = var.image_tag_mutability

  context = module.this.context
}