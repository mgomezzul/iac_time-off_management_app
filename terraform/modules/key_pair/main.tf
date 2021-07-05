module "aws_key_pair" {
  source = "cloudposse/key-pair/aws"
  version     = "0.18.0"

  ssh_public_key_path = var.ssh_public_key_path
  generate_ssh_key    = var.generate_ssh_key

  context = module.this.context
}