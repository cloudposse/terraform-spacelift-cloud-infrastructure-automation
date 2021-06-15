locals {
  access_policy_id             = var.access_policy_id != null ? var.access_policy_id : join("", spacelift_policy.access.*.id)
  push_policy_id               = var.push_policy_id != null ? var.push_policy_id : join("", spacelift_policy.push.*.id)
  plan_policy_id               = var.plan_policy_id != null ? var.plan_policy_id : join("", spacelift_policy.plan.*.id)
  trigger_dependency_policy_id = var.trigger_dependency_policy_id != null ? var.trigger_dependency_policy_id : join("", spacelift_policy.trigger_dependency.*.id)
  trigger_retries_policy_id    = var.trigger_retries_policy_id != null ? var.trigger_retries_policy_id : join("", spacelift_policy.trigger_retries.*.id)
}

module "yaml_stack_config" {
  source  = "cloudposse/stack-config/yaml//modules/spacelift"
  version = "0.17.0"

  stacks                            = var.stacks
  stack_deps_processing_enabled     = var.stack_deps_processing_enabled
  component_deps_processing_enabled = var.component_deps_processing_enabled
  imports_processing_enabled        = var.imports_processing_enabled
  stack_config_path_template        = var.stack_config_path_template
  stack_config_path                 = var.stack_config_path

  context = module.this.context
}

module "stacks" {
  source = "./modules/stack"

  for_each = module.yaml_stack_config.spacelift_stacks

  enabled                   = each.value.enabled
  stack_name                = each.key
  infrastructure_stack_name = each.value.stack
  component_name            = each.value.component
  component_vars            = each.value.vars
  component_env             = each.value.env
  terraform_workspace       = each.value.workspace
  labels                    = each.value.labels

  autodeploy            = coalesce(try(each.value.settings.spacelift.autodeploy, null), var.autodeploy)
  branch                = coalesce(try(each.value.settings.spacelift.branch, null), var.branch)
  repository            = coalesce(try(each.value.settings.spacelift.repository, null), var.repository)
  terraform_version     = lookup(var.terraform_version_map, try(each.value.settings.spacelift.terraform_version, ""), var.terraform_version)
  component_root        = format("%s/%s", var.components_path, coalesce(each.value.base_component, each.value.component))
  local_preview_enabled = try(each.value.settings.spacelift.local_preview_enabled, null) != null ? each.value.settings.spacelift.local_preview_enabled : var.local_preview_enabled

  manage_state   = var.manage_state
  worker_pool_id = var.worker_pool_id
  runner_image   = var.runner_image

  webhook_enabled  = try(each.value.settings.spacelift.webhook_enabled, null) != null ? each.value.settings.spacelift.webhook_enabled : var.webhook_enabled
  webhook_endpoint = try(each.value.settings.spacelift.webhook_endpoint, null) != null ? each.value.settings.spacelift.webhook_endpoint : var.webhook_endpoint
  webhook_secret   = var.webhook_secret

  policy_ids = []
}

# "access" policy
resource "spacelift_policy" "access" {
  count = var.access_policy_id == null ? 1 : 0

  type = "ACCESS"
  name = "Access Policy"
  body = file("${path.module}/policies/access.rego")
}

# "git push" policy that causes executions on stacks when `<component_root>/*.tf` is modified
resource "spacelift_policy" "push" {
  count = var.push_policy_id == null ? 1 : 0

  type = "GIT_PUSH"
  name = "Push Policy"
  body = file("${path.module}/policies/push.rego")
}

# "plan" policy that stops and waits for confirmation after a plan fails
resource "spacelift_policy" "plan" {
  count = var.plan_policy_id == null ? 1 : 0

  type = "PLAN"
  name = "Plan Policy"
  body = file("${path.module}/policies/plan.rego")
}

# dependency trigger policy that allows to define custom triggers
resource "spacelift_policy" "trigger_dependency" {
  count = var.trigger_dependency_policy_id == null ? 1 : 0

  type = "TRIGGER"
  name = "Stack Dependency Trigger Policy"
  body = file("${path.module}/policies/trigger-dependencies.rego")
}

# automatic retries trigger policy that allows automatically restarting the failed run
resource "spacelift_policy" "trigger_retries" {
  count = var.trigger_retries_policy_id == null ? 1 : 0

  type = "TRIGGER"
  name = "Failed Run Automatic Retries Trigger Policy"
  body = file("${path.module}/policies/trigger-retries.rego")
}

# global administrative trigger policy that allows us to trigger a stack right after it gets created
resource "spacelift_policy" "trigger_administrative" {
  type = "TRIGGER"
  name = "Global Administrative Trigger Policy"
  body = file("${path.module}/policies/trigger-administrative.rego")
}

# `spacelift_current_stack` is the administrative stack that manages all other infrastructure stacks
data "spacelift_current_stack" "this" {
  count = var.external_execution ? 0 : 1
}

# Attach the global trigger policy to the current administrative stack
resource "spacelift_policy_attachment" "trigger_administrative" {
  count = var.external_execution || var.trigger_administrative_enabled == false ? 0 : 1

  policy_id = spacelift_policy.trigger_administrative.id
  stack_id  = data.spacelift_current_stack.this[0].id
}
