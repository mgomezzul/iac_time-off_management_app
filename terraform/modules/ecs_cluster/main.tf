locals {
  ecs_cluster_name = module.this.id
}

resource "null_resource" "remove_ecs_cluster" {

  # Temporal way to use external variables into the local-exec provisioner block
  triggers = {
    ecs_cluster_name = local.ecs_cluster_name
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<CMD

      # Get the list of capacity providers associated with this cluster
      CAP_PROVS="$(aws ecs describe-clusters --clusters "${self.triggers.ecs_cluster_name}" \
        --query 'clusters[*].capacityProviders[*]' --output text)"

      # Now get the list of autoscaling groups from those capacity providers
      ASG_ARNS="$(aws ecs describe-capacity-providers \
        --capacity-providers "$CAP_PROVS" \
        --query 'capacityProviders[*].autoScalingGroupProvider.autoScalingGroupArn' \
        --output text)"

      if [ -n "$ASG_ARNS" ] && [ "$ASG_ARNS" != "None" ]
      then
        for ASG_ARN in $ASG_ARNS
        do
          ASG_NAME=$(echo $ASG_ARN | cut -d/ -f2-)

          # Set the autoscaling group size to zero
          aws autoscaling update-auto-scaling-group \
            --auto-scaling-group-name "$ASG_NAME" \
            --min-size 0 --max-size 0 --desired-capacity 0

          # Remove scale-in protection from all instances in the asg
          INSTANCES="$(aws autoscaling describe-auto-scaling-groups \
            --auto-scaling-group-names "$ASG_NAME" \
            --query 'AutoScalingGroups[*].Instances[*].InstanceId' \
            --output text)"
          aws autoscaling set-instance-protection --instance-ids $INSTANCES \
            --auto-scaling-group-name "$ASG_NAME" \
            --no-protected-from-scale-in
        done
      fi

      sleep 10
CMD
  }
  depends_on = [
    module.ecs
  ]
}
module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  version = "2.8.0"

  create_ecs = module.this.enabled
  name = module.this.id
  tags = module.this.tags

  container_insights = var.enable_container_insights
  capacity_providers = [module.this.id]
  default_capacity_provider_strategy = var.default_capacity_provider_strategy

  depends_on = [
  
    aws_ecs_capacity_provider.capacity_provider
  ]

}

# # For now we only use the AWS ECS optimized AMI
# # <https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html>
data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

module "ec2_ecs_instance_profile" {
  source  = "terraform-aws-modules/ecs/aws//modules/ecs-instance-profile"
  version = "2.8.0"
  name    = module.this.id
  include_ssm = var.include_ssm_policy_instance_profile
  tags = module.this.tags
}

module "security_groups_ecs_cluster_nodes" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name        = module.this.id
  description = "Security group for ECS Cluster Nodes (EC2)"
  vpc_id      = var.vpc_id

  # Open for security group id (rule or from_port+to_port+protocol+description)
  ingress_with_source_security_group_id = [
    {
      from_port                = 32768
      to_port                  = 65535
      protocol                 = -1
      description              = "Allow Ephemeral Ports range"
      source_security_group_id = var.source_security_group_id
    }
  ]
  # Open to CIDRs blocks (rule or from_port+to_port+protocol+description)
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Allow all the egress traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

## Shoud we create the Key KMS?
module "autoscaling_group" {
  source = "cloudposse/ec2-autoscale-group/aws"
  version = "0.25.0"

  context = module.this.context

  image_id                    = data.aws_ami.amazon_linux_ecs.image_id
  instance_type               = var.aws_ec2_instance_type
  security_group_ids          = [ module.security_groups_ecs_cluster_nodes.this_security_group_id ]
  subnet_ids                  = var.subnet_ids
  key_name                    = var.ecs_ec2_key_name
  iam_instance_profile_name   = module.ec2_ecs_instance_profile.this_iam_instance_profile_id
  health_check_type           = "EC2"
  min_size                    = var.asg_min_size
  desired_capacity            = var.desired_capacity
  max_size                    = var.asg_max_size
  wait_for_capacity_timeout   = "5m"
  associate_public_ip_address = false
  user_data_base64            = base64encode(data.template_file.user_data.rendered)
  instance_refresh            = var.instance_refresh_settings
  tags = module.this.tags

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = "true"
  cpu_utilization_high_threshold_percent = "70"
  cpu_utilization_low_threshold_percent  = "20"
}

resource "aws_ecs_capacity_provider" "capacity_provider" {

  name = module.this.id
  tags = module.this.tags

  auto_scaling_group_provider {
    auto_scaling_group_arn         = module.autoscaling_group.autoscaling_group_arn
    # OJO!
    managed_termination_protection = var.managed_termination_protection
    managed_scaling {
      instance_warmup_period    = var.instance_warmup_period
      minimum_scaling_step_size = var.minimum_scaling_step_size
      maximum_scaling_step_size = var.maximum_scaling_step_size
      status                    = var.managed_scaling_status
      target_capacity           = var.target_capacity
    }
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    cluster_name = module.this.id
  }
}

resource "aws_autoscaling_schedule" "night" {
  scheduled_action_name = "night"
  min_size = 0
  desired_capacity = 0
  max_size = 0
  recurrence = "00 02 * * 1-5" #Mon-Fri at 9PM COL
  autoscaling_group_name = module.autoscaling_group.autoscaling_group_name
}
resource "aws_autoscaling_schedule" "morning" {
  scheduled_action_name = "morning"
  min_size = var.asg_min_size
  desired_capacity = var.desired_capacity
  max_size = var.asg_max_size
  recurrence = "00 11 * * 1-5" #Mon-Fri at 6AM COL
  autoscaling_group_name = module.autoscaling_group.autoscaling_group_name
}

module "container-instance-draining" {
  source  = "git@github.com:mgomezzul/iac_time-off_management_app.git//terraform/modules/ecs_container_instance_draining?ref=module/aws/ecs_container_instance_draining_0.1.0"

  autoscaling_group_name = module.autoscaling_group.autoscaling_group_name
  autoscaling_group_arn  = module.autoscaling_group.autoscaling_group_arn
  ecs_cluster_name       = module.ecs.this_ecs_cluster_name
  ecs_cluster_arn        = module.ecs.this_ecs_cluster_arn

  region                 = var.aws_region
  tags                   = module.this.tags
}