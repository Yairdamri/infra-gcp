include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = "dev"
}

terraform {
  source = "../../../modules/artifact-registry"
}

inputs = {
  project_id = "porfolio-480111"
  repositories = [
    {
      repository_id = "workout-backend"
      location      = "us-central1"
      format        = "DOCKER"
      description   = "Backend images"
      labels        = { env = local.env, app = "backend" }
    },
    {
      repository_id = "workout-frontend"
      location      = "us-central1"
      format        = "DOCKER"
      description   = "Frontend images"
      labels        = { env = local.env, app = "frontend" }
    }
  ]
}
