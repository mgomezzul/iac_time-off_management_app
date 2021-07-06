resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  bucket_name = "${var.alb_name}-${random_id.suffix.dec}"
  security_groups = var.load_balancer_type == "network" ? [] : compact(concat(var.security_groups, [join("", aws_security_group.default.*.id)]),)
  subnets = var.subnet_ids
}

resource "aws_lb" "default" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = local.security_groups
  subnets            = local.subnets
  # access_logs {
  #   bucket  = module.s3_bucket_logs.id
  #   prefix  = var.alb_name
  #   enabled = var.enabled
  # }
  tags = var.tags
  # depends_on = [ 
  #   aws_s3_bucket_policy.default
  # ]
}

# module "s3_bucket_logs" {
#   source  = ""
#   bucket  = local.bucket_name
#   acl     = "private"
#   tags    = var.tags
#   enabled = false
#   policy  = join("", data.aws_iam_policy_document.default.*.json)
# }