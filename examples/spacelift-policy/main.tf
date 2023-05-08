provider "spacelift" {}

module "inline_policy" {
  source = "../../modules/spacelift-policy"

  policy_name = var.inline_policy_name
  type        = var.inline_policy_type
  body        = var.inline_policy_body
  labels      = var.inline_policy_labels
  space_id    = "root"
}

module "catalog_policy" {
  source = "../../modules/spacelift-policy"

  policy_name      = var.catalog_policy_name
  type             = var.catalog_policy_type
  body_url         = var.catalog_policy_body_url
  body_url_version = var.catalog_policy_body_url_version
  labels           = var.catalog_policy_labels
  space_id         = "root"
}
