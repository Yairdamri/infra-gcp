# terraform {
#   # Apply a little retry/backoff for common transient errors.
#   retryable_errors = [
#     "dial tcp .*: i/o timeout",
#     "Error 500",
#     "TLS handshake timeout",
#   ]
#   retry_max_attempts = 3
#   retry_sleep_interval_sec = 5
# }

# Remote state for all stacks; adjust bucket/prefix to match your GCS state bucket.
remote_state {
  backend = "gcs"
  config = {
    bucket  = "tf-state-buckett"                         # TODO: ensure this bucket exists
    prefix  = "terragrunt/${path_relative_to_include()}" # isolates state per env/stack
    project = "porfolio-480111"
    # optional: credentials, impersonate_service_account, kms_key_name
  }
}

# Common locals/inputs for all environments. Override in env terragrunt.hcl as needed.
locals {
  project_id = "porfolio-480111" # TODO: change if needed
  region     = "us-central1"
  zone       = "us-central1-a"
}

generate "provider" {
  path      = "provider.auto.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "google" {
  project = "${local.project_id}"
  region  = "${local.region}"
  zone    = "${local.zone}"
}

provider "google-beta" {
  project = "${local.project_id}"
  region  = "${local.region}"
  zone    = "${local.zone}"
}
EOF
}

# Ensure a backend block exists so remote_state can take effect.
generate "backend" {
  path      = "backend.auto.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "gcs" {}
}
EOF
}

# Make locals accessible to children.
inputs = {
  project_id = local.project_id
  region     = local.region
  zone       = local.zone
}
