include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env        = "stage"
  project_id = "porfolio-480111"
}

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    network_self_link        = ""
    subnet_self_link         = ""
    pods_secondary_range     = { name = "pods", cidr = "10.20.0.0/18" }
    services_secondary_range = { name = "services", cidr = "10.30.0.0/22" }
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "iam" {
  config_path = "../iam"

  mock_outputs = {
    node_service_account_email = "mock-node-sa@${local.project_id}.iam.gserviceaccount.com"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

terraform {
  source = "../../../modules/gke"
}

inputs = {
  project_id                        = local.project_id
  cluster_name                      = "workout-gke-${local.env}"
  location                          = "us-central1-a"
  network                           = dependency.network.outputs.network_self_link
  subnetwork                        = dependency.network.outputs.subnet_self_link
  pods_secondary_range_name         = dependency.network.outputs.pods_secondary_range.name
  services_secondary_range_name     = dependency.network.outputs.services_secondary_range.name
  master_ipv4_cidr_block            = "172.16.0.0/28"
  release_channel                   = "REGULAR"
  kubernetes_version                = null
  enable_private_nodes              = true
  enable_private_endpoint           = false
  enable_master_authorized_networks = false
  master_authorized_networks_cidrs  = []
  workload_pool                     = "${local.project_id}.svc.id.goog"
  node_pool_name                    = "spot-pool-${local.env}"
  node_locations                    = []
  node_machine_type                 = "e2-standard-4"
  node_disk_size_gb                 = 25
  node_disk_type                    = "pd-balanced"
  node_image_type                   = "COS_CONTAINERD"
  node_preemptible                  = true
  node_min_count                    = 1
  node_max_count                    = 3
  node_service_account_email        = dependency.iam.outputs.node_service_account_email
  node_labels                       = { env = local.env }
  node_tags                         = []
}
