data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

module "alb" {
  source             = "git@github.com:mgomezzul/iac_time-off_management_app.git//terraform/modules/alb?ref=module/aws/alb_0.1.0"
  vpc_id             = var.vpc_id
  alb_name           = module.this.id
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.alb_security_groups
  subnet_ids         = data.aws_subnet_ids.private.ids
  tags               = module.this.tags
}

locals {
  alb                = module.alb.arn
  services_ecs       = var.services_ecs
  ecs_ec2_cluster_sg = var.ecs_cluster_security_group_id
  ecs_cluster_name   = var.cluster_id
  #host_name          = element(var.aliases, 0)
}

module "acm_request_certificate" {
  source                            = "cloudposse/acm-request-certificate/aws"
  version                           = "0.13.1"
  count                             = length(local.services_ecs)
  domain_name                       = var.domain_name
  name                              = local.services_ecs[count.index].container_name
  process_domain_validation_options = true
  ttl                               = "300"
  zone_name                         = var.domain_name
  subject_alternative_names         = ["*.${var.domain_name}"]
}

module "route53_record" {
  source      = "cloudposse/route53-alias/aws"
  version     = "0.12.0"
  count           = length(local.services_ecs)
  aliases         = [local.services_ecs[count.index].container_name]
  parent_zone_id  = var.parent_zone_id
  target_dns_name = module.alb.dns_name
  target_zone_id  = module.alb.zone_id
  depends_on      = [module.alb]
}


module "ecs_service" {
  source                             = "git@github.com:mgomezzul/iac_time-off_management_app.git//terraform/modules/ecs_service_core?ref=module/aws/ecs_service_0.1.0"
  count                              = length(local.services_ecs)
  vpc_id                             = var.vpc_id
  # env                                = module.this.environment
  cluster_id                         = local.ecs_cluster_name
  aws_lb_arn                         = local.alb
  container_name                     = local.services_ecs[count.index].container_name
  container_port                     = local.services_ecs[count.index].container_ports
  desired_count                      = var.desired_count
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  service_name                       = "${module.this.environment}-${local.services_ecs[count.index].service_name}"
  task_definition_name               = "${module.this.environment}-${local.services_ecs[count.index].task_definition_name}"
  task_definition_filename           = "${module.this.environment}-${local.services_ecs[count.index].task_definition_filename}"
  healthcheck_path                   = local.services_ecs[count.index].health_check
  service_port                       = local.services_ecs[count.index].container_ports
  alb_listener_port                  = local.services_ecs[count.index].alb_listener_port
  service_protocol                   = local.services_ecs[count.index].service_protocol
  attach_volume                      = local.services_ecs[count.index].attach_volume
  volume_name                        = local.services_ecs[count.index].volume_name
  volume_host_path                   = local.services_ecs[count.index].volume_host_path
  execution_role_arn                 = local.services_ecs[count.index].execution_role_arn
  task_role_arn                      = local.services_ecs[count.index].task_role_arn
  cloudwatch_log_group_name          = "/${module.this.environment}/ecs_service/${local.services_ecs[count.index].container_name}"
  add_container_sg_rules             = var.add_container_sg_rules
  alb_security_group_id              = module.alb.default_security_group
  ecs_cluster_security_group_id      = local.ecs_ec2_cluster_sg
  alb_listener_protocol              = local.services_ecs[count.index].alb_listener_protocol
  allowed_cidr_blocks                = ["0.0.0.0/0"]
  deployment_controller_type         = var.deployment_controller_type
  depends_on                         = [module.alb]
  certificate_arn                    = module.acm_request_certificate[count.index].arn
  ssl_policy                         = "ELBSecurityPolicy-2016-08"
  destination_arn                    = var.log_subscription_destination_arn
  role_arn                           = var.log_subscription_role_arn
  tags                               = module.this.tags
  retention_in_days                  = var.retention_in_days
  number_of_services                 = count.index
}
