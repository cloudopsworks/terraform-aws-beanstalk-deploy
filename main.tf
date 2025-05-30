##
# (c) 2021-2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
locals {
  default_solution = "java"
  solutions = {
    java         = "^64bit Amazon Linux 2023 (.*) running Corretto 21(.*)$"
    java8        = "^64bit Amazon Linux 2 (.*) running Corretto 8(.*)$"
    java11       = "^64bit Amazon Linux 2 (.*) running Corretto 11(.*)$"
    java17       = "^64bit Amazon Linux 2 (.*) running Corretto 17(.*)$"
    tomcat       = "^64bit Amazon Linux 2023 (.*) Tomcat (.*) Corretto 21(.*)$"
    java17_23    = "^64bit Amazon Linux 2023 (.*) running Corretto 17(.*)$"
    tomcatj8     = "^64bit Amazon Linux 2 (.*) Tomcat (.*) Corretto 8(.*)$"
    tomcatj11    = "^64bit Amazon Linux 2 (.*) Tomcat (.*) Corretto 11(.*)$"
    tomcatj17    = "^64bit Amazon Linux 2023 (.*) Tomcat (.*) Corretto 17(.*)$"
    node         = "^64bit Amazon Linux 2023 (.*) Node.js 20(.*)$"
    node22       = "^64bit Amazon Linux 2023 (.*) Node.js 22(.*)$"
    node14       = "^64bit Amazon Linux 2 (.*) Node.js 14(.*)$"
    node16       = "^64bit Amazon Linux 2 (.*) Node.js 16(.*)$"
    node18       = "^64bit Amazon Linux 2 (.*) Node.js 18(.*)$"
    node18_23    = "^64bit Amazon Linux 2023 (.*) Node.js 18(.*)$"
    go           = "^64bit Amazon Linux 2023 (.*) running Go (.*)$"
    go_al2       = "^64bit Amazon Linux 2 (.*) running Go (.*)$"
    docker       = "^64bit Amazon Linux 2 (.*) running Docker (.*)$"
    docker-m     = "^64bit Amazon Linux 2 (.*) Multi-container Docker (.*)$"
    dotnet-core  = "^64bit Amazon Linux 2 (.*) running .NET Core(.*)$"
    dotnet-6     = "^64bit Amazon Linux 2023 (.*) running .NET 6(.*)$"
    dotnet-8     = "^64bit Amazon Linux 2023 (.*) running .NET 8(.*)$"
    dotnet-9     = "^64bit Amazon Linux 2023 (.*) running .NET 9(.*)$"
    dotnet       = "^64bit Amazon Linux 2023 (.*) running .NET 9(.*)$"
    python       = "^64bit Amazon Linux 2023 (.*) running Python 3.13(.*)$"
    python313    = "^64bit Amazon Linux 2023 (.*) running Python 3.13(.*)$"
    python312    = "^64bit Amazon Linux 2023 (.*) running Python 3.12(.*)$"
    python311    = "^64bit Amazon Linux 2023 (.*) running Python 3.11(.*)$"
    python39     = "^64bit Amazon Linux 2023 (.*) running Python 3.9(.*)$"
    python38     = "^64bit Amazon Linux 2 (.*) running Python 3.8(.*)$"
    python37     = "^64bit Amazon Linux 2 (.*) running Python 3.7(.*)$"
    net-core-w16 = "^64bit Windows Server Core 2016 (.*) running IIS (.*)$"
    net-core-w19 = "^64bit Windows Server Core 2019 (.*) running IIS (.*)$"
    net-core-w22 = "^64bit Windows Server Core 2022 (.*) running IIS (.*)$"
    net-core-w25 = "^64bit Windows Server Core 2025 (.*) running IIS (.*)$"
    dotnet-w16   = "^64bit Windows Server 2016 (.*) running IIS (.*)$"
    dotnet-w19   = "^64bit Windows Server 2019 (.*) running IIS (.*)$"
    dotnet-w22   = "^64bit Windows Server 2022 (.*) running IIS (.*)$"
    dotnet-w25   = "^64bit Windows Server 2025 (.*) running IIS (.*)$"
  }

  lookup_solution   = lookup(local.solutions, var.solution_stack, "")
  selected_solution = local.lookup_solution == "" ? (var.solution_stack == "" ? local.default_solution : var.solution_stack) : local.lookup_solution
  rule_m_str        = "${var.custom_shared_rules == false ? jsonencode(var.rule_mappings) : "SHARED"}-${jsonencode(var.port_mappings)}"
  rule_name_sha     = sha256(local.rule_m_str)
}

data "aws_elastic_beanstalk_solution_stack" "solution_stack" {
  most_recent = true
  name_regex  = local.selected_solution
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
  name                   = var.beanstalk_environment != "" ? var.beanstalk_environment : "${var.release_name}-${var.namespace}"
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

  tags = merge(var.extra_tags, {
    Environment = var.beanstalk_environment != "" ? var.beanstalk_environment : "${var.release_name}-${var.namespace}"
    Namespace   = var.namespace
    Release     = var.release_name
  })

  lifecycle {
    create_before_destroy = false
    replace_triggered_by = [
      null_resource.shared_lb_rules.id
    ]
  }
}
