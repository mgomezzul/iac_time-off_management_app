resource "aws_lb_listener" "default" {
  load_balancer_arn = var.aws_lb_arn
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol
  ssl_policy        = var.load_balancer_type == "application" ? null : var.ssl_policy
  certificate_arn   = var.load_balancer_type == "application" ? null : var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}
