resource "aws_lb_target_group" "default" {
  name                 = var.task_definition_name
  protocol             = var.service_protocol
  port                 = 80
  target_type          = "instance"
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay

  dynamic "health_check" {
    for_each = var.load_balancer_type == "application" ? [1] : []
    content {
      path                = var.healthcheck_path
      matcher             = "200"
      healthy_threshold   = var.healthy_threshold
      unhealthy_threshold = var.unhealthy_threshold
      interval            = var.interval
      timeout             = var.timeout
      port                = "traffic-port"
      protocol            = var.service_protocol
    }
  }
  tags = module.this.tags
}
