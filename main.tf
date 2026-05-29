locals {
  effective_notification_topic_id = var.create_notification_topic ? oci_ons_notification_topic.this[0].id : var.notification_topic_id
  effective_log_group_id          = var.create_log_group ? oci_logging_log_group.this[0].id : var.log_group_id
}

resource "oci_ons_notification_topic" "this" {
  count = var.create_notification_topic ? 1 : 0

  compartment_id = var.compartment_ocid
  name           = coalesce(var.notification_topic_name, "${var.project_name}-topic")
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource "oci_devops_project" "this" {
  compartment_id = var.compartment_ocid
  name           = var.project_name
  description    = coalesce(var.project_description, var.project_name)
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags

  dynamic "notification_config" {
    for_each = local.effective_notification_topic_id == null ? [] : [local.effective_notification_topic_id]
    content {
      topic_id = notification_config.value
    }
  }
}

resource "oci_logging_log_group" "this" {
  count = var.create_log_group ? 1 : 0

  compartment_id = var.compartment_ocid
  display_name   = coalesce(var.log_group_name, "${var.project_name}-logs")
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}

resource "oci_logging_log" "project" {
  count = var.create_project_service_log ? 1 : 0

  display_name       = coalesce(var.project_log_name, "${var.project_name}-service-log")
  log_group_id       = local.effective_log_group_id
  log_type           = "SERVICE"
  is_enabled         = true
  retention_duration = var.project_log_retention_in_days
  defined_tags       = var.defined_tags
  freeform_tags      = var.freeform_tags

  configuration {
    compartment_id = var.compartment_ocid

    source {
      category    = "all"
      resource    = oci_devops_project.this.id
      service     = "devops"
      source_type = "OCISERVICE"
    }
  }
}

resource "oci_devops_connection" "this" {
  for_each = var.connections

  project_id      = oci_devops_project.this.id
  access_token    = each.value.access_token
  connection_type = each.value.connection_type
  display_name    = coalesce(each.value.display_name, each.key)
  description     = coalesce(each.value.description, coalesce(each.value.display_name, each.key))
}

resource "oci_devops_repository" "this" {
  for_each = var.repositories

  project_id      = oci_devops_project.this.id
  name            = each.value.name
  repository_type = each.value.repository_type
  description     = coalesce(each.value.description, each.value.name)

  mirror_repository_config {
    connector_id   = oci_devops_connection.this[each.value.connection_key].id
    repository_url = each.value.repository_url

    dynamic "trigger_schedule" {
      for_each = each.value.trigger_schedule == null ? [] : [each.value.trigger_schedule]
      content {
        schedule_type = trigger_schedule.value.schedule_type
      }
    }
  }
}

resource "oci_devops_deploy_artifact" "this" {
  for_each = var.deploy_artifacts

  project_id                 = oci_devops_project.this.id
  display_name               = each.value.display_name
  deploy_artifact_type       = each.value.deploy_artifact_type
  argument_substitution_mode = each.value.argument_substitution_mode

  deploy_artifact_source {
    deploy_artifact_source_type  = each.value.source.type
    image_uri                    = each.value.source.image_uri
    image_digest                 = each.value.source.image_digest
    repository_id                = each.value.source.repository_key == null ? null : oci_devops_repository.this[each.value.source.repository_key].id
    chart_url                    = each.value.source.chart_url
    deploy_artifact_version      = each.value.source.deploy_artifact_version
    base64encoded_content        = each.value.source.base64encoded_content
    deploy_artifact_path         = each.value.source.deploy_artifact_path
  }
}

resource "oci_devops_deploy_environment" "this" {
  for_each = var.deploy_environments

  project_id              = oci_devops_project.this.id
  display_name            = each.value.display_name
  description             = coalesce(each.value.description, each.value.display_name)
  deploy_environment_type = each.value.deploy_environment_type
  cluster_id              = each.value.cluster_id
}

resource "oci_devops_trigger" "this" {
  for_each = var.triggers

  project_id     = oci_devops_project.this.id
  repository_id  = oci_devops_repository.this[each.value.repository_key].id
  display_name   = each.value.display_name
  description    = coalesce(each.value.description, each.value.display_name)
  trigger_source = each.value.trigger_source

  actions {
    build_pipeline_id = each.value.build_pipeline_id
    type              = "TRIGGER_BUILD_PIPELINE"

    filter {
      trigger_source = each.value.trigger_source
      events         = each.value.events

      include {
        head_ref        = each.value.branch
        repository_name = oci_devops_repository.this[each.value.repository_key].name
      }
    }
  }
}
