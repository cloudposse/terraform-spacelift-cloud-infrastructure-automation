provider "spacelift" {}

locals {
  config_filenames   = fileset(var.stack_config_path, "*.yaml")
  stack_config_files = [for f in local.config_filenames : f if(replace(f, "globals", "") == f)]

  terraform_version_map = {
    "0.12" = "0.12.30"
    "0.13" = "0.13.6"
    "0.14" = "0.14.7"
  }
}

module "example" {
  source = "../.."

  stack_config_files = local.stack_config_files
  branch             = var.branch
  repository         = var.repository
  manage_state       = true
  external_execution = true

  # Global defaults for all Spacelift stacks created by this project.
  terraform_version = var.terraform_version
  autodeploy        = var.autodeploy

  terraform_version_map = local.terraform_version_map
}
