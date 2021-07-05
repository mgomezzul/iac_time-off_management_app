output "this_ecs_cluster_id" {
  description = "ID of the ECS Cluster"
  value       = module.ecs.this_ecs_cluster_id
}

output "this_ecs_cluster_arn" {
  description = "ARN of the ECS Cluster"
  value       = module.ecs.this_ecs_cluster_arn
}

output "this_ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs.this_ecs_cluster_name
}