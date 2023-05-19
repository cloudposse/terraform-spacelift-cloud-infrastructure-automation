locals {
  component_env = { for k, v in var.component_env : k => v if local.enabled == true }
}

resource "spacelift_environment_variable" "stack_name" {
  count = local.enabled ? 1 : 0

  stack_id   = spacelift_stack.this[0].id
  name       = "ATMOS_STACK"
  value      = var.atmos_stack_name
  write_only = false
}

resource "spacelift_environment_variable" "component_name" {
  count = local.enabled ? 1 : 0

  stack_id   = spacelift_stack.this[0].id
  name       = "ATMOS_COMPONENT"
  value      = var.component_name
  write_only = false
}

resource "spacelift_environment_variable" "component_env_vars" {
  for_each = local.component_env

  stack_id   = spacelift_stack.this[0].id
  name       = each.key
  value      = each.value
  write_only = false
}
