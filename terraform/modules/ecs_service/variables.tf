# Provider
variable "role_arn" {
  description = ""
  default     = ""
}

variable "session_name" {
  description = ""
  default     = ""
}

# VPC
variable "vpc_id" {
  description = ""
}

variable "region" {
  description = ""
}

# variable "env" {
#   description = ""
# }

# variable "tfstate_bucket" {
#   description = ""
# }

# ALB
variable "alb_name" {
  description = "The name of the ALB"
  default     = ""
}

variable "internal" {
  type = bool
  description = ""
  default     = false
}

variable "load_balancer_type" {
  description = ""
  default     = "network"
}

variable "alb_security_groups" {
  description = ""
  type        = list(string)
  default     = [""]
}

variable "alb_subnet_ids" {
  description = ""
  type        = list(string)
  default     = [""]
}

variable "domain_name" {
  description = ""
}

variable "alb_logs_bucket" {
  description = ""
  default     = ""
}

variable "logs_prefix" {
  description = ""
  default     = ""
}

variable "enabled_logging" {
  description = ""
  default     = false
}

variable "tid" {
  description = ""
  default     = ""
}

variable "tsid" {
  description = ""
  default     = ""
}

# Route53
variable "parent_zone_id" {
  description = ""
}

variable "aliases" {
  description = ""
  type        = list(string)
  default     = [""]
}

#Service
variable "services_ecs" {
  description = ""
  type = list(object({
    service_name                    = string
    task_definition_name            = string
    task_definition_filename        = string
    container_name                  = string
    container_ports                 = number
    execution_role_arn              = string
    task_role_arn                   = string
    alb_listener_port               = number
    service_protocol                = string
    alb_listener_protocol           = string
    health_check                    = string
    attach_volume                   = bool
    volume_name                     = string
    volume_host_path                = string
  }))
  default = []
}

variable "desired_count" {
  description = ""
}

variable "deployment_maximum_percent" {
  description = ""
}

variable "deployment_minimum_healthy_percent" {
  description = ""
}

variable "add_container_sg_rules" {
  description = ""
  default     = "yes"
}

variable "ecs_cluster_security_group_id" {
  description = ""
  default     = ""
}

variable "cluster_id" {
  description = ""
  default     = ""
}

variable "deployment_controller_type" {
  description = ""
  default     = "ECS"
}

variable "log_subscription_destination_arn" {
  description = ""
  default     = "ECS"
}

variable "log_subscription_role_arn" {
  description = ""
  default     = "ECS"
}

variable "retention_in_days" {
  type        = number
  description = ""
  default     = 30
}

variable "number_of_services" {
  description = ""
  type        = number
  default     = 1
}
