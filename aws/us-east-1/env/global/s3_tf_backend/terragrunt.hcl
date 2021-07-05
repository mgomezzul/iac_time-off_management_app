# aws/us-east-1/env/global/s3_tf_backend/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../../../../terraform/modules//s3_tf_backend"
}

inputs = {
  name               = "tf-backend"
  attributes         = ["state"]
  additional_tag_map = {
    "stable" = true
  }
}