##
# (c) 2021-2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
variable "release_name" {
  type        = string
  description = "(required) The Release Name that will be used to name all resources."
}

# variable "source_name" {
#   type = string
# }

# variable "source_version" {
#   type = string
# }

# variable "application_versions_bucket" {
#   type        = string
#   description = "(Required) Application Versions bucket"
# }

variable "namespace" {
  type        = string
  description = "(required) namespace that determines the environment naming"
}

variable "extra_files" {
  type        = list(string)
  default     = []
  description = "(optional) List of source files where to pull info."
  nullable    = false
}

variable "application_version_label" {
  type        = string
  description = "(required) Application version label to apply to environment"
  nullable    = false
}

variable "extra_tags" {
  type        = map(string)
  description = "(optional) Map of extra tags to add to the resources."
  default     = {}
}