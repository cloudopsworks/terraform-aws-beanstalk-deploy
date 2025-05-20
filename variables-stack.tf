##
# (c) 2021-2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "solution_stack" {
  type        = string
  default     = "java"
  nullable    = false
  description = <<EOL
(required) Specify solution stack for Elastic Beanstalk
Solution stack is one of:
    java         = 64bit Amazon Linux 2023 (.*) running Corretto 21(.*)
    java8        = 64bit Amazon Linux 2 (.*) running Corretto 8(.*)
    java11       = 64bit Amazon Linux 2 (.*) running Corretto 11(.*)
    java17       = 64bit Amazon Linux 2 (.*) running Corretto 17(.*)
    tomcat       = 64bit Amazon Linux 2023 (.*) Tomcat (.*) Corretto 21(.*)
    java17_23    = 64bit Amazon Linux 2023 (.*) running Corretto 17(.*)
    tomcatj8     = 64bit Amazon Linux 2 (.*) Tomcat (.*) Corretto 8(.*)
    tomcatj11    = 64bit Amazon Linux 2 (.*) Tomcat (.*) Corretto 11(.*)
    tomcatj17    = 64bit Amazon Linux 2023 (.*) Tomcat (.*) Corretto 17(.*)
    node         = 64bit Amazon Linux 2023 (.*) Node.js 20(.*)
    node22       = 64bit Amazon Linux 2023 (.*) Node.js 22(.*)
    node14       = 64bit Amazon Linux 2 (.*) Node.js 14(.*)
    node16       = 64bit Amazon Linux 2 (.*) Node.js 16(.*)
    node18       = 64bit Amazon Linux 2 (.*) Node.js 18(.*)
    node18_23    = 64bit Amazon Linux 2023 (.*) Node.js 18(.*)
    go           = 64bit Amazon Linux 2 (.*) running Go (.*)
    docker       = 64bit Amazon Linux 2 (.*) running Docker (.*)
    docker-m     = 64bit Amazon Linux 2 (.*) Multi-container Docker (.*)
    dotnet-core  = 64bit Amazon Linux 2 (.*) running .NET Core(.*)
    dotnet-6     = 64bit Amazon Linux 2023 (.*) running .NET 6(.*)
    dotnet-8     = 64bit Amazon Linux 2023 (.*) running .NET 8(.*)
    dotnet-9     = 64bit Amazon Linux 2023 (.*) running .NET 9(.*)
    dotnet       = 64bit Amazon Linux 2023 (.*) running .NET 9(.*)
    python       = 64bit Amazon Linux 2023 (.*) running Python 3.13(.*)
    python313    = 64bit Amazon Linux 2023 (.*) running Python 3.13(.*)
    python312    = 64bit Amazon Linux 2023 (.*) running Python 3.12(.*)
    python311    = 64bit Amazon Linux 2023 (.*) running Python 3.11(.*)
    python39     = 64bit Amazon Linux 2023 (.*) running Python 3.9(.*)
    python38     = 64bit Amazon Linux 2 (.*) running Python 3.8(.*)
    python37     = 64bit Amazon Linux 2 (.*) running Python 3.7(.*)
    net-core-w16 = 64bit Windows Server Core 2016 (.*) running IIS (.*)
    net-core-w19 = 64bit Windows Server Core 2019 (.*) running IIS (.*)
    net-core-w22 = 64bit Windows Server Core 2022 (.*) running IIS (.*)
    net-core-w25 = 64bit Windows Server Core 2025 (.*) running IIS (.*)
    dotnet-w16   = 64bit Windows Server 2016 (.*) running IIS (.*)
    dotnet-w19   = 64bit Windows Server 2019 (.*) running IIS (.*)
    dotnet-w22   = 64bit Windows Server 2022 (.*) running IIS (.*)
    dotnet-w25   = 64bit Windows Server 2025 (.*) running IIS (.*)

Or explicity name the complete stack available from AWS, to prevent undesired stack upgrades.
EOL
}
