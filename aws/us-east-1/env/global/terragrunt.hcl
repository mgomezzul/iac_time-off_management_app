# aws/us-east-1/env/global/terragrunt.hcl
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "gorillalogic-global-tf-backend-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "gorillalogic-global-tf-backend-lock-state"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region  = var.region
  allowed_account_ids = ["982337557829"]
  
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}
EOF
}

inputs = {
  accountId = "982337557829"
  # hosted_zone = "bcs.creditodigitalinteligente.com"
  namespace   = "gorilla_logic"
  environment = "global"
  region  = "us-east-1"
  tags = {
    maintainer       = "Mateo Gomez"
    iac_tool         = "terraform"
    iac_tool_verison = "0.14.4"
  }
}