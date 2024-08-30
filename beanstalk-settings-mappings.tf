##
# (c) 2021 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
locals {

  mappings_default_listeners = [
    for m in var.port_mappings :
    [
      {
        name      = "DefaultProcess"
        namespace = "aws:elbv2:listener:${m.name}"
        resource  = ""
        value     = m.name
      },
      {
        name      = "ListenerEnabled"
        namespace = "aws:elbv2:listener:${m.name}"
        resource  = ""
        value     = "true"
      },
      {
        name      = "Protocol"
        namespace = "aws:elbv2:listener:${m.name}"
        resource  = ""
        value     = try(m.protocol, "HTTP")
      },
      #      {
      #        name      = "Rules"
      #        namespace = "aws:elbv2:listener:${m.name}"
      #        resource  = ""
      #        value     = ""
      #      },
    ] if m.name == "default" && !var.load_balancer_shared
  ]

  mappings_port_listeners = [
    for m in var.port_mappings :
    [
      {
        name      = "DefaultProcess"
        namespace = "aws:elbv2:listener:${m.from_port}"
        resource  = ""
        value     = m.name
      },
      {
        name      = "ListenerEnabled"
        namespace = "aws:elbv2:listener:${m.from_port}"
        resource  = ""
        value     = "true"
      },
      {
        name      = "Protocol"
        namespace = "aws:elbv2:listener:${m.from_port}"
        resource  = ""
        value     = try(m.protocol, "HTTP")
      },
      #      {
      #        name      = "Rules"
      #        namespace = "aws:elbv2:listener:${m.from_port}"
      #        resource  = ""
      #        value     = ""
      #      },
    ] if m.name != "default" && !var.load_balancer_shared
  ]

  port_mappings_default = [
    for m in var.port_mappings :
    [
      {
        name      = "HealthCheckInterval"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.health_check.interval, "15")
      },
      {
        name      = "HealthCheckPath"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.health_check.path, "/")
      },
      {
        name      = "HealthCheckTimeout"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.health_check.timeout, "5")
      },
      {
        name      = "HealthyThresholdCount"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.health_check.healthy_threshold, "3")
      },
      {
        name      = "Port"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = tostring(m.to_port)
      },
      {
        name      = "Protocol"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.backend_protocol, "HTTP")
      },
      {
        name      = "MatcherHTTPCode"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.health_check.matcher, "200-302")
      },
      {
        name      = "StickinessEnabled"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.stickiness.enabled, "false")
      },
      {
        name      = "StickinessLBCookieDuration"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.stickiness.duration, "86400")
      },
      {
        name      = "StickinessType"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.stickiness.cookie, "lb_cookie")
      },
      {
        name      = "UnhealthyThresholdCount"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.health_check.unhealthy_threshold, "5")
      },
      {
        name      = "DeregistrationDelay"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.deregistration_delay, "20")
      }

    ] if m.name == "default"
  ]

  port_mappings_init = [
    for m in var.port_mappings :
    [
      {
        name      = "HealthCheckInterval"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.health_check.interval, "15")
      },
      {
        name      = "HealthCheckPath"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.health_check.path, "/")
      },
      {
        name      = "HealthCheckTimeout"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.health_check.timeout, "5")
      },
      {
        name      = "HealthyThresholdCount"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.health_check.healthy_threshold, "3")
      },
      {
        name      = "Port"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = tostring(m.to_port)
      },
      {
        name      = "Protocol"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.backend_protocol, "HTTP")
      },
      {
        name      = "MatcherHTTPCode"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.health_check.matcher, "200-302")
      },
      {
        name      = "StickinessEnabled"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.stickiness.enabled, "false")
      },
      {
        name      = "StickinessLBCookieDuration"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.stickiness.duration, "86400")
      },
      {
        name      = "StickinessType"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.stickiness.cookie, "lb_cookie")
      },
      {
        name      = "UnhealthyThresholdCount"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.health_check.unhealthy_threshold, "5")
      },
      {
        name      = "DeregistrationDelay"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = try(m.deregistration_delay, "20")
      }
    ] if m.name != "default"
  ]

  ssl_mappings_init = [
    for m in var.port_mappings :
    [
      {
        name      = "SSLPolicy"
        namespace = "aws:elbv2:listener:${m.from_port}"
        resource  = ""
        value     = var.load_balancer_ssl_policy
      },
      {
        name      = "SSLCertificateArns"
        namespace = "aws:elbv2:listener:${m.from_port}"
        resource  = ""
        value     = local.load_balancer_ssl_certificate_arn
      }
    ] if try(m.protocol, "HTTP") == "HTTPS" && !var.load_balancer_shared
  ]

  shared_lb_rules = [
    for m in var.port_mappings :
    [
      {
        name      = "Rules"
        namespace = "aws:elbv2:listener:${m.from_port}"
        resource  = ""
        value     = join(",", try(m.rules, []))
      },
    ] if var.load_balancer_shared && m.name != "default" && length(try(m.rules, [])) > 0 && var.custom_shared_rules == false
  ]

  shared_lb_mappings = [
    for r in var.rule_mappings :
    [
      {
        name      = "HostHeaders"
        namespace = "aws:elbv2:listenerrule:${r.name}"
        resource  = ""
        value     = r.host #join(",", [r.host, "${var.load_balancer_alias}.${var.region}.elasticbeanstalk.com"])
      },
      {
        name      = "PathPatterns"
        namespace = "aws:elbv2:listenerrule:${r.name}"
        resource  = ""
        value     = r.path
      },
      {
        name      = "Priority"
        namespace = "aws:elbv2:listenerrule:${r.name}"
        resource  = ""
        value     = tostring(r.priority)
      },
      {
        name      = "Process"
        namespace = "aws:elbv2:listenerrule:${r.name}"
        resource  = ""
        value     = r.process
      },
    ] if var.custom_shared_rules == false
  ]

  ssl_mappings = flatten(local.ssl_mappings_init)
  port_mappings_local = flatten(concat(local.port_mappings_default, local.port_mappings_init,
    local.mappings_default_listeners, local.mappings_port_listeners, local.shared_lb_rules,
  local.shared_lb_mappings))
}