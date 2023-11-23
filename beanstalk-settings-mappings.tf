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
        value     = m.protocol
      },
      {
        name      = "Rules"
        namespace = "aws:elbv2:listener:${m.name}"
        resource  = ""
        value     = ""
      },
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
        value     = m.protocol
      },
      {
        name      = "Rules"
        namespace = "aws:elbv2:listener:${m.from_port}"
        resource  = ""
        value     = ""
      },
    ] if m.name != "default" && !var.load_balancer_shared
  ]

  port_mappings_default = [
    for m in var.port_mappings :
    [
      {
        name      = "HealthCheckInterval"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "15"
      },
      {
        name      = "HealthCheckPath"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "/"
      },
      {
        name      = "HealthCheckTimeout"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "5"
      },
      {
        name      = "HealthyThresholdCount"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "3"
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
        value     = m.backend_protocol
      },
      {
        name      = "MatcherHTTPCode"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = m.health_http_status
      },
      {
        name      = "StickinessEnabled"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "false"
      },
      {
        name      = "StickinessLBCookieDuration"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "86400"
      },
      {
        name      = "StickinessType"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = m.stickiness_cookie
      },
      {
        name      = "UnhealthyThresholdCount"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "5"
      },
      {
        name      = "DeregistrationDelay"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "20"
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
        value     = "15"
      },
      {
        name      = "HealthCheckPath"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "/"
      },
      {
        name      = "HealthCheckTimeout"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "5"
      },
      {
        name      = "HealthyThresholdCount"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "3"
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
        value     = m.backend_protocol
      },
      {
        name      = "MatcherHTTPCode"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = m.health_http_status
      },
      {
        name      = "StickinessEnabled"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "false"
      },
      {
        name      = "StickinessLBCookieDuration"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "86400"
      },
      {
        name      = "StickinessType"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = m.stickiness_cookie
      },
      {
        name      = "UnhealthyThresholdCount"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "5"
      },
      {
        name      = "DeregistrationDelay"
        namespace = "aws:elasticbeanstalk:environment:process:${m.name}"
        resource  = ""
        value     = "20"
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
    ] if m.protocol == "HTTPS" && !var.load_balancer_shared
  ]

  shared_lb_rules = [
    for m in var.port_mappings :
    [
      {
        name      = "Rules"
        namespace = "aws:elbv2:listener:${m.from_port}"
        resource  = ""
        value     = length(m.rules) > 0 ? join(",", m.rules) : ""
      },
    ] if var.load_balancer_shared && m.name != "default"
  ]
  shared_lb_mappings = [
    for r in var.rule_mappings :
    [
      {
        name      = "HostHeaders"
        namespace = "aws:elbv2:listenerrule:${r.name}"
        resource  = ""
        value     = load_balancer_alias(",", [r.host , "${var.load_balancer_alias}.${var.region}.elasticbeanstalk.com"])
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
        value     = var.load_balancer_shared_weight
      },
      {
        name      = "Process"
        namespace = "aws:elbv2:listenerrule:${r.name}"
        resource  = ""
        value     = r.process
      },
    ]
  ]

  ssl_mappings = flatten(local.ssl_mappings_init)
  port_mappings_local = flatten(concat(local.port_mappings_default, local.port_mappings_init,
    local.mappings_default_listeners, local.mappings_port_listeners, local.shared_lb_rules,
  local.shared_lb_mappings))
}