module "space" {
  source = "../../modules/spacelift-space"

  space_name                   = var.space_name
  description                  = var.description
  parent_space_id              = var.parent_space_id
  inherit_entities_from_parent = var.inherit_entities_from_parent
  labels                       = var.labels
}

