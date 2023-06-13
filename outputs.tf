output "environment_cname" {
  value = aws_elastic_beanstalk_environment.beanstalk_environment.cname
}

data "aws_alb" "beanstalk_alb" {
  arn = aws_elastic_beanstalk_environment.beanstalk_environment.load_balancers[0]
}

output "load_balancer_address" {
  value = data.aws_alb.beanstalk_alb.dns_name
}

output "load_balancer_zone_id" {
  value = data.aws_alb.beanstalk_alb.zone_id
}

output "environment_id" {
  value = aws_elastic_beanstalk_environment.beanstalk_environment.id
}

