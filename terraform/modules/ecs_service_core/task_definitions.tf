resource "aws_ecs_task_definition" "default" {
  family                = var.task_definition_name
  network_mode          = "bridge"
  container_definitions = file("task-definitions/${var.task_definition_filename}")
  execution_role_arn    = var.execution_role_arn
  task_role_arn = var.task_role_arn

  dynamic "volume" {
    for_each = var.attach_volume ? [1] : []
    content {
      name      = var.volume_name
      host_path = var.volume_host_path
    }
  }
  tags = module.this.tags
}