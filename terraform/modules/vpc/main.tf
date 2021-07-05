module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "v3.2.0"

  name = module.this.id
  tags = { for k, v in merge(module.this.tags, module.this.additional_tag_map) : k => v if ! contains(["Name"], k) }
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets_cidr_block
  public_subnets  = var.public_subnets_cidr_block

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  manage_default_route_table = var.manage_default_route_table
}


