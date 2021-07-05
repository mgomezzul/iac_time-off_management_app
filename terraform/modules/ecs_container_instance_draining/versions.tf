terraform {
  required_version = ">= 0.13.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "1.4.0"
    }
  }
}
