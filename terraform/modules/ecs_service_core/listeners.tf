resource "aws_lb_listener" "default" {
  load_balancer_arn = var.aws_lb_arn
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol
  ssl_policy        = var.load_balancer_type == "application" && var.certificate_arn == null ? null : var.ssl_policy
  certificate_arn   = var.certificate_arn == null ? null : var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

resource "aws_lb_listener" "redirect" {
  count = var.alb_listener_protocol == "HTTPS" && var.alb_listener_port == 443  ? 1 : 0
  load_balancer_arn = var.aws_lb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
