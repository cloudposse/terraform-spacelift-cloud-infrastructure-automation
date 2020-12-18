resource "spacelift_context" "default" {
  count = var.enabled ? 1 : 0

  name = var.context_name
}

resource "spacelift_environment_variable" "default" {
  for_each = var.enabled ? var.environment_variables : {}

  context_id = spacelift_context.default[0].id
  name       = "TF_VAR_${each.key}"
  value      = trim(each.value, "\"")
  write_only = false
}
