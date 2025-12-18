include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = "prod"
}

inputs = {
  env = local.env
}
