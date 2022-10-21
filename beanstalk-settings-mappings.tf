##
# (c) 2021 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
locals {

  port_mappings_default = [
    for m in var.port_mappings :
    [
      {
        name      = "DefaultProcess"
        namespace = "aws:elbv2:listener:${m.name}"
        resource  = ""
        value     = m.name
      },
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
        name      = "ListenerEnabled"
        namespace = "aws:elbv2:listener:${m.name}"
        resource  = ""
        value     = "true"
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
    [{
      name      = "DefaultProcess"
      namespace = "aws:elbv2:listener:${m.from_port}"
      resource  = ""
      value     = m.name
      },
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
        name      = "ListenerEnabled"
        namespace = "aws:elbv2:listener:${m.from_port}"
        resource  = ""
        value     = "true"
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
    ] if m.protocol == "HTTPS"
  ]

  ssl_mappings        = flatten(local.ssl_mappings_init)
  port_mappings_local = flatten(concat(local.port_mappings_default, local.port_mappings_init))

}