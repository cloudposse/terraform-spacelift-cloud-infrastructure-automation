#provider "spacelift" {}

locals {
  enabled             = module.this.enabled
  is_body_from_url    = local.enabled && var.body_url != null
  is_body_from_file   = local.enabled && var.body_file_path != null
  body_url            = local.is_body_from_url ? format(var.body_url, var.body_url_version) : null
  body_from_url       = local.is_body_from_url ? data.http.this[0].response_body : null
  body_from_file      = local.is_body_from_file ? file(var.body_file_path) : null
  body                = coalesce(local.body_from_url, local.body_from_file, var.body)
}

resource "spacelift_policy" "this" {
  count = local.enabled ? 1 : 0

  name     = var.policy_name
  body     = local.body
  type     = var.type
  labels   = var.labels
  space_id = var.space_id

  lifecycle {
    precondition {
      condition     = var.body != null || var.body_url != null || var.body_file_path != null
      error_message = "A policy body must be specified either with `var.body`, `var.body_url`, or `var.body_file_path`."
    }

    precondition {
      condition     = (
        var.body != null && var.body_url == null && var.body_file_path == null) || (
        var.body == null && var.body_url != null && var.body_file_path == null) || (
        var.body == null && var.body_url == null && var.body_file_path != null)
      error_message = "Only one of `var.body`, `var.body_url`, or `var.body_file_path` should be specified."
    }
  }
}

data "http" "this" {
  count = local.is_body_from_url ? 1 : 0
  url   = local.body_url
}
