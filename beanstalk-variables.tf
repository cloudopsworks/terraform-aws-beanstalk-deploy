##
# (c) 2021-2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
variable "private_subnets" {
  type        = set(string)
  default     = []
  description = "(optional) Private subnets where the LB (if internal) and instances will reside."
  nullable    = false
}

variable "public_subnets" {
  type        = set(string)
  default     = []
  description = "(optional) Public subnets where the LB exposed to Internet will reside, this will be validated if *load_balancer_public=true*"
  nullable    = false
}

variable "vpc_id" {
  type        = string
  description = "(required) VPC ID where the instance will run."
  nullable    = false
}


variable "server_types" {
  type        = list(string)
  default     = ["t3a.micro"]
  description = "(optional) EC2 instance type list, first item will be used on on-demand instances."
  nullable    = false
}

variable "load_balancer_alias" {
  type        = string
  default     = ""
  description = "(optional) Required load balancer alias,"
  nullable    = false
}

variable "place_on_public" {
  type        = bool
  default     = false
  description = "(optional) Setting to make Application Load Balancer, defaults to public Load Balancer, Default: false"
  nullable    = false
}

variable "load_balancer_log_prefix" {
  type        = string
  description = "(required) Load Balancer logs Prefix for files saved on S3 bucket."
}

variable "load_balancer_log_bucket" {
  type        = string
  description = "(required) S3 Bucket name for Load Balancer logs storage."
}

variable "load_balancer_ssl_certificate_id" {
  type        = string
  description = "(required) SSL certificate ID in the same Region to attach to LB."
  # sensitive   = true
}

variable "load_balancer_public" {
  type        = bool
  default     = false
  description = "(optional) specify if load balancer will be public or private, by default is private"
  nullable    = false
}

variable "load_balancer_ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
  description = "(optional) SSL policy to apply to LB, default: null, defaults to what AWS has as default."
  nullable    = false
}

variable "load_balancer_shared" {
  type        = bool
  default     = false
  description = "(optional) Setting to make Application Load Balancer, defaults to public Load Balancer, Default: false"
}

#variable "load_balancer_shared_arn" {
#  type        = string
#  default     = ""
#  description = "(optional) Shared Load Balancer ARN id to use, Default: (empty)"
#}

variable "load_balancer_shared_name" {
  type        = string
  default     = ""
  description = "(optional) Shared Load Balancer ARN id to use, Default: (empty)"
}

variable "load_balancer_shared_weight" {
  type        = number
  default     = 0
  description = "(optional) Load Balancer weight to use, Default: 0"
}


variable "beanstalk_application" {
  type        = string
  description = "(required) Beanstalk application name to deploy to."
}

variable "beanstalk_environment" {
  type    = string
  default = ""
}

variable "beanstalk_ec2_key" {
  type        = string
  default     = ""
  description = "(optional) Existing EC2 Key for connecting via SSH. Default is null (connect may be possible through SSM)."
  nullable    = false
}

variable "beanstalk_ami_id" {
  type        = string
  default     = ""
  description = "(optional) Fix AMI which elasticbeanstalk is based on"
  nullable    = false
}

variable "beanstalk_instance_port" {
  type        = number
  default     = 80
  description = "(optional) Elastic Beanstalk default port for NGINX instance to run"
  nullable    = false
}

variable "beanstalk_instance_profile" {
  type        = string
  default     = "aws-elasticbeanstalk-ec2-role"
  description = "(optional) AWS instance profile role for the instance, this one must exist previous creation of instance."
  nullable    = false
}

variable "beanstalk_service_role" {
  type        = string
  default     = "aws-elasticbeanstalk-service-role"
  description = "(optional) AWS instance service role for the instance, only name instead of ARN (it is calculated), this one must exist previous creation of instance."
  nullable    = false
}

variable "port_mappings" {
  type = any
  default = [
    {
      name      = "default"
      from_port = 80
      to_port   = 8080
    },
  ]
  description = "(optional) Mappings of Load balancer ports."
  nullable    = false
}

variable "rule_mappings" {
  type        = any
  default     = []
  description = "(optional) Mappings of Load balancer ports."
  nullable    = false
}

variable "beanstalk_enable_spot" {
  type        = bool
  default     = false
  description = "(optional) Flag to enable SPOT instance request for Beanstalk applications, for production loads SPOT instances should be checked thoroughly. Default: false"
  nullable    = false
}
variable "beanstalk_spot_price" {
  type        = string
  default     = ""
  description = "(optional) Spot Max price in case of enabling Spot Instances. Default is blank."
  nullable    = false
}

variable "beanstalk_spot_base_ondemand" {
  type        = number
  default     = 0
  description = "(optional) SpotFleet base on-demand instance count before provisioning Spot. Default is 0."
  nullable    = false
}

variable "beanstalk_spot_base_ondemand_percent" {
  type        = number
  default     = 0
  description = "(optional) SpotFleet base on-demand instance percent. Default is 0."
  nullable    = false
}

variable "beanstalk_min_instances" {
  type        = number
  default     = 1
  description = "(optional) Minimum number of instances on the scaling group to be allowed. Default = 1."
  nullable    = false
}
variable "beanstalk_max_instances" {
  type        = number
  default     = 1
  description = "(optional) Maximum number of instances on the scaling group to be allowed. Default = 1."
  nullable    = false
}

variable "beanstalk_default_retention" {
  type        = number
  default     = 7
  description = "(optional) Default Retention of objects on the deployed application. Default: 90 days."
  nullable    = false
}

variable "beanstalk_instance_volume_size" {
  type        = number
  default     = 8
  description = "(optional) Default instance volume size in GB. Default 10gb."
  nullable    = false
}

variable "beanstalk_instance_volume_type" {
  type        = string
  default     = "gp2"
  description = "(optional) Default EC2 instance volume type. Default: gp2"
  nullable    = false
}

variable "extra_settings" {
  type = list(object({
    name      = string
    namespace = string
    resource  = optional(string)
    value     = string
  }))
  default     = []
  description = "(optional) List of extra settings for Elastic Beanstalk."
  nullable    = false
}


variable "beanstalk_lb_sg" {
  type = list(object({
    description    = optional(string)
    from_port      = optional(string)
    to_port        = optional(string)
    cidr_block     = optional(string)
    protocol       = optional(string)
    self           = optional(bool)
    security_group = optional(string)
  }))
  default = []
}

variable "beanstalk_target_sg" {
  type = list(object({
    description    = optional(string)
    from_port      = optional(string)
    to_port        = optional(string)
    cidr_block     = optional(string)
    protocol       = optional(string)
    self           = optional(bool)
    security_group = optional(string)
  }))
  default = []
}

variable "custom_shared_rules" {
  type        = bool
  default     = false
  description = "(optional) Setting to make Application Load Balancer, defaults to public Load Balancer, Default: false"
}

variable "wait_for_ready_timeout" {
  type        = string
  default     = "20m"
  description = "(optional) Time in minutes to wait for the environment to be ready. Default: 10 minutes."
}