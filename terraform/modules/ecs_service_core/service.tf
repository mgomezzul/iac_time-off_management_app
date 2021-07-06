resource "aws_ecs_service" "default" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.default.arn

  load_balancer {
    target_group_arn = aws_lb_target_group.default.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  deployment_controller {
    type = var.deployment_controller_type
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

  desired_count                      = var.desired_count
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  tags = module.this.tags
}