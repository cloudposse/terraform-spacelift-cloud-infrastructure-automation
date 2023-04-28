locals {
}

resource "spacelift_space" "default" {
  count = var.dedicated_space_enabled ? 1 : 0

  name             = coalesce(var.space_name, var.component_name)
  parent_space_id  = var.parent_space_id
  inherit_entities = var.inherit_entities
  description      = var.description
  labels           = var.labels
}
