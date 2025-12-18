include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = "prod"
}

terraform {
  source = "../../../modules/artifact-registry"
}

inputs = {
  project_id = "porfolio-480111"
  repositories = [
    {
      repository_id = "workout-backend-${local.env}"
      location      = "us-central1"
      format        = "DOCKER"
      description   = "Backend images (${local.env})"
      labels        = { env = local.env, app = "backend" }
    },
    {
      repository_id = "workout-frontend-${local.env}"
      location      = "us-central1"
      format        = "DOCKER"
      description   = "Frontend images (${local.env})"
      labels        = { env = local.env, app = "frontend" }
    }
  ]
}
