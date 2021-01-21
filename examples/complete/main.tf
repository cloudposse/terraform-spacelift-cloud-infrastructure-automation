provider "spacelift" {}

locals {
  config_filenames   = fileset(var.stack_config_path, "*.yaml")
  stack_config_files = [for f in local.config_filenames : f if(replace(f, "globals", "") == f)]
}

module "example" {
  source = "../.."

  stack_config_path  = var.stack_config_path
  stack_config_files = local.stack_config_files
  branch             = var.branch
  repository         = var.repository
  manage_state       = true
  terraform_version  = var.terraform_version
  external_execution = true
}
