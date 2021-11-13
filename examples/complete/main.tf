provider "spacelift" {}

module "example" {
  source = "../.."

  branch             = var.branch
  repository         = var.repository
  manage_state       = true
  external_execution = true

  # Global defaults for all Spacelift stacks created by this project
  terraform_version = var.terraform_version
  autodeploy        = var.autodeploy

  terraform_version_map = var.terraform_version_map

  imports_processing_enabled        = var.imports_processing_enabled
  stack_deps_processing_enabled     = var.stack_deps_processing_enabled
  component_deps_processing_enabled = var.component_deps_processing_enabled
  stack_config_path_template        = var.stack_config_path_template

  worker_pool_id          = var.worker_pool_id
  worker_pool_name_id_map = var.worker_pool_name_id_map
}
