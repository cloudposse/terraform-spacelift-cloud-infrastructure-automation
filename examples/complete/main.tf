provider "spacelift" {}

# Policies attached to a space created by this module

module "space" {
  source = "../../modules/spacelift-space"

  space_name                   = var.space_name
  description                  = var.description
  parent_space_id              = var.parent_space_id
  inherit_entities_from_parent = var.inherit_entities_from_parent
  labels                       = var.labels
}

module "inline_policy" {
  source = "../../modules/spacelift-policy"

  policy_name = var.inline_policy_name
  type        = var.inline_policy_type
  body        = var.inline_policy_body
  labels      = var.inline_policy_labels
  space_id    = module.space.space_id
}

module "catalog_policy" {
  source = "../../modules/spacelift-policy"

  policy_name      = var.catalog_policy_name
  type             = var.catalog_policy_type
  body_url         = var.catalog_policy_body_url
  body_url_version = var.catalog_policy_body_url_version
  labels           = var.catalog_policy_labels
  space_id         = module.space.space_id
}

module "file_policy" {
  source = "../../modules/spacelift-policy"

  policy_name    = var.file_policy_name
  type           = var.file_policy_type
  body_file_path = var.file_policy_body_path
  labels         = var.file_policy_labels
  space_id       = module.space.space_id
}
