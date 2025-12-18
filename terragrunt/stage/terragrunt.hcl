include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = "stage"
}

inputs = {
  env = local.env
}
