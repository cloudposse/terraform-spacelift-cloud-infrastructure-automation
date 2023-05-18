# Convert infrastructure stacks from YAML configs into Spacelift stacks
module "spacelift_config" {
  source  = "cloudposse/stack-config/yaml//modules/spacelift"
  version = "0.22.3"

  stack_config_path_template = var.stack_config_path_template

  stack_deps_processing_enabled     = var.stack_deps_processing_enabled
  component_deps_processing_enabled = var.component_deps_processing_enabled
  imports_processing_enabled        = var.imports_processing_enabled

  context = module.this.context
}

locals {
  spacelift_stacks = {
    for k, v in module.spacelift_config.spacelift_stacks :
    k => v
    if
    (length(var.context_filters.namespaces) == 0 || contains(var.context_filters.namespaces, lookup(v.vars, "namespace", ""))) &&
    (length(var.context_filters.environments) == 0 || contains(var.context_filters.environments, lookup(v.vars, "environment", ""))) &&
    (length(var.context_filters.tenants) == 0 || contains(var.context_filters.tenants, lookup(v.vars, "tenant", ""))) &&
    (length(var.context_filters.stages) == 0 || contains(var.context_filters.stages, lookup(v.vars, "stage", ""))) &&
    (
      (try(var.context_filters.administrative, null) == null) ||                                                   # If not set return all stacks
      (var.context_filters.administrative == false && try(v.settings.spacelift.administrative, false) == false) || # if set to false return only non-administrative stacks
      (var.context_filters.administrative == true && try(v.settings.spacelift.administrative, false) == true)      # if set to true return only administrative stacks
    ) &&
    (
      (try(var.context_filters.root_administrative, null) == null) ||                                                        # If not set return all stacks
      (var.context_filters.root_administrative == false && try(v.settings.spacelift.root_administrative, false) == false) || # if set to false return only non-root admin stacks
      (var.context_filters.root_administrative == true && try(v.settings.spacelift.root_administrative, false) == true)      # if set to true return only root admin stacks
    ) &&
    (
      length(var.context_filters.tags) == 0 || (
        lookup(v.vars, "tags", null) != null &&
        contains([
          for filter_tag, filter_tag_val in var.context_filters.tags :
          lookup(lookup(v.vars, "tags", {}), filter_tag, null) == filter_tag_val
      ], true))
    )
  }
}
