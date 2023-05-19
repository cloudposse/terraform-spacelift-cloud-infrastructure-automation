module "example" {
  source = "../../modules/spacelift-config-from-atmos-config"

  imports_processing_enabled        = var.imports_processing_enabled
  stack_deps_processing_enabled     = var.stack_deps_processing_enabled
  component_deps_processing_enabled = var.component_deps_processing_enabled
  stack_config_path_template        = var.stack_config_path_template

  context_filters = {
    # tenants        = ["tenant1"]
    # environments   = ["ue2"]
    # stages         = ["prod"]
    # administrative = true
    tags = {
      "Foo" = "Bar"
    }
  }
}

# output "stacks" {
#   value = module.example.stacks
# }

output "spacelift_stacks" {
  value = module.example.spacelift_stacks
}
