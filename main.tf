##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  env_prefix    = var.beanstalk_environment != "" ? var.beanstalk_environment : "${var.release_name}-${var.namespace}"
  rule_m_str    = "${var.custom_shared_rules == false ? jsonencode(var.rule_mappings) : "SHARED"}-${jsonencode(var.port_mappings)}"
  rule_name_sha = sha256(local.rule_m_str)
  all_tags = merge(var.extra_tags, {
    Environment = local.env_prefix
    Namespace   = var.namespace
    Release     = var.release_name
    managed-by  = "iac"
  })
}

data "aws_lb" "shared_lb" {
  count = var.load_balancer_shared ? 1 : 0
  name  = var.load_balancer_shared_name
}

data "aws_elastic_beanstalk_hosted_zone" "current" {}

resource "null_resource" "shared_lb_rules" {
  triggers = {
    rules_count   = "rules-${length(flatten(local.shared_lb_mappings))}-${length(flatten(local.shared_lb_rules))}"
    is_shared     = var.load_balancer_shared
    rule_name_sha = local.rule_name_sha
  }
}

resource "aws_elastic_beanstalk_environment" "beanstalk_environment" {
  name                   = local.env_prefix
  description            = "Managed by IAC - Do not modify out of Terraform"
  application            = data.aws_elastic_beanstalk_application.application.name
  cname_prefix           = var.load_balancer_alias != "" ? var.load_balancer_alias : "${var.release_name}-${var.namespace}-ingress"
  tier                   = "WebServer"
  version_label          = var.application_version_label
  solution_stack_name    = data.aws_elastic_beanstalk_solution_stack.solution_stack.name
  wait_for_ready_timeout = var.wait_for_ready_timeout
  #template_name = aws_elastic_beanstalk_configuration_template.beanstalk_environment.name

  dynamic "setting" {
    for_each = local.eb_settings_map
    content {
      name      = setting.value.name
      namespace = setting.value.namespace
      resource  = setting.value.resource
      value     = setting.value.value
    }
  }

  tags = local.all_tags

  lifecycle {
    create_before_destroy = false
    replace_triggered_by = [
      null_resource.shared_lb_rules.id
    ]
  }
}
