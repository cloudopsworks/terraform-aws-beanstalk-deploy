##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
locals {
  sh_rule_mappings = {
    for rule in var.rule_mappings :
    rule.name => rule
    if var.load_balancer_shared && var.custom_shared_rules
  }
  sh_port_mappings = {
    for port in var.port_mappings :
    port.name => port
    if var.load_balancer_shared && var.custom_shared_rules
  }
}

data "aws_lb_listener" "lb_listener" {
  for_each          = local.sh_rule_mappings
  load_balancer_arn = data.aws_lb.shared_lb[0].arn
  port              = local.sh_port_mappings[each.value.process].from_port
}

# resource "random_string" "random" {
#   for_each = local.sh_rule_mappings
#   length   = 4
#   special  = false
#   upper    = false
#   keepers = {
#     envid            = aws_elastic_beanstalk_environment.beanstalk_environment.id
#     backend_protocol = local.sh_port_mappings[each.value.process].backend_protocol
#   }
# }

# resource "aws_lb_target_group" "lb_tg" {
#   depends_on = [
#     aws_elastic_beanstalk_environment.beanstalk_environment
#   ]
#   for_each = local.sh_rule_mappings
#   name     = "${aws_elastic_beanstalk_environment.beanstalk_environment.id}-${each.key}-${random_string.random[each.key].result}-tg"
#   port     = local.sh_port_mappings[each.value.process].to_port
#   protocol = local.sh_port_mappings[each.value.process].backend_protocol
#   vpc_id   = data.aws_lb.shared_lb[0].vpc_id
#   health_check {
#     enabled             = try(local.sh_port_mappings[each.value.process].health_check.enabled, true)
#     healthy_threshold   = try(local.sh_port_mappings[each.value.process].health_check.healthy_threshold, 2)
#     unhealthy_threshold = try(local.sh_port_mappings[each.value.process].health_check.unhealthy_threshold, 2)
#     timeout             = try(local.sh_port_mappings[each.value.process].health_check.timeout, 5)
#     interval            = try(local.sh_port_mappings[each.value.process].health_check.interval, 10)
#     path                = try(local.sh_port_mappings[each.value.process].health_check.path, "/")
#     port                = try(local.sh_port_mappings[each.value.process].health_check.port, "traffic-port")
#     protocol            = try(local.sh_port_mappings[each.value.process].health_check.protocol, local.sh_port_mappings[each.value.process].backend_protocol)
#     matcher             = try(local.sh_port_mappings[each.value.process].health_check.matcher, "200-302")
#   }
#   tags = merge(var.extra_tags, {
#     Environment = var.beanstalk_environment != "" ? var.beanstalk_environment : "${var.release_name}-${var.namespace}"
#     Namespace   = var.namespace
#     Release     = var.release_name
#   })
#   #   lifecycle {
#   #     create_before_destroy = true
#   #   }
# }
#
# resource "aws_autoscaling_attachment" "lb_tg_att" {
#   for_each               = local.sh_rule_mappings
#   autoscaling_group_name = aws_elastic_beanstalk_environment.beanstalk_environment.autoscaling_groups[0]
#   lb_target_group_arn    = aws_lb_target_group.lb_tg[each.key].arn
# }

data "aws_autoscaling_group" "app" {
  name = aws_elastic_beanstalk_environment.beanstalk_environment.autoscaling_groups[0]
}

locals {
  lb_tg_map = merge([
    for group_arn in data.aws_autoscaling_group.app.target_group_arns : {
      for key, port_mapping in local.sh_port_mappings : key => {
        arn = group_arn
      }
      if strcontains(group_arn, key)
    }
  ]...)
}

resource "null_resource" "lb_rule_keep" {
  for_each = local.sh_rule_mappings
  triggers = {
    target_group_arn = local.lb_tg_map[each.value.process].arn
  }
}

resource "aws_lb_listener_rule" "lb_listener_rule" {
  for_each     = local.sh_rule_mappings
  listener_arn = data.aws_lb_listener.lb_listener[each.key].arn
  priority     = each.value.priority
  action {
    type             = "forward"
    target_group_arn = local.lb_tg_map[each.value.process].arn
  }
  condition {
    host_header {
      values = toset(concat(split(",", each.value.host), [aws_elastic_beanstalk_environment.beanstalk_environment.cname]))
    }
    dynamic "path_pattern" {
      for_each = toset(length(try(each.value.path_patterns, [])) > 0 ? [1] : [])
      content {
        values = each.value.path_patterns
      }
    }
    dynamic "query_string" {
      for_each = toset(length(try(each.value.query_strings, [])) > 0 ? [1] : [])
      content {
        value = each.value.query_strings
      }
    }
    dynamic "http_header" {
      for_each = try(each.value.http_headers, [])
      content {
        http_header_name = http_header.value.name
        values           = http_header.value.values
      }
    }
    dynamic "source_ip" {
      for_each = toset(length(try(each.value.source_ips, [])) > 0 ? [1] : [])
      content {
        values = each.value.source_ips
      }
    }
  }
  tags = merge(var.extra_tags, {
    Name        = "Rule for ${aws_elastic_beanstalk_environment.beanstalk_environment.id} - ${each.value.process}"
    Environment = var.beanstalk_environment != "" ? var.beanstalk_environment : "${var.release_name}-${var.namespace}"
    Namespace   = var.namespace
    Release     = var.release_name
  })
  lifecycle {
    replace_triggered_by = [
      null_resource.lb_rule_keep[each.key]
    ]
  }
}