output "arn" {
  description = "The ID of the created ECS cluster."
  value       = aws_lb.default.id
}

output "default_security_group" {
  description = "default ALB SG"
  value       = join("", aws_security_group.default.*.id)
}

output "dns_name" {
  description = ""
  value       = aws_lb.default.dns_name
}

output "zone_id" {
  description = ""
  value       = aws_lb.default.zone_id
}