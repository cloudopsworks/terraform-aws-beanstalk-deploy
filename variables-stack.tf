##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# solution_stack: "java"  # (Optional) Regional platform shortcut, complete AWS solution stack name, or custom regular expression. Default: "java".
variable "solution_stack" {
  type        = string
  default     = "java"
  nullable    = false
  description = <<-EOT
    (Optional) Elastic Beanstalk solution stack. The default, "java", selects Corretto 21 on Amazon Linux 2023. An empty string also selects this default.
    The "node" shortcut selects Node.js 24 on Amazon Linux 2023. Use "node20" for the retired Node.js 20 branch where AWS still offers it.
    Use a branch key such as "java25", "tomcat11j25", "node26", "python315", "dotnet-10", "php85", "ruby40", "go", "docker_al2023", "ecs" or "dotnet-w25" to select the most recent matching regional version.
    Family keys ending in "-latest" follow the branch selected by this module release. A complete AWS stack name pins a platform version. Custom regular expressions are also accepted.
    Older shortcuts targeting retired platforms are deprecated. See "Choosing a platform" in the README for all keys, retirement dates and migration targets.
  EOT
}
