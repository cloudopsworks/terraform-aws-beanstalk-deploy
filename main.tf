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
}

data "aws_elastic_beanstalk_solution_stack" "solution_stack" {
  most_recent = true

  name_regex = local.selected_solution
}

resource "aws_elastic_beanstalk_environment" "beanstalk_environment" {
  name                = var.beanstalk_environment != "" ? var.beanstalk_environment : "${var.release_name}-${var.namespace}"
  application         = data.aws_elastic_beanstalk_application.application.name
  cname_prefix        = var.load_balancer_alias != "" ? var.load_balancer_alias : "${var.release_name}-${var.namespace}-ingress"
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.solution_stack.name
  tier                = "WebServer"
  version_label       = var.application_version_label

  dynamic "setting" {
    for_each = local.eb_settings
    content {
      name      = setting.value.name
      namespace = setting.value.namespace
      resource  = setting.value.resource
      value     = setting.value.value
    }
  }
}
