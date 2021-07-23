provider "spacelift" {}

locals {
  config_filenames   = fileset(var.stack_config_path, "*.yaml")
  stack_config_files = [for f in local.config_filenames : f if(replace(f, "globals", "") == f)]
  stacks             = [for f in local.stack_config_files : trimsuffix(basename(f), ".yaml")]

  terraform_version_map = {
    "0.12"  = "0.12.30"
    "0.13"  = "0.13.7"
    "0.14"  = "0.14.11"
    "0.15"  = "0.15.4"
    "1.0.2" = "1.0.2"
  }

  terraform_version = "1.0.2"
}

module "example" {
  source = "../.."

  stacks             = local.stacks
  branch             = var.branch
  repository         = var.repository
  manage_state       = true
  external_execution = true

  # Global defaults for all Spacelift stacks created by this project
  terraform_version = local.terraform_version
  autodeploy        = var.autodeploy

  terraform_version_map = local.terraform_version_map

  imports_processing_enabled        = var.imports_processing_enabled
  stack_deps_processing_enabled     = var.stack_deps_processing_enabled
  component_deps_processing_enabled = var.component_deps_processing_enabled
  stack_config_path_template        = var.stack_config_path_template
  stack_config_path                 = var.stack_config_path
}
