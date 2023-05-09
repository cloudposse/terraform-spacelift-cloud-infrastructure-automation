locals {
  enabled = module.this.enabled
}

resource "spacelift_space" "this" {
  count = local.enabled ? 1 : 0

  name = var.space_name

  # Every account has a root space that serves as the root for the space tree.
  # Except for the root space, all the other spaces must define their parents.
  parent_space_id = var.parent_space_id

  description      = var.description
  inherit_entities = var.inherit_entities_from_parent
  labels           = var.labels
}
