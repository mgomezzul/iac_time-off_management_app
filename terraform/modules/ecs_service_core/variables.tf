### Target group

variable "deregistration_delay" {
  description = ""
  default = 15
}

variable "healthy_threshold" {
  description = "Environment"
  default = 3
}

variable "unhealthy_threshold" {
  description = "Environment"
  default = 3
}

variable "interval" {
  description = ""
  default = 30
}

variable "timeout" {
  description = ""
  default = 10
}

variable "cluster_id" {
  description = "The ECS cluster ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for cluster deployment"
}

# variable "env" {
#   description = "Environment"
# }

variable "cloudwatch_log_group_name" {
  description = "Environment"
  default = ""
}

variable "aws_lb_arn" {
  description = "aws_lb_arn"
  type        = string
}

variable "certificate_arn" {
  description = ""
  default = ""
}

variable "ssl_policy" {
  description = ""
  default = ""
}

variable "task_definition_name" {
  description = "AWS ECS service name"
}

variable "service_name" {
  description = "AWS ECS service name"
}

# variable "tags" {
#   description = "AWS tags"
#   type        = map(string)
# }

variable "container_name" {
  description = "aws_lb_arn"
}

variable "container_port" {
  description = "aws_lb_arn"
}

variable "desired_count" {
  description = "aws_lb_arn"
}

variable "deployment_maximum_percent" {
  description = "aws_lb_arn"
}

variable "deployment_minimum_healthy_percent" {
  description = "aws_lb_arn"
}

variable "task_definition_filename" {
  description = "aws_lb_arn"
}

variable "execution_role_arn" {
  description = "execution role arn"
}

variable "task_role_arn" {
  description = "task_role_arn"
}

variable "healthcheck_path" {
  description = "aws_lb_arn"
  default = ""
}

variable "service_port" {
  description = "aws_lb_arn"
}

variable "service_protocol" {
  description = "aws_lb_arn"
}

variable "allowed_cidr_blocks" {
  description = "aws_lb_arn"
}

variable "security_groups" {
  description = ""
  default     = ""
}

variable "alb_security_group_id" {
  description = "Name of the bucket for terraform state"
  default     = ""
}

variable "alb_listener_protocol" {
  description = "Name of the bucket for terraform state"
  default     = ""
}

variable "alb_listener_port" {
  description = "ALB listener port"
  default     = ""
}

variable "deployment_controller_type" {
  description = ""
}

variable "add_container_sg_rules" {
  description = ""
  default = "yes"
}

variable "ecs_cluster_security_group_id" {
  description = ""
}

variable "volume_name" {
  description = ""
}

variable "volume_host_path" {
  description = ""
}

variable "attach_volume" {
  description = ""
}

variable "destination_arn" {
  description = ""
}

variable "role_arn" {
  description = ""
}

variable "retention_in_days" {
  description = ""
}

variable "number_of_services" {
  description = ""
  type        = number
  default     = 1
}

variable "load_balancer_type" {
  description = ""
  type        = string
  default     = "application"
}
