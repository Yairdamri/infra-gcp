include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = "dev"
}

# Environment-wide overrides or shared inputs can go here.
inputs = {
  env = local.env
}
