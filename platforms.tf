##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  # AWS publishes new platform versions independently in each region.
  # Keep each current branch tied to the exact runtime label in the AWS catalog.
  al2023_branches = {
    java8_23      = "Corretto 8"
    java11_23     = "Corretto 11"
    java17_23     = "Corretto 17"
    java21        = "Corretto 21"
    java25        = "Corretto 25"
    tomcat9j8     = "Tomcat 9 Corretto 8"
    tomcat9j11    = "Tomcat 9 Corretto 11"
    tomcat9j17    = "Tomcat 9 Corretto 17"
    tomcat10j17   = "Tomcat 10 Corretto 17"
    tomcat10j21   = "Tomcat 10 Corretto 21"
    tomcat11j17   = "Tomcat 11 Corretto 17"
    tomcat11j21   = "Tomcat 11 Corretto 21"
    tomcat11j25   = "Tomcat 11 Corretto 25"
    node22        = "Node.js 22"
    node24        = "Node.js 24"
    node26        = "Node.js 26"
    python311     = "Python 3.11"
    python312     = "Python 3.12"
    python313     = "Python 3.13"
    python314     = "Python 3.14"
    python315     = "Python 3.15"
    dotnet-8      = ".NET 8"
    dotnet-9      = ".NET 9"
    dotnet10      = ".NET 10"
    php82         = "PHP 8.2"
    php83         = "PHP 8.3"
    php84         = "PHP 8.4"
    php85         = "PHP 8.5"
    ruby33        = "Ruby 3.3"
    ruby34        = "Ruby 3.4"
    ruby40        = "Ruby 4.0"
    go            = "Go 1"
    docker_al2023 = "Docker"
    ecs           = "ECS"
  }

  latest_branches = {
    java-latest   = "java25"
    tomcat-latest = "tomcat11j25"
    node-latest   = "node26"
    python-latest = "python315"
    dotnet-latest = "dotnet10"
    php-latest    = "php85"
    ruby-latest   = "ruby40"
  }

  branch_aliases = merge(local.latest_branches, {
    node      = "node24"
    dotnet    = "dotnet10"
    dotnet-10 = "dotnet10"
    java      = "java21"
    tomcat    = "tomcat11j21"
    python    = "python314"
    php       = local.latest_branches["php-latest"]
    ruby      = local.latest_branches["ruby-latest"]
    docker    = "docker_al2023"
    docker-m  = "ecs"
  })

  stack_version = "v[0-9]+([.][0-9]+)+"
  al2023_prefix = "^64bit Amazon Linux 2023 ${local.stack_version} running "
  al2_prefix    = "^64bit Amazon Linux 2 ${local.stack_version} running "
  al2023_stacks = {
    for key, runtime in local.al2023_branches : key => "${local.al2023_prefix}\\Q${runtime}\\E$"
  }

  # The legacy tomcatj17 shortcut matches Corretto 17 across Tomcat branches.
  tomcat_stacks = {
    tomcatj17 = "${local.al2023_prefix}Tomcat [0-9.]+ Corretto 17$"
  }

  windows_stacks = {
    dotnet-w19   = "^64bit Windows Server 2019 ${local.stack_version} running IIS 10[.]0$"
    dotnet-w22   = "^64bit Windows Server 2022 ${local.stack_version} running IIS 10[.]0$"
    dotnet-w25   = "^64bit Windows Server 2025 ${local.stack_version} running IIS 10[.]0$"
    net-core-w19 = "^64bit Windows Server Core 2019 ${local.stack_version} running IIS 10[.]0$"
    net-core-w22 = "^64bit Windows Server Core 2022 ${local.stack_version} running IIS 10[.]0$"
    net-core-w25 = "^64bit Windows Server Core 2025 ${local.stack_version} running IIS 10[.]0$"
  }

  # Deprecated shortcuts only resolve while AWS lists their retired stacks for the caller.
  retired_stacks = {
    java8        = "${local.al2_prefix}Corretto 8$"
    java11       = "${local.al2_prefix}Corretto 11$"
    java17       = "${local.al2_prefix}Corretto 17$"
    tomcatj8     = "${local.al2_prefix}Tomcat [0-9.]+ Corretto 8$"
    tomcatj11    = "${local.al2_prefix}Tomcat [0-9.]+ Corretto 11$"
    node14       = "${local.al2_prefix}Node[.]js 14$"
    node16       = "${local.al2_prefix}Node[.]js 16$"
    node18       = "${local.al2_prefix}Node[.]js 18$"
    node18_23    = "${local.al2023_prefix}Node[.]js 18$"
    node20       = "${local.al2023_prefix}Node[.]js 20$"
    python37     = "${local.al2_prefix}Python 3[.]7$"
    python38     = "${local.al2_prefix}Python 3[.]8$"
    python39     = "${local.al2023_prefix}Python 3[.]9$"
    go_al2       = "${local.al2_prefix}Go 1$"
    dotnet-core  = "${local.al2_prefix}[.]NET Core$"
    dotnet-6     = "${local.al2023_prefix}[.]NET 6$"
    dotnet-w16   = "^64bit Windows Server 2016 ${local.stack_version} running IIS 10[.]0$"
    net-core-w16 = "^64bit Windows Server Core 2016 ${local.stack_version} running IIS 10[.]0$"
  }

  solutions = merge(
    local.al2023_stacks, local.windows_stacks, local.tomcat_stacks, local.retired_stacks,
    { for alias, branch in local.branch_aliases : alias => local.al2023_stacks[branch] }
  )

  # Quote literal AWS names for name_regex. Callers can also pass a custom regex.
  stack_selector    = coalesce(var.solution_stack, "java")
  is_full_name      = can(regex("^64bit [a-zA-Z0-9 .-]+ ${local.stack_version} running [a-zA-Z0-9 .#/-]+$", local.stack_selector))
  selected_solution = lookup(local.solutions, local.stack_selector, local.is_full_name ? "^\\Q${local.stack_selector}\\E$" : local.stack_selector)
}

data "aws_elastic_beanstalk_solution_stack" "solution_stack" {
  most_recent = true
  name_regex  = local.selected_solution
}
