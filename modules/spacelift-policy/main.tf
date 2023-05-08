#provider "spacelift" {}

locals {
  is_body_from_url = module.this.enabled && var.body_url != null
  body_url         = local.is_body_from_url ? format(var.body_url, var.body_url_version) : null
  body             = local.is_body_from_url ? data.http.this[0].response_body : var.body
}

resource "spacelift_policy" "this" {
  count = module.this.enabled ? 1 : 0

  name     = var.policy_name
  body     = local.body
  type     = var.type
  labels   = var.labels
  space_id = var.space_id

  lifecycle {
    precondition {
      condition     = var.body != null || var.body_url != null
      error_message = "A policy body must be specified either with `var.body` or `var.body_url`."
    }

    precondition {
      condition     = (var.body != null && var.body_url == null) || (var.body == null && var.body_url != null)
      error_message = "Only one of `var.body` and `var.body_url` should be specified."
    }
  }
}

data "http" "this" {
  count = local.is_body_from_url ? 1 : 0
  url   = local.body_url
}
