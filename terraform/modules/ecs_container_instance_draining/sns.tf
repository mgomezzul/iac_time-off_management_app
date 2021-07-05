#tfsec:ignore:AWS016
resource "aws_sns_topic" "topic" {
  name = format("%s-topic", substr(var.autoscaling_group_name, 1, 32))
  tags = var.tags
}
