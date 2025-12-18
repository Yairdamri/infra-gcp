include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = "stage"
}

terraform {
  source = "../../../modules/iam-gcp"
}

inputs = {
  project_id                        = "porfolio-480111"
  node_service_account_name         = "gke-node-sa-${local.env}"
  node_service_account_display_name = "GKE Node Service Account (${local.env})"
  node_service_account_description  = "Node SA for GKE (${local.env})"
  node_service_account_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/artifactregistry.reader",
  ]
}
