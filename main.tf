##
# (c) 2021 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
locals {
  default_solution = "java"
  solutions = {
    java         = "^64bit Amazon Linux 2 (.*) running Corretto 8(.*)$"
    java11       = "^64bit Amazon Linux 2 (.*) running Corretto 11(.*)$"
    java17       = "^64bit Amazon Linux 2 (.*) running Corretto 17(.*)$"
    tomcatj8     = "^64bit Amazon Linux 2 (.*) Tomcat (.*) Corretto 8(.*)$"
    tomcatj11    = "^64bit Amazon Linux 2 (.*) Tomcat (.*) Corretto 11(.*)$"
    node         = "^64bit Amazon Linux 2 (.*) Node.js 12(.*)$"
    node14       = "^64bit Amazon Linux 2 (.*) Node.js 14(.*)$"
    node16       = "^64bit Amazon Linux 2 (.*) Node.js 16(.*)$"
    node18       = "^64bit Amazon Linux 2 (.*) Node.js 18(.*)$"
    go           = "^64bit Amazon Linux 2 (.*) running Go (.*)$"
    docker       = "^64bit Amazon Linux 2 (.*) running Docker (.*)$"
    docker-m     = "^64bit Amazon Linux 2 (.*) Multi-container Docker (.*)$"
    net-core     = "^64bit Amazon Linux 2 (.*) running .NET Core(.*)$"
    python38     = "^64bit Amazon Linux 2 (.*) running Python 3.8(.*)$"
    python37     = "^64bit Amazon Linux 2 (.*) running Python 3.7(.*)$"
    net-core-w16 = "^64bit Windows Server Core 2016 (.*) running IIS (.*)$"
    net-iis-w12  = "^64bit Windows Server 2012 R2 (.*) running IIS (.*)$"
    net-core-w12 = "^64bit Windows Server Core 2012 R2 (.*) running IIS (.*)$"
  }

  lookup_solution   = lookup(local.solutions, var.solution_stack, "")
  selected_solution = local.lookup_solution == "" ? (var.solution_stack == "" ? local.default_solution : var.solution_stack) : local.lookup_solution

  mapping_list = [
    for m in var.rule_mappings :
    join("-", m.host)
  ]

  rule_m_list = [
    for m in var.port_mappings :
    join("-", m.rules)
    if var.load_balancer_shared && m.name != "default" && length(m.rules) > 0
  ]

  rule_name_sha = sha256(join("-", local.rule_m_list) + join("-", local.mapping_list))
}

data "aws_elastic_beanstalk_solution_stack" "solution_stack" {
  most_recent = true

  name_regex = local.selected_solution
}

data "aws_lb" "shared_lb" {
  count = var.load_balancer_shared ? 1 : 0

  name = var.load_balancer_shared_name
}

data "aws_elastic_beanstalk_hosted_zone" "current" {}

resource "aws_elastic_beanstalk_configuration_template" "beanstalk_environment" {
  name                = var.beanstalk_environment != "" ? "${var.beanstalk_environment}-config" : "${var.release_name}-${var.namespace}-config"
  application         = data.aws_elastic_beanstalk_application.application.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.solution_stack.name

  dynamic "setting" {
    for_each = local.eb_settings_map
    content {
      name      = setting.value.name
      namespace = setting.value.namespace
      resource  = setting.value.resource
      value     = setting.value.value
    }
  }
}

resource "null_resource" "shared_lb_rules" {
  triggers = {
    rules_count   = "rules-${length(flatten(local.shared_lb_mappings))}-${length(flatten(local.shared_lb_rules))}"
    is_shared     = var.load_balancer_shared
    rule_name_sha = local.rule_name_sha
  }
}

resource "aws_elastic_beanstalk_environment" "beanstalk_environment" {
  name                = var.beanstalk_environment != "" ? var.beanstalk_environment : "${var.release_name}-${var.namespace}"
  application         = data.aws_elastic_beanstalk_application.application.name
  cname_prefix        = var.load_balancer_alias != "" ? var.load_balancer_alias : "${var.release_name}-${var.namespace}-ingress"
  tier                = "WebServer"
  version_label       = var.application_version_label
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.solution_stack.name
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

  tags = merge(var.extra_tags, {
    Environment = var.beanstalk_environment != "" ? var.beanstalk_environment : "${var.release_name}-${var.namespace}"
    Namespace   = var.namespace
    Release     = var.release_name
  })

  lifecycle {
    #create_before_destroy = true
    replace_triggered_by = [
      null_resource.shared_lb_rules.id
    ]
  }
}
