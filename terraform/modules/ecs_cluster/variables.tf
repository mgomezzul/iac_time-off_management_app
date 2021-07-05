variable "create_ecs" {
  description = "Controls if ECS should be created"
  type        = bool
  default     = true
}

variable "capacity_providers" {
  description = "List of short names of one or more capacity providers to associate with the cluster. Valid values also include FARGATE and FARGATE_SPOT."
  type        = list(string)
  default     = []
}

variable "default_capacity_provider_strategy" {
  description = "The capacity provider strategy to use by default for the cluster. Can be one or more."
  type        = list(map(any))
  default     = []
}

variable "enable_container_insights" {
  description = "Controls if ECS Cluster has container insights enabled"
  type        = bool
  default     = false
}

variable "aws_region" {
  description = "Selected AWS region to deploy your Lambda Function"
  type        = string
  default     = "us-east-1"
}

variable "include_ssm_policy_instance_profile" {
  description = "Controls if SSM policy is added to the EC2 Instance profile"
  type        = bool
  default     = false
}

variable "aws_ec2_instance_type" {
  description = "AWS EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  type        = number
  description = "The number of EC2 instances that should be running in the group"
}

variable "asg_min_size" {
  type        = number
  description = "The minimum size of the autoscale group"
}

variable "asg_max_size" {
  type        = number
  description = "The maximum size of the autoscale group"
}

variable "instance_refresh_settings" {
  description = "The instance refresh definition"
  type = object({
    strategy = string
    preferences = object({
      instance_warmup        = number
      min_healthy_percentage = number
    })
    triggers = list(string)
  })

  default = null
}

variable "wait_for_capacity_timeout" {
  type        = string
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to '0' causes Terraform to skip all Capacity Waiting behavior"
  default     = "10m"
}

variable "managed_termination_protection" {
  description = "termination"
  type        = string
  default     = "DISABLED"
}

variable "instance_warmup_period" {
  description = "seconds"
  type        = number
  default     = null
}

variable "minimum_scaling_step_size" {
  description = "seconds"
  type        = number
  default     = null
}

variable "maximum_scaling_step_size" {
  description = "seconds"
  type        = number
  default     = null
}

variable "managed_scaling_status" {
  description = "status"
  type        = string
  default     = "DISABLED"
}

variable "target_capacity" {
  description = "number"
  type        = number
  default     = null
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = ""
}

variable "source_security_group_id" {
  description = "Security group id to allow access to/from, depending on the type. Cannot be specified with cidr_blocks, ipv6_cidr_blocks, or self"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Subnet ids list of inside vpc_id"
  type        = list(string)
  default     = []
}

variable "ecs_ec2_key_name" {
  description = "The name for the key pair"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}
