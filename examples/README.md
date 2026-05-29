# Examples

This directory contains runnable examples for **`terraform-oci-fk-devops`**.

## Example Overview

| Example | Description |
|--------|-------------|
| [01_project_with_logging_and_notifications](01_project_with_logging_and_notifications) | Creates a DevOps project with optional notifications and service logging |
| [02_project_with_repo_artifacts_and_environment](02_project_with_repo_artifacts_and_environment) | Adds mirrored repository, deploy artifacts, OKE deploy environment, and a trigger |

## How To Use

Each example is self-contained:

```bash
tofu init
tofu plan
```

Provide your own OCI values through `terraform.tfvars` or environment variables.

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [../LICENSE](../LICENSE) for details.

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
