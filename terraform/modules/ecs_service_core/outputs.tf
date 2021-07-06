output "listener_arn" {
  description = "arn of the deployed listener"
  value       = aws_lb_listener.default.arn
}