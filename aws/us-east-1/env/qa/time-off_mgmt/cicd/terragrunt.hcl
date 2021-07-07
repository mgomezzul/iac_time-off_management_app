# aws/us-east-1/env/qa/time-off_mgmt/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../terraform/modules//codepipeline"
}

inputs = {
  image_repo_name       = "gorillalogic-qa-ecr-time-off-mgmt"
  image_tag             = "latest"
}

