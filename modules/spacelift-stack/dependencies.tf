resource "spacelift_stack_dependency" "default" {
  for_each            = local.stack_dependency_enabled ? toset(local.depends_on_labels) : []
  stack_id            = spacelift_stack.this[0].id
  depends_on_stack_id = each.value
}
