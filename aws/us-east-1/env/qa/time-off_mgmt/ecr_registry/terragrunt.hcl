# aws/us-east-1/env/qa/time-off_mgmt/ecr_registry/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../terraform/modules//ecr_registry"
}

inputs = {
  name = "ecr-time-off-mgmt"

  encryption_configuration = {
    encryption_type = "AES256"
    kms_key         = null
  }

}

