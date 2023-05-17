
locals {
  map_of_labels_array = {
    for label in var.labels : split(":", label)[0] => split(":", label)[1]... if length(split(":", label)) > 1 # the ellipsis creates a group of values
  }
  depends_on_labels = try(local.map_of_labels_array["depends-on"], [])
  non_depends_on_labels = [
    for label in var.labels : label if ! startswith(label, "depends-on:")
  ]
}

resource "spacelift_stack_dependency" "default" {
  for_each            = var.enabled && var.spacelift_stack_dependency_enabled ? toset(local.depends_on_labels) : []
  stack_id            = spacelift_stack.default[0].id
  depends_on_stack_id = each.value
}
