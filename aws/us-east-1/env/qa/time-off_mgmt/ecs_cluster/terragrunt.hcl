# aws/us-east-1/env/qa/time-off_mgmt/ecs_cluster/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../terraform/modules//ecs_cluster"
}

inputs = {
  enable_container_insights = true
  include_ssm_policy_instance_profile = true
  aws_ec2_instance_type = "t3a.small"
  asg_min_size = 2
  desired_capacity = 2
  asg_max_size = 2
  name       = "time-off_mgmt"
  attributes = ["ecs", "cluster"]
  additional_tag_map = {
    "Stable" = false
  }
  instance_refresh_settings = {
    strategy = "Rolling"
    preferences = {
      instance_warmup = 180
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
  vpc_id = "vpc-0abb219aa1eb0d385"
  subnet_ids = ["subnet-0c95b17ffd1b33171", "subnet-0a2abc8ccc0850bde"]
  source_security_group_id = "sg-0a2dc04f243b770cd"
  ecs_ec2_key_name = "gorillalogic-qa-timeoff-key-pair"

}