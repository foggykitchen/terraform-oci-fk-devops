# Synthetic fixtures only. Every run is plan-only; no tenancy credentials are used.
mock_provider "oci" {
  mock_resource "oci_devops_connection" {
    defaults = { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_CONNECTION", "last_connection_validation_result" = [{ "message" = "mock-value", "result" = "mock-value", "time_validated" = "mock-value" }], "state" = "AVAILABLE", "system_tags" = {}, "time_created" = "mock-value", "time_updated" = "mock-value" }
  }
  mock_resource "oci_devops_deploy_artifact" {
    defaults = { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_ARTIFACT", "lifecycle_details" = "mock-value", "state" = "AVAILABLE", "system_tags" = {}, "time_created" = "mock-value", "time_updated" = "mock-value" }
  }
  mock_resource "oci_devops_deploy_environment" {
    defaults = { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_ENVIRONMENT", "lifecycle_details" = "mock-value", "state" = "AVAILABLE", "system_tags" = {}, "time_created" = "mock-value", "time_updated" = "mock-value" }
  }
  mock_resource "oci_devops_project" {
    defaults = { "id" = "MOCK_OCID_PROJECT", "lifecycle_details" = "mock-value", "namespace" = "mocknamespace", "state" = "AVAILABLE", "system_tags" = {}, "time_created" = "mock-value", "time_updated" = "mock-value" }
  }
  mock_resource "oci_devops_repository" {
    defaults = { "branch_count" = 1, "commit_count" = 1, "compartment_id" = "MOCK_OCID_COMPARTMENT", "http_url" = "mock-value", "id" = "MOCK_OCID_REPOSITORY", "lifecyle_details" = "mock-value", "namespace" = "mocknamespace", "project_name" = "mock-value", "size_in_bytes" = "mock-value", "ssh_url" = "mock-value", "state" = "AVAILABLE", "system_tags" = {}, "time_created" = "mock-value", "time_updated" = "mock-value", "trigger_build_events" = ["mock-value"] }
  }
  mock_resource "oci_devops_trigger" {
    defaults = { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_TRIGGER", "lifecycle_details" = "mock-value", "state" = "AVAILABLE", "system_tags" = {}, "time_created" = "mock-value", "time_updated" = "mock-value", "trigger_url" = "mock-value" }
  }
  mock_resource "oci_logging_log" {
    defaults = { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_LOG", "state" = "AVAILABLE", "tenancy_id" = "MOCK_OCID_MOCK", "time_created" = "mock-value", "time_last_modified" = "mock-value" }
  }
  mock_resource "oci_logging_log_group" {
    defaults = { "id" = "MOCK_OCID_GROUP", "state" = "AVAILABLE", "time_created" = "mock-value", "time_last_modified" = "mock-value" }
  }
  mock_resource "oci_ons_notification_topic" {
    defaults = { "api_endpoint" = "mock-value", "etag" = "mock-value", "id" = "MOCK_OCID_TOPIC", "short_topic_id" = "MOCK_OCID_MOCK", "state" = "AVAILABLE", "time_created" = "mock-value", "topic_id" = "MOCK_OCID_MOCK" }
  }
}
variables {
  compartment_ocid          = "MOCK_OCID_COMPARTMENT"
  project_name              = "compatibility"
  create_notification_topic = true
}

run "oci9_plan" {
  command = plan
}
