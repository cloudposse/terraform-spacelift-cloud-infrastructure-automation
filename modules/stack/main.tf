locals {
  component_env = { for k, v in var.component_env : k => v if var.enabled == true }
  policy_ids    = { for v in var.policy_ids : v => v if var.enabled == true }
}

resource "spacelift_stack" "default" {
  count = var.enabled ? 1 : 0

  name                 = var.stack_name
  administrative       = false
  autodeploy           = var.autodeploy
  repository           = var.repository
  branch               = var.branch
  project_root         = var.component_root
  manage_state         = var.manage_state
  labels               = var.labels
  enable_local_preview = var.local_preview_enabled

  worker_pool_id      = var.worker_pool_id
  runner_image        = var.runner_image
  terraform_version   = var.terraform_version
  terraform_workspace = var.terraform_workspace
}

resource "spacelift_mounted_file" "stack_config" {
  count = var.enabled ? 1 : 0

  stack_id      = spacelift_stack.default[0].id
  relative_path = format("source/%s/spacelift.auto.tfvars.json", var.component_root)
  content       = base64encode(jsonencode(var.component_vars))
  write_only    = false
}

resource "spacelift_environment_variable" "stack_name" {
  count = var.enabled ? 1 : 0

  stack_id   = spacelift_stack.default[0].id
  name       = "ATMOS_STACK"
  value      = var.infrastructure_stack_name
  write_only = false
}

resource "spacelift_environment_variable" "component_name" {
  count = var.enabled ? 1 : 0

  stack_id   = spacelift_stack.default[0].id
  name       = "ATMOS_COMPONENT"
  value      = var.component_name
  write_only = false
}

resource "spacelift_environment_variable" "component_env_vars" {
  for_each = local.component_env

  stack_id   = spacelift_stack.default[0].id
  name       = each.key
  value      = each.value
  write_only = false
}

resource "spacelift_webhook" "default" {
  count = var.enabled && var.webhook_enabled ? 1 : 0

  stack_id = spacelift_stack.default[0].id
  endpoint = var.webhook_endpoint
  secret   = var.webhook_secret
}

resource "spacelift_policy_attachment" "default" {
  for_each = local.policy_ids

  policy_id = each.value
  stack_id  = spacelift_stack.default[0].id
}
