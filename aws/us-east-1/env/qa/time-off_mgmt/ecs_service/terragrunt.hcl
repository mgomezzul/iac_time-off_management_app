# aws/us-east-1/env/qa/time-off_mgmt/ecs_service/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../terraform/modules//ecs_service"
}

inputs = {
  vpc_id           = "vpc-0abb219aa1eb0d385"
  cluster_id       = "arn:aws:ecs:us-east-1:982337557829:cluster/gorillalogic-qa-time-offmgmt-ecs-cluster"

  # # Route53 record
  parent_zone_id = "Z03649342S3MG7D2OSN5W"
  domain_name    = "mgz-devops.tk"
  load_balancer_type = "application"
  alb_security_groups = ["sg-0a2dc04f243b770cd"]

  # Service
  services_ecs = [
    {
      service_name                    = "time-off-svc"
      task_definition_name            = "time-off-td"
      task_definition_filename        = "time-off.json"
      container_name                  = "time-off"
      container_ports                 = 3000
      execution_role_arn              = ""
      task_role_arn                   = ""
      alb_listener_port               = 443
      service_protocol                = "HTTP"
      alb_listener_protocol           = "HTTPS"
      health_check                    = "/login"
      attach_volume                   = false
      volume_name                     = ""
      volume_host_path                = ""
    }
  ]
  desired_count                      = 2
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}