module "fk_devops" {
  source = "../.."

  compartment_ocid           = var.compartment_ocid
  project_name               = var.project_name
  create_notification_topic  = true
  notification_topic_name    = "${var.project_name}-topic"
  create_log_group           = true
  create_project_service_log = true
}
