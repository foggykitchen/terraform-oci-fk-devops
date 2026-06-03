# terraform-oci-fk-devops

This repository contains a reusable **Terraform/OpenTofu module** and progressive examples for provisioning the **shared OCI DevOps control-plane resources** that sit around build and deployment workflows.

It is part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and is designed to compose cleanly with modules such as **`terraform-oci-fk-devops-pipeline`**, **`terraform-oci-fk-oke`**, **`terraform-oci-fk-ocir`**, and **`terraform-oci-fk-logging`**.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

---

## Used By

This module is used as a building block by the higher-level [FoggyKitchen Landing Zone Orchestrator](https://github.com/foggykitchen/foggykitchen-landing-zone-orchestrator), where it is composed into Azure, OCI, and multicloud landing zone patterns.

## Purpose

The goal of this module is to provide a **clean reusable core** for OCI DevOps:

- DevOps project
- optional notifications and service logging
- mirrored source repositories
- deploy artifacts
- deploy environments
- optional repository triggers for externally supplied build pipeline IDs

This module intentionally does **not** model the detailed build or deploy stage graph. That concern belongs in **`terraform-oci-fk-devops-pipeline`**.

---

## What the module does

The module creates:

- OCI DevOps project
- optional ONS topic and project notification binding
- optional OCI Logging log group and service log
- DevOps external connections
- mirrored DevOps repositories
- deploy artifacts
- OKE deploy environments
- DevOps triggers when the target build pipeline ID is supplied by the caller

The module intentionally does **not** create:

- build pipelines
- deploy pipelines
- build or deploy stages
- OKE clusters
- VCN, IAM, or compartment scaffolding

Those concerns belong in dedicated modules or orchestration layers.

---

## Repository Structure

```bash
terraform-oci-fk-devops/
├── examples/
│   ├── 01_project_with_logging_and_notifications/
│   ├── 02_project_with_repo_artifacts_and_environment/
│   └── README.md
├── main.tf
├── inputs.tf
├── outputs.tf
├── versions.tf
├── LICENSE
└── README.md
```

---

## Example Usage

### DevOps project with logging and notifications

```hcl
module "fk_devops" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-devops.git?ref=v0.1.0"

  compartment_ocid            = var.compartment_ocid
  project_name                = "fk-devops-demo"
  create_notification_topic   = true
  notification_topic_name     = "fk-devops-topic"
  create_log_group            = true
  create_project_service_log  = true
}
```

### DevOps project with mirrored repository and deploy environment

```hcl
module "fk_devops" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-devops.git?ref=v0.1.0"

  compartment_ocid = var.compartment_ocid
  project_name     = "fk-devops-demo"

  connections = {
    github = {
      access_token = var.github_pat_secret_ocid
    }
  }

  repositories = {
    app = {
      name           = "foggykitchen-hello-world"
      connection_key = "github"
      repository_url = "https://github.com/foggykitchen/foggykitchen-hello-world.git"
    }
  }

  deploy_environments = {
    oke = {
      display_name = "fk-oke-environment"
      cluster_id   = var.oke_cluster_id
    }
  }
}
```

---

## Module Inputs

### Core inputs

| Variable | Type | Required | Description |
|--------|------|----------|-------------|
| `compartment_ocid` | `string` | yes | OCI compartment OCID for the DevOps resources |
| `project_name` | `string` | yes | OCI DevOps project name |
| `project_description` | `string` | no | OCI DevOps project description |
| `create_notification_topic` | `bool` | no | Whether to create an ONS topic |
| `notification_topic_id` | `string` | no | Existing ONS topic OCID to attach |
| `create_log_group` | `bool` | no | Whether to create a log group |
| `log_group_id` | `string` | no | Existing log group OCID to reuse |
| `create_project_service_log` | `bool` | no | Whether to create the DevOps service log |

### Integration inputs

| Variable | Type | Required | Description |
|--------|------|----------|-------------|
| `connections` | `map(object)` | no | DevOps external connections such as GitHub access-token connectors |
| `repositories` | `map(object)` | no | Mirrored DevOps repositories |
| `deploy_artifacts` | `map(object)` | no | OCI DevOps deploy artifacts such as Docker images, Helm charts, and generic files |
| `deploy_environments` | `map(object)` | no | OCI DevOps deploy environments, currently focused on OKE cluster environments |
| `triggers` | `map(object)` | no | Repository triggers that launch externally supplied build pipeline IDs |

---

## Module Outputs

| Output | Description |
|--------|-------------|
| `project_id` | OCI DevOps project OCID |
| `notification_topic_id` | Effective ONS topic OCID |
| `log_group_id` | Effective log group OCID |
| `project_log_id` | OCI Logging service log OCID |
| `connection_ids` | Map of connection OCIDs |
| `repository_ids` | Map of repository OCIDs |
| `deploy_artifact_ids` | Map of deploy artifact OCIDs |
| `deploy_environment_ids` | Map of deploy environment OCIDs |
| `trigger_ids` | Map of trigger OCIDs |
| `trigger_urls` | Map of trigger URLs |

---

## Typical Integration Pattern

A typical OCI DevOps composition looks like this:

1. Create shared DevOps resources with `terraform-oci-fk-devops`
2. Create build and deploy pipeline graphs with `terraform-oci-fk-devops-pipeline`
3. Create supporting infrastructure with modules such as:
   - `terraform-oci-fk-oke`
   - `terraform-oci-fk-ocir`
   - `terraform-oci-fk-logging`
4. Orchestrate the full workflow in a lesson, blueprint, or landing zone composition

This keeps the long-lived control-plane resources separate from the faster-changing delivery logic.

When the build pipeline is created by `terraform-oci-fk-devops-pipeline`, define the trigger in that pipeline module instead. This avoids passing pipeline IDs back into the control-plane module and keeps trigger ownership next to the pipeline graph it starts.

---

## Examples

Runnable examples are available in [examples](examples/README.md).

They show:

- project creation with logging and notifications
- mirrored repository onboarding
- deploy artifacts and OKE environment binding

---

## Contributing

This project is open source. Contributions are welcome through pull requests.

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
