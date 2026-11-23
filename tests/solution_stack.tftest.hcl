mock_provider "aws" {
  mock_resource "aws_elastic_beanstalk_environment" {
    defaults = {
      autoscaling_groups = ["test-asg"]
      load_balancers     = ["arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/test/1234567890123456"]
    }
  }
}
mock_provider "null" {}

variables {
  release_name                     = "test"
  namespace                        = "dev"
  application_version_label        = "1"
  beanstalk_application            = "test"
  sts_assume_role                  = ""
  vpc_id                           = "vpc-12345678"
  load_balancer_log_prefix         = "test"
  load_balancer_log_bucket         = "test-bucket"
  load_balancer_ssl_certificate_id = "00000000-0000-0000-0000-000000000000"
}

run "default_java" {
  command = plan
  assert {
    condition = (
      aws_elastic_beanstalk_environment.beanstalk_environment.solution_stack_name == data.aws_elastic_beanstalk_solution_stack.solution_stack.name &&
      data.aws_elastic_beanstalk_solution_stack.solution_stack.most_recent &&
      can(regex(data.aws_elastic_beanstalk_solution_stack.solution_stack.name_regex, "64bit Amazon Linux 2023 v4.14.3 running Corretto 21"))
    )
    error_message = "The default must select the latest Corretto 21 AL2023 release."
  }
}

run "empty_uses_default" {
  command = plan
  variables {
    solution_stack = ""
  }
  assert {
    condition     = data.aws_elastic_beanstalk_solution_stack.solution_stack.name_regex == local.solutions["java"]
    error_message = "An empty stack must resolve like the java alias."
  }
}

run "branch_aliases" {
  command = plan
  variables {
    solution_stack = "node-latest"
  }
  assert {
    condition     = can(regex(data.aws_elastic_beanstalk_solution_stack.solution_stack.name_regex, "64bit Amazon Linux 2023 v6.12.3 running Node.js 26"))
    error_message = "The AWS lookup must receive the resolved Node.js branch pattern."
  }
  assert {
    condition = alltrue([for alias, suffix in {
      java-latest   = "Corretto 25"
      tomcat-latest = "Tomcat 11 Corretto 25"
      node-latest   = "Node.js 26"
      python-latest = "Python 3.15"
      dotnet-latest = ".NET 10"
      php-latest    = "PHP 8.5"
      ruby-latest   = "Ruby 4.0"
      docker_al2023 = "Docker"
      ecs           = "ECS"
    } : can(regex(local.solutions[alias], "64bit Amazon Linux 2023 v4.14.3 running ${suffix}"))])
    error_message = "A current alias failed to match its AWS branch."
  }
  assert {
    condition = (
      can(regex(local.solutions["dotnet-w25"], "64bit Windows Server 2025 v2.23.10 running IIS 10.0")) &&
      can(regex(local.solutions["java17"], "64bit Amazon Linux 2 v3.6.0 running Corretto 17")) &&
      !can(regex(local.solutions["java17"], "64bit Amazon Linux 2023 v4.14.3 running Corretto 17")) &&
      !can(regex(local.solutions["tomcat11j25"], "64bit Amazon Linux 2023 v5.15.3 running Tomcat 10 Corretto 25")) &&
      !can(regex(local.solutions["node26"], "64bit Amazon Linux 2023 v6.12.3 running Node.js 260"))
    )
    error_message = "Windows, Tomcat, Node.js and legacy Java aliases must preserve runtime and OS boundaries."
  }
}

run "full_name_pin" {
  command = plan
  variables {
    solution_stack = "64bit Amazon Linux 2023 v6.12.3 running Node.js 26"
  }
  assert {
    condition = (
      can(regex(local.selected_solution, var.solution_stack)) &&
      !can(regex(local.selected_solution, replace(var.solution_stack, "6.12.3", "6x12x3"))) &&
      !can(regex(local.selected_solution, "${var.solution_stack}0"))
    )
    error_message = "An exact name must match literally and in full."
  }
}

run "custom_regex" {
  command = plan
  variables {
    solution_stack = "^64bit Amazon Linux 2023 .* running Go 1$"
  }
  assert {
    condition     = data.aws_elastic_beanstalk_solution_stack.solution_stack.name_regex == var.solution_stack
    error_message = "Explicit regex inputs must reach the AWS lookup intact."
  }
}
