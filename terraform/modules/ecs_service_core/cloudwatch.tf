resource "aws_cloudwatch_log_group" "default" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = var.retention_in_days
  tags = module.this.tags
}
