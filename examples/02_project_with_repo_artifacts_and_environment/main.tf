module "fk_devops" {
  source = "../.."

  compartment_ocid = var.compartment_ocid
  project_name     = var.project_name

  connections = {
    github = {
      access_token = var.github_pat_secret_ocid
    }
  }

  repositories = {
    app = {
      name           = var.repository_name
      connection_key = "github"
      repository_url = var.repository_url
    }
  }

  deploy_artifacts = {
    app_image = {
      display_name               = "${var.project_name}-image"
      argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
      deploy_artifact_type       = "DOCKER_IMAGE"
      source = {
        type           = "OCIR"
        image_uri      = var.image_uri
        image_digest   = " "
        repository_key = "app"
      }
    }
  }

  deploy_environments = {
    oke = {
      display_name = "${var.project_name}-oke-env"
      cluster_id   = var.oke_cluster_id
    }
  }

  triggers = {
    app = {
      display_name      = "${var.project_name}-trigger"
      repository_key    = "app"
      build_pipeline_id = var.build_pipeline_id
      branch            = "main"
    }
  }
}
