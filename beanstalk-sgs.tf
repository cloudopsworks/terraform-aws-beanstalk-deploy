locals {
  envsgprefix   = var.beanstalk_environment != "" ? var.beanstalk_environment : "${var.release_name}-${var.namespace}"
  sglb_name     = format("%s-%s", local.envsgprefix, "lb-sg")
  sgtarget_name = format("%s-%s", local.envsgprefix, "tgt-sg")

  ingress_default = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lb_ingresses_cidr = {
    for item in var.beanstalk_lb_sg : format("%s-%s-%s",item.cidr_block,try(item.from_port, "0"),try(item.protocol, "0")) => {
      from_port   = try(item.from_port, "0")
      to_port     = try(item.to_port, "0")
      protocol    = try(item.protocol, "-1")
      description = try(item.description, "Allow traffic")
      cidr_block  = item.cidr_block
    } if item.cidr_block != null
  }
  lb_ingresses_sg = {
    for item in var.beanstalk_lb_sg : format("%s-%s-%s",item.security_group,try(item.from_port, "0"),try(item.protocol, "0")) => {
      from_port      = try(item.from_port, "0")
      to_port        = try(item.to_port, "0")
      protocol       = try(item.protocol, "-1")
      description    = try(item.description, "Allow traffic")
      security_group = item.security_group
    } if item.security_group != null
  }
  tgt_ingresses_cidr = {
    for item in var.beanstalk_target_sg : format("%s-%s-%s",item.cidr_block,try(item.from_port, "0"),try(item.protocol, "0")) => {
      from_port   = try(item.from_port, "0")
      to_port     = try(item.to_port, "0")
      protocol    = try(item.protocol, "-1")
      description = try(item.description, "Allow traffic")
      cidr_block  = item.cidr_block
    } if item.cidr_block != null
  }
  tgt_ingresses_sg_init = {
    for item in var.beanstalk_target_sg : format("%s-%s-%s",item.security_group,try(item.from_port, "0"),try(item.protocol, "0")) => {
      from_port      = try(item.from_port, "0")
      to_port        = try(item.to_port, "0")
      protocol       = try(item.protocol, "-1")
      description    = try(item.description, "Allow traffic")
      security_group = item.security_group
    } if item.security_group != null
  }

  tgt_ingresses_sg_mappings = {
    for m in var.port_mappings : m.name => {
      from_port      = m.to_port
      to_port        = m.to_port
      protocol       = m.backend_protocol
      description    = "Allow traffic for ${m.name} - ${aws_security_group.lb_sg[0].id}"
      security_group = aws_security_group.lb_sg[0].id
    } if length(var.beanstalk_lb_sg) > 0 && length(var.beanstalk_target_sg) > 0
  }
  tgt_ingresses_sg = merge(local.tgt_ingresses_sg_init, local.tgt_ingresses_sg_mappings)
}

resource "aws_security_group" "lb_sg" {
  count = length(var.beanstalk_lb_sg) > 0 ? 1 : 0

  name        = local.sglb_name
  description = "Security group for ${local.envsgprefix}"
  vpc_id      = var.vpc_id

  tags = merge(var.extra_tags, {
    Name        = local.sglb_name
    Environment = local.envsgprefix
    Namespace   = var.namespace
    Release     = var.release_name
  })
}

resource "aws_security_group" "instance_sg" {
  count = length(var.beanstalk_target_sg) > 0 ? 1 : 0

  name        = local.sgtarget_name
  description = "Security group for ${local.envsgprefix}"
  vpc_id      = var.vpc_id

  tags = merge(var.extra_tags, {
    Name        = local.sgtarget_name
    Environment = local.envsgprefix
    Namespace   = var.namespace
    Release     = var.release_name
  })
}

# SG rules for load balancer
# Allow all outbound traffic from the load balancer
resource "aws_vpc_security_group_egress_rule" "egress_rule_lb" {
  count = length(var.beanstalk_lb_sg) > 0 ? 1 : 0

  security_group_id = aws_security_group.lb_sg[0].id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_lb_cidr" {
  for_each = local.lb_ingresses_cidr

  cidr_ipv4         = each.value.cidr_block
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  security_group_id = aws_security_group.lb_sg[0].id
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_lb_sg" {
  for_each = local.lb_ingresses_sg

  referenced_security_group_id = each.value.security_group
  description                  = each.value.description
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.protocol
  security_group_id            = aws_security_group.lb_sg[0].id
}

# Instance SG rules
# Allow all outbound traffic Target group
resource "aws_vpc_security_group_egress_rule" "egress_rule_tgt" {
  count = length(var.beanstalk_target_sg) > 0 ? 1 : 0

  security_group_id = aws_security_group.instance_sg[0].id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_tgt_cidr" {
  for_each = local.tgt_ingresses_cidr

  cidr_ipv4         = each.value.cidr_block
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  security_group_id = aws_security_group.instance_sg[0].id
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_tgt_sg" {
  for_each = local.tgt_ingresses_sg

  referenced_security_group_id = each.value.security_group
  description                  = each.value.description
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.protocol
  security_group_id            = aws_security_group.instance_sg[0].id
}
