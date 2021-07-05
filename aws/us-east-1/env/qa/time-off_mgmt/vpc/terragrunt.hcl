# aws/us-east-1/env/qa/time-off_mgmt/vpc/terragrunt.hcl

include {
  path = find_in_parent_folders()
}

terraform {
    source = "../../../../../../terraform/modules//vpc"
}

inputs = {
    cidr                       = "10.100.0.0/16"
    public_subnets_cidr_block  = ["10.100.0.0/24", "10.100.1.0/24"]
    private_subnets_cidr_block = ["10.100.100.0/24","10.100.101.0/24"]
    azs                        = ["us-east-1a","us-east-1b"]
    enable_nat_gateway         = true
    single_nat_gateway         = true
    name                       = "time-off_mgmt"
}