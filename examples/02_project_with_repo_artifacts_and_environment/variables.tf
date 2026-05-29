variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "region" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "project_name" {
  type    = string
  default = "fk-devops-demo"
}

variable "github_pat_secret_ocid" {
  type = string
}

variable "repository_name" {
  type    = string
  default = "foggykitchen-hello-world"
}

variable "repository_url" {
  type = string
}

variable "image_uri" {
  type = string
}

variable "oke_cluster_id" {
  type = string
}

variable "build_pipeline_id" {
  type = string
}
