locals {
  security_group_id        = var.load_balancer_type == "application" ? var.alb_security_group_id : var.ecs_cluster_security_group_id
  source_security_group_id = var.load_balancer_type == "application" ? var.alb_security_group_id : null
}

resource "aws_security_group_rule" "default" {
  description       = "allow_LB_${var.service_name}_traffic"
  type              = "ingress"
  from_port         = var.alb_listener_port
  to_port           = var.alb_listener_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = local.security_group_id 
}

# resource "aws_security_group_rule" "dynamicPorts" {
#   count                    = var.number_of_services == 1 ? 1 : 0
#   description              = "ECS Dynamic ports"
#   type                     = "ingress"
#   from_port                = 32768
#   to_port                  = 65535
#   protocol                 = "tcp"
#   # source_security_group_id = local.source_security_group_id
#   security_group_id        = local.security_group_id
# }