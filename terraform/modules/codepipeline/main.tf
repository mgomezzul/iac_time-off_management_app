module "ecs_push_pipeline" {
  source = "cloudposse/ecs-codepipeline/aws"
  version = "0.27.0"
  
  name                  = "ecs-codepipeline"
  github_oauth_token    = "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"
  github_webhooks_token = "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"
  repo_owner            = "mgomezzul"
  repo_name             = "timeoff-management-application"
  branch                = "master"
  service_name          = "qa-time-off-svc"
  ecs_cluster_name      = "gorillalogic-qa-time-offmgmt-ecs-cluster"
  image_repo_name       = var.image_repo_name
  image_tag             = var.image_tag
  region                = var.region
  privileged_mode         = true
  webhook_enabled         = true
  # cache_type             = "LOCAL"
}