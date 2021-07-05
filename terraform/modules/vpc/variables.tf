variable "azs" {
    description = "value"
    type = list(string)  
}

variable "cidr" {
    description = "cidr block for vpc"
    type = string  
}

variable "enable_nat_gateway" {
    description = "nat gateway internet comunication"
    type = bool
    default = true
}

variable "private_subnets_cidr_block" {
    description = "cidr block for private subnets"
    type = list(string)
}

variable "public_subnets_cidr_block" {
    description = "cidr block for public subnets"
    type = list(string)
}

variable region {
  type        = string
  description = "AWS Region"
}

variable "manage_default_route_table" {
  description = "Should be true to manage default route table"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}