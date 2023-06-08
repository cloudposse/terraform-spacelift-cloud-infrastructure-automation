module "example" {
  source = "../../modules/spacelift-stacks-from-atmos-config"

  imports_processing_enabled        = var.imports_processing_enabled
  stack_deps_processing_enabled     = var.stack_deps_processing_enabled
  component_deps_processing_enabled = var.component_deps_processing_enabled
  stack_config_path_template        = var.stack_config_path_template
  context_filters                   = var.context_filters
}
