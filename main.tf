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

  autodeploy           = coalesce(try(each.value.settings.spacelift.autodeploy, null), var.autodeploy)
  branch               = coalesce(try(each.value.settings.spacelift.branch, null), var.branch)
  repository           = coalesce(try(each.value.settings.spacelift.repository, null), var.repository)
  terraform_version    = lookup(var.terraform_version_map, try(each.value.settings.spacelift.terraform_version, ""), var.terraform_version)
  component_root       = format("%s/%s", var.components_path, coalesce(each.value.base_component, each.value.component))
  enable_local_preview = try(each.value.settings.spacelift.enable_local_preview, null) != null ? each.value.settings.spacelift.enable_local_preview : var.enable_local_preview

  manage_state   = var.manage_state
  worker_pool_id = var.worker_pool_id
  runner_image   = var.runner_image

  access_policy_id  = var.access_policy_id_override != null ? var.access_policy_id_override : spacelift_policy.access.id
  push_policy_id    = var.push_policy_id_override != null ? var.push_policy_id_override : spacelift_policy.push.id
  plan_policy_id    = var.plan_policy_id_override != null ? var.plan_policy_id_override : spacelift_policy.plan.id
  trigger_policy_id = var.trigger_policy_id != null ? var.trigger_policy_id : spacelift_policy.trigger_dependency.id

  webhook_enabled  = try(each.value.settings.spacelift.webhook_enabled, null) != null ? each.value.settings.spacelift.webhook_enabled : var.webhook_enabled
  webhook_endpoint = try(each.value.settings.spacelift.webhook_endpoint, null) != null ? each.value.settings.spacelift.webhook_endpoint : var.webhook_endpoint
  webhook_secret   = var.webhook_secret
}

# Define the global "access" policy
resource "spacelift_policy" "access" {
  type = "ACCESS"
  name = "Global Access Policy"
  body = file("${path.module}/policies/access-global.rego")
}

# Define the global "git push" policy that causes executions on stacks when `<component_root>/*.tf` is modified
resource "spacelift_policy" "push" {
  type = "GIT_PUSH"
  name = "Global Push Policy"
  body = file("${path.module}/policies/push-global.rego")
}

# Define a global "plan" policy that stops and waits for confirmation after a plan fails
resource "spacelift_policy" "plan" {
  type = "PLAN"
  name = "Global Plan Policy"
  body = file("${path.module}/policies/plan-global.rego")
}

# Define the dependency trigger policy that allows us to define custom triggers
resource "spacelift_policy" "trigger_dependency" {
  type = "TRIGGER"
  name = "Stack Dependency Trigger Policy"
  body = file("${path.module}/policies/trigger-dependencies.rego")
}

# Define the global trigger policy that allows us to trigger on various context-level updates
resource "spacelift_policy" "trigger_global" {
  type = "TRIGGER"
  name = "Global Trigger Policy"
  body = file("${path.module}/policies/trigger-global.rego")
}

# Define the automatic retries trigger policy that allows automatically restarting the failed run
resource "spacelift_policy" "trigger_retries" {
  type = "TRIGGER"
  name = "Failed Run Automatic Retries Trigger Policy"
  body = file("${path.module}/policies/trigger-retries.rego")
}

# `spacelift_current_stack` is the administrative stack that manages all other infrastructure stacks
data "spacelift_current_stack" "this" {
  count = var.external_execution ? 0 : 1
}

# Attach the global trigger policy to the current stack
resource "spacelift_policy_attachment" "trigger_global" {
  count = var.external_execution || var.trigger_global_enabled == false ? 0 : 1

  policy_id = spacelift_policy.trigger_global.id
  stack_id  = data.spacelift_current_stack.this[0].id
}

# Attach the retries trigger policy to the current stack
resource "spacelift_policy_attachment" "trigger_retries" {
  count = var.external_execution || var.trigger_retries_enabled == false ? 0 : 1

  policy_id = spacelift_policy.trigger_retries.id
  stack_id  = data.spacelift_current_stack.this[0].id
}
