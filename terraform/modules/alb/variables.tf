variable "vpc_id" {
  description = ""
}

variable "alb_name" {
  description = "The name of the ALB"
}

variable "internal" {
  description = ""
}

variable "load_balancer_type" {
  description = ""
}

variable "security_groups" {
  description = ""
}

variable "subnet_ids" {
  description = ""
}

variable "bucket" {
  description = ""
  default     = ""
  type        = string
}

variable "prefix" {
  description = ""
  default     = ""
}

variable "enabled" {
  description = ""
  default     = true
  type        = bool
}

variable "tags" {
  description = ""
  type        = map(string)
}

variable "acl" {
  description = ""
  default     = ""
  type        = string
}