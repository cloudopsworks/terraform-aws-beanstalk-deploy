## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_elastic_beanstalk_environment.beanstalk_environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_environment) | resource |
| [aws_lb_listener_rule.lb_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_security_group.instance_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.lb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.egress_rule_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.egress_rule_tgt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_rule_lb_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_rule_lb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_rule_tgt_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_rule_tgt_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [null_resource.lb_rule_keep](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.shared_lb_rules](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_alb.beanstalk_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/alb) | data source |
| [aws_autoscaling_group.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/autoscaling_group) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_elastic_beanstalk_application.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elastic_beanstalk_application) | data source |
| [aws_elastic_beanstalk_hosted_zone.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elastic_beanstalk_hosted_zone) | data source |
| [aws_elastic_beanstalk_solution_stack.solution_stack](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elastic_beanstalk_solution_stack) | data source |
| [aws_lb.shared_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb_listener.lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_listener) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_version_label"></a> [application\_version\_label](#input\_application\_version\_label) | (required) Application version label to apply to environment | `string` | n/a | yes |
| <a name="input_beanstalk_ami_id"></a> [beanstalk\_ami\_id](#input\_beanstalk\_ami\_id) | (optional) Fix AMI which elasticbeanstalk is based on | `string` | `""` | no |
| <a name="input_beanstalk_application"></a> [beanstalk\_application](#input\_beanstalk\_application) | (required) Beanstalk application name to deploy to. | `string` | n/a | yes |
| <a name="input_beanstalk_default_retention"></a> [beanstalk\_default\_retention](#input\_beanstalk\_default\_retention) | (optional) Default Retention of objects on the deployed application. Default: 90 days. | `number` | `7` | no |
| <a name="input_beanstalk_ec2_key"></a> [beanstalk\_ec2\_key](#input\_beanstalk\_ec2\_key) | (optional) Existing EC2 Key for connecting via SSH. Default is null (connect may be possible through SSM). | `string` | `""` | no |
| <a name="input_beanstalk_enable_spot"></a> [beanstalk\_enable\_spot](#input\_beanstalk\_enable\_spot) | (optional) Flag to enable SPOT instance request for Beanstalk applications, for production loads SPOT instances should be checked thoroughly. Default: false | `bool` | `false` | no |
| <a name="input_beanstalk_environment"></a> [beanstalk\_environment](#input\_beanstalk\_environment) | n/a | `string` | `""` | no |
| <a name="input_beanstalk_instance_port"></a> [beanstalk\_instance\_port](#input\_beanstalk\_instance\_port) | (optional) Elastic Beanstalk default port for NGINX instance to run | `number` | `80` | no |
| <a name="input_beanstalk_instance_profile"></a> [beanstalk\_instance\_profile](#input\_beanstalk\_instance\_profile) | (optional) AWS instance profile role for the instance, this one must exist previous creation of instance. | `string` | `"aws-elasticbeanstalk-ec2-role"` | no |
| <a name="input_beanstalk_instance_volume_size"></a> [beanstalk\_instance\_volume\_size](#input\_beanstalk\_instance\_volume\_size) | (optional) Default instance volume size in GB. Default 10gb. | `number` | `8` | no |
| <a name="input_beanstalk_instance_volume_type"></a> [beanstalk\_instance\_volume\_type](#input\_beanstalk\_instance\_volume\_type) | (optional) Default EC2 instance volume type. Default: gp2 | `string` | `"gp2"` | no |
| <a name="input_beanstalk_lb_sg"></a> [beanstalk\_lb\_sg](#input\_beanstalk\_lb\_sg) | n/a | <pre>list(object({<br/>    description    = optional(string)<br/>    from_port      = optional(string)<br/>    to_port        = optional(string)<br/>    cidr_block     = optional(string)<br/>    protocol       = optional(string)<br/>    self           = optional(bool)<br/>    security_group = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_beanstalk_max_instances"></a> [beanstalk\_max\_instances](#input\_beanstalk\_max\_instances) | (optional) Maximum number of instances on the scaling group to be allowed. Default = 1. | `number` | `1` | no |
| <a name="input_beanstalk_min_instances"></a> [beanstalk\_min\_instances](#input\_beanstalk\_min\_instances) | (optional) Minimum number of instances on the scaling group to be allowed. Default = 1. | `number` | `1` | no |
| <a name="input_beanstalk_service_role"></a> [beanstalk\_service\_role](#input\_beanstalk\_service\_role) | (optional) AWS instance service role for the instance, only name instead of ARN (it is calculated), this one must exist previous creation of instance. | `string` | `"aws-elasticbeanstalk-service-role"` | no |
| <a name="input_beanstalk_spot_base_ondemand"></a> [beanstalk\_spot\_base\_ondemand](#input\_beanstalk\_spot\_base\_ondemand) | (optional) SpotFleet base on-demand instance count before provisioning Spot. Default is 0. | `number` | `0` | no |
| <a name="input_beanstalk_spot_base_ondemand_percent"></a> [beanstalk\_spot\_base\_ondemand\_percent](#input\_beanstalk\_spot\_base\_ondemand\_percent) | (optional) SpotFleet base on-demand instance percent. Default is 0. | `number` | `0` | no |
| <a name="input_beanstalk_spot_price"></a> [beanstalk\_spot\_price](#input\_beanstalk\_spot\_price) | (optional) Spot Max price in case of enabling Spot Instances. Default is blank. | `string` | `""` | no |
| <a name="input_beanstalk_target_sg"></a> [beanstalk\_target\_sg](#input\_beanstalk\_target\_sg) | n/a | <pre>list(object({<br/>    description    = optional(string)<br/>    from_port      = optional(string)<br/>    to_port        = optional(string)<br/>    cidr_block     = optional(string)<br/>    protocol       = optional(string)<br/>    self           = optional(bool)<br/>    security_group = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_custom_shared_rules"></a> [custom\_shared\_rules](#input\_custom\_shared\_rules) | (optional) Setting to make Application Load Balancer, defaults to public Load Balancer, Default: false | `bool` | `false` | no |
| <a name="input_extra_files"></a> [extra\_files](#input\_extra\_files) | (optional) List of source files where to pull info. | `list(string)` | `[]` | no |
| <a name="input_extra_settings"></a> [extra\_settings](#input\_extra\_settings) | (optional) List of extra settings for Elastic Beanstalk. | <pre>list(object({<br/>    name      = string<br/>    namespace = string<br/>    resource  = optional(string)<br/>    value     = string<br/>  }))</pre> | `[]` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | (optional) Map of extra tags to add to the resources. | `map(string)` | `{}` | no |
| <a name="input_load_balancer_alias"></a> [load\_balancer\_alias](#input\_load\_balancer\_alias) | (optional) Required load balancer alias, | `string` | `""` | no |
| <a name="input_load_balancer_log_bucket"></a> [load\_balancer\_log\_bucket](#input\_load\_balancer\_log\_bucket) | (required) S3 Bucket name for Load Balancer logs storage. | `string` | n/a | yes |
| <a name="input_load_balancer_log_prefix"></a> [load\_balancer\_log\_prefix](#input\_load\_balancer\_log\_prefix) | (required) Load Balancer logs Prefix for files saved on S3 bucket. | `string` | n/a | yes |
| <a name="input_load_balancer_public"></a> [load\_balancer\_public](#input\_load\_balancer\_public) | (optional) specify if load balancer will be public or private, by default is private | `bool` | `false` | no |
| <a name="input_load_balancer_shared"></a> [load\_balancer\_shared](#input\_load\_balancer\_shared) | (optional) Setting to make Application Load Balancer, defaults to public Load Balancer, Default: false | `bool` | `false` | no |
| <a name="input_load_balancer_shared_name"></a> [load\_balancer\_shared\_name](#input\_load\_balancer\_shared\_name) | (optional) Shared Load Balancer ARN id to use, Default: (empty) | `string` | `""` | no |
| <a name="input_load_balancer_shared_weight"></a> [load\_balancer\_shared\_weight](#input\_load\_balancer\_shared\_weight) | (optional) Load Balancer weight to use, Default: 0 | `number` | `0` | no |
| <a name="input_load_balancer_ssl_certificate_id"></a> [load\_balancer\_ssl\_certificate\_id](#input\_load\_balancer\_ssl\_certificate\_id) | (required) SSL certificate ID in the same Region to attach to LB. | `string` | n/a | yes |
| <a name="input_load_balancer_ssl_policy"></a> [load\_balancer\_ssl\_policy](#input\_load\_balancer\_ssl\_policy) | (optional) SSL policy to apply to LB, default: null, defaults to what AWS has as default. | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (required) namespace that determines the environment naming | `string` | n/a | yes |
| <a name="input_place_on_public"></a> [place\_on\_public](#input\_place\_on\_public) | (optional) Setting to make Application Load Balancer, defaults to public Load Balancer, Default: false | `bool` | `false` | no |
| <a name="input_port_mappings"></a> [port\_mappings](#input\_port\_mappings) | (optional) Mappings of Load balancer ports. | `any` | <pre>[<br/>  {<br/>    "from_port": 80,<br/>    "name": "default",<br/>    "to_port": 8080<br/>  }<br/>]</pre> | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | (optional) Private subnets where the LB (if internal) and instances will reside. | `set(string)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | (optional) Public subnets where the LB exposed to Internet will reside, this will be validated if *load\_balancer\_public=true* | `set(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | # (c) 2021-2024 - Cloud Ops Works LLC - https://cloudops.works/ On GitHub: https://github.com/cloudopsworks Distributed Under Apache v2.0 License | `string` | `"us-east-1"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | (required) The Release Name that will be used to name all resources. | `string` | n/a | yes |
| <a name="input_rule_mappings"></a> [rule\_mappings](#input\_rule\_mappings) | (optional) Mappings of Load balancer ports. | `any` | `[]` | no |
| <a name="input_server_types"></a> [server\_types](#input\_server\_types) | (optional) EC2 instance type list, first item will be used on on-demand instances. | `list(string)` | <pre>[<br/>  "t3a.micro"<br/>]</pre> | no |
| <a name="input_solution_stack"></a> [solution\_stack](#input\_solution\_stack) | (required) Specify solution stack for Elastic Beanstalk<br/>Solution stack is one of:<br/>    java         = 64bit Amazon Linux 2023 (.*) running Corretto 21(.*)<br/>    java8        = 64bit Amazon Linux 2 (.*) running Corretto 8(.*)<br/>    java11       = 64bit Amazon Linux 2 (.*) running Corretto 11(.*)<br/>    java17       = 64bit Amazon Linux 2 (.*) running Corretto 17(.*)<br/>    tomcat       = 64bit Amazon Linux 2023 (.*) Tomcat (.*) Corretto 21(.*)<br/>    java17\_23    = 64bit Amazon Linux 2023 (.*) running Corretto 17(.*)<br/>    tomcatj8     = 64bit Amazon Linux 2 (.*) Tomcat (.*) Corretto 8(.*)<br/>    tomcatj11    = 64bit Amazon Linux 2 (.*) Tomcat (.*) Corretto 11(.*)<br/>    tomcatj17    = 64bit Amazon Linux 2023 (.*) Tomcat (.*) Corretto 17(.*)<br/>    node         = 64bit Amazon Linux 2023 (.*) Node.js 20(.*)<br/>    node22       = 64bit Amazon Linux 2023 (.*) Node.js 22(.*)<br/>    node14       = 64bit Amazon Linux 2 (.*) Node.js 14(.*)<br/>    node16       = 64bit Amazon Linux 2 (.*) Node.js 16(.*)<br/>    node18       = 64bit Amazon Linux 2 (.*) Node.js 18(.*)<br/>    node18\_23    = 64bit Amazon Linux 2023 (.*) Node.js 18(.*)<br/>    go           = 64bit Amazon Linux 2023 (.*) running Go (.*)<br/>    go\_al2       = 64bit Amazon Linux 2 (.*) running Go (.*)<br/>    docker       = 64bit Amazon Linux 2 (.*) running Docker (.*)<br/>    docker-m     = 64bit Amazon Linux 2 (.*) Multi-container Docker (.*)<br/>    dotnet-core  = 64bit Amazon Linux 2 (.*) running .NET Core(.*)<br/>    dotnet-6     = 64bit Amazon Linux 2023 (.*) running .NET 6(.*)<br/>    dotnet-8     = 64bit Amazon Linux 2023 (.*) running .NET 8(.*)<br/>    dotnet-9     = 64bit Amazon Linux 2023 (.*) running .NET 9(.*)<br/>    dotnet       = 64bit Amazon Linux 2023 (.*) running .NET 9(.*)<br/>    python       = 64bit Amazon Linux 2023 (.*) running Python 3.13(.*)<br/>    python313    = 64bit Amazon Linux 2023 (.*) running Python 3.13(.*)<br/>    python312    = 64bit Amazon Linux 2023 (.*) running Python 3.12(.*)<br/>    python311    = 64bit Amazon Linux 2023 (.*) running Python 3.11(.*)<br/>    python39     = 64bit Amazon Linux 2023 (.*) running Python 3.9(.*)<br/>    python38     = 64bit Amazon Linux 2 (.*) running Python 3.8(.*)<br/>    python37     = 64bit Amazon Linux 2 (.*) running Python 3.7(.*)<br/>    net-core-w16 = 64bit Windows Server Core 2016 (.*) running IIS (.*)<br/>    net-core-w19 = 64bit Windows Server Core 2019 (.*) running IIS (.*)<br/>    net-core-w22 = 64bit Windows Server Core 2022 (.*) running IIS (.*)<br/>    net-core-w25 = 64bit Windows Server Core 2025 (.*) running IIS (.*)<br/>    dotnet-w16   = 64bit Windows Server 2016 (.*) running IIS (.*)<br/>    dotnet-w19   = 64bit Windows Server 2019 (.*) running IIS (.*)<br/>    dotnet-w22   = 64bit Windows Server 2022 (.*) running IIS (.*)<br/>    dotnet-w25   = 64bit Windows Server 2025 (.*) running IIS (.*)<br/><br/>Or explicity name the complete stack available from AWS, to prevent undesired stack upgrades. | `string` | `"java"` | no |
| <a name="input_sts_assume_role"></a> [sts\_assume\_role](#input\_sts\_assume\_role) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (required) VPC ID where the instance will run. | `string` | n/a | yes |
| <a name="input_wait_for_ready_timeout"></a> [wait\_for\_ready\_timeout](#input\_wait\_for\_ready\_timeout) | (optional) Time in minutes to wait for the environment to be ready. Default: 10 minutes. | `string` | `"20m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environment_cname"></a> [environment\_cname](#output\_environment\_cname) | n/a |
| <a name="output_environment_endpoint_url"></a> [environment\_endpoint\_url](#output\_environment\_endpoint\_url) | n/a |
| <a name="output_environment_id"></a> [environment\_id](#output\_environment\_id) | n/a |
| <a name="output_environment_instances_ids"></a> [environment\_instances\_ids](#output\_environment\_instances\_ids) | n/a |
| <a name="output_environment_launch_configurations_ids"></a> [environment\_launch\_configurations\_ids](#output\_environment\_launch\_configurations\_ids) | n/a |
| <a name="output_environment_name"></a> [environment\_name](#output\_environment\_name) | n/a |
| <a name="output_environment_scaling_groups_ids"></a> [environment\_scaling\_groups\_ids](#output\_environment\_scaling\_groups\_ids) | n/a |
| <a name="output_environment_zone_id"></a> [environment\_zone\_id](#output\_environment\_zone\_id) | n/a |
| <a name="output_load_balancer_address"></a> [load\_balancer\_address](#output\_load\_balancer\_address) | n/a |
| <a name="output_load_balancer_arn"></a> [load\_balancer\_arn](#output\_load\_balancer\_arn) | n/a |
| <a name="output_load_balancer_id"></a> [load\_balancer\_id](#output\_load\_balancer\_id) | n/a |
| <a name="output_load_balancer_zone_id"></a> [load\_balancer\_zone\_id](#output\_load\_balancer\_zone\_id) | n/a |
