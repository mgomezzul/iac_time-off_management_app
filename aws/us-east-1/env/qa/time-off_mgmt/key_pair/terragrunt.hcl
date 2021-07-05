# aws/us-east-1/env/qa/time-off_mgmt/key_pair/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../terraform/modules//key_pair"
}

inputs = {
  name                = "timeoff"
  attributes         = ["key-pair"]
  additional_tag_map = {
    "stable" = true
  }
  ssh_public_key_path = "/tmp/secrets"
  generate_ssh_key    = true
}