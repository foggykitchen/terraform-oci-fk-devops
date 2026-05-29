variable "compartment_ocid" {
  description = "OCI compartment OCID where the DevOps resources are created."
  type        = string
}

variable "project_name" {
  description = "OCI DevOps project display name."
  type        = string
}

variable "project_description" {
  description = "OCI DevOps project description."
  type        = string
  default     = null
}

variable "notification_topic_id" {
  description = "Existing ONS topic OCID to attach to the DevOps project. If null and create_notification_topic is true, the module creates a topic."
  type        = string
  default     = null
}

variable "create_notification_topic" {
  description = "Whether to create an ONS notification topic for the DevOps project."
  type        = bool
  default     = false
}

variable "notification_topic_name" {
  description = "ONS notification topic name when create_notification_topic is true."
  type        = string
  default     = null
}

variable "create_log_group" {
  description = "Whether to create a logging log group for the DevOps project service log."
  type        = bool
  default     = false
}

variable "log_group_id" {
  description = "Existing OCI Logging log group OCID to reuse. Required if create_log_group is false and create_project_service_log is true."
  type        = string
  default     = null
}

variable "log_group_name" {
  description = "Log group display name when create_log_group is true."
  type        = string
  default     = null
}

variable "create_project_service_log" {
  description = "Whether to create the OCI Logging service log for the DevOps project."
  type        = bool
  default     = false
}

variable "project_log_name" {
  description = "Service log display name."
  type        = string
  default     = null
}

variable "project_log_retention_in_days" {
  description = "Retention period in days for the DevOps project service log."
  type        = number
  default     = 30
}

variable "connections" {
  description = "Map of DevOps external connections keyed by logical name."
  type = map(object({
    display_name    = optional(string)
    description     = optional(string)
    connection_type = optional(string, "GITHUB_ACCESS_TOKEN")
    access_token    = string
  }))
  default = {}
}

variable "repositories" {
  description = "Map of mirrored DevOps repositories keyed by logical name."
  type = map(object({
    name            = string
    description     = optional(string)
    repository_type = optional(string, "MIRRORED")
    connection_key  = string
    repository_url  = string
    branch          = optional(string, "main")
    trigger_schedule = optional(object({
      schedule_type = optional(string, "DEFAULT")
    }), {})
  }))
  default = {}
}

variable "deploy_artifacts" {
  description = "Map of OCI DevOps deploy artifacts keyed by logical name."
  type = map(object({
    display_name               = string
    argument_substitution_mode = optional(string, "NONE")
    deploy_artifact_type       = string
    source = object({
      type                         = string
      image_uri                    = optional(string)
      image_digest                 = optional(string)
      repository_key               = optional(string)
      chart_url                    = optional(string)
      deploy_artifact_version      = optional(string)
      base64encoded_content        = optional(string)
      deploy_artifact_path         = optional(string)
    })
  }))
  default = {}
}

variable "deploy_environments" {
  description = "Map of DevOps deploy environments keyed by logical name."
  type = map(object({
    display_name            = string
    description             = optional(string)
    deploy_environment_type = optional(string, "OKE_CLUSTER")
    cluster_id              = string
  }))
  default = {}
}

variable "triggers" {
  description = "Map of DevOps triggers keyed by logical name."
  type = map(object({
    display_name      = string
    description       = optional(string)
    repository_key    = string
    build_pipeline_id = string
    trigger_source    = optional(string, "DEVOPS_CODE_REPOSITORY")
    events            = optional(list(string), ["PUSH"])
    branch            = optional(string, "main")
  }))
  default = {}
}

variable "defined_tags" {
  description = "Defined tags applied to supported resources."
  type        = map(string)
  default     = {}
}

variable "freeform_tags" {
  description = "Freeform tags applied to supported resources."
  type        = map(string)
  default     = {}
}
