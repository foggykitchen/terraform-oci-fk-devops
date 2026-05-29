output "project_id" {
  description = "OCI DevOps project OCID."
  value       = oci_devops_project.this.id
}

output "project_name" {
  description = "OCI DevOps project name."
  value       = oci_devops_project.this.name
}

output "notification_topic_id" {
  description = "Effective notification topic OCID attached to the project."
  value       = local.effective_notification_topic_id
}

output "log_group_id" {
  description = "Effective OCI Logging log group OCID."
  value       = local.effective_log_group_id
}

output "project_log_id" {
  description = "OCI Logging service log OCID for the DevOps project."
  value       = try(oci_logging_log.project[0].id, null)
}

output "connection_ids" {
  description = "Map of DevOps connection OCIDs keyed by logical name."
  value       = { for key, connection in oci_devops_connection.this : key => connection.id }
}

output "repository_ids" {
  description = "Map of DevOps repository OCIDs keyed by logical name."
  value       = { for key, repository in oci_devops_repository.this : key => repository.id }
}

output "deploy_artifact_ids" {
  description = "Map of DevOps deploy artifact OCIDs keyed by logical name."
  value       = { for key, artifact in oci_devops_deploy_artifact.this : key => artifact.id }
}

output "deploy_environment_ids" {
  description = "Map of DevOps deploy environment OCIDs keyed by logical name."
  value       = { for key, environment in oci_devops_deploy_environment.this : key => environment.id }
}

output "trigger_ids" {
  description = "Map of DevOps trigger OCIDs keyed by logical name."
  value       = { for key, trigger in oci_devops_trigger.this : key => trigger.id }
}

output "project" {
  description = "Structured summary of the DevOps project and attached companion resources."
  value = {
    id                    = oci_devops_project.this.id
    name                  = oci_devops_project.this.name
    notification_topic_id = local.effective_notification_topic_id
    log_group_id          = local.effective_log_group_id
    project_log_id        = try(oci_logging_log.project[0].id, null)
  }
}
