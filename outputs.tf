output "environment_cname" {
  value = aws_elastic_beanstalk_environment.beanstalk_environment.cname
}

output "environment_zone_id" {
  value = data.aws_elastic_beanstalk_hosted_zone.current.id
}

data "aws_alb" "beanstalk_alb" {
  arn = aws_elastic_beanstalk_environment.beanstalk_environment.load_balancers[0]
}

output "load_balancer_arn" {
  value = data.aws_alb.beanstalk_alb.arn
}

output "load_balancer_id" {
  value = data.aws_alb.beanstalk_alb.id
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

output "environment_name" {
  value = aws_elastic_beanstalk_environment.beanstalk_environment.name
}

output "environment_scaling_groups_ids" {
  value = aws_elastic_beanstalk_environment.beanstalk_environment.autoscaling_groups
}

output "environment_instances_ids" {
  value = aws_elastic_beanstalk_environment.beanstalk_environment.instances
}

output "environment_launch_configurations_ids" {
  value = aws_elastic_beanstalk_environment.beanstalk_environment.launch_configurations
}

output "environment_endpoint_url" {
  value = aws_elastic_beanstalk_environment.beanstalk_environment.endpoint_url
}