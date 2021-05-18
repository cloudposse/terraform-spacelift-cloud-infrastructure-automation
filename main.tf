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

  stack_name = each.key
  enabled    = each.value.enabled

  component_name      = each.value.component
  component_vars      = each.value.vars
  terraform_workspace = each.value.workspace
  labels              = each.value.labels

  autodeploy        = coalesce(try(each.value.settings.spacelift.autodeploy, null), var.autodeploy)
  component_root    = format("%s/%s", var.components_path, coalesce(each.value.base_component, each.value.component))
  branch            = coalesce(try(each.value.settings.spacelift.branch, null), var.branch)
  terraform_version = lookup(var.terraform_version_map, try(each.value.settings.spacelift.terraform_version, ""), var.terraform_version)

  repository     = var.repository
  manage_state   = var.manage_state
  worker_pool_id = var.worker_pool_id
  runner_image   = var.runner_image

  trigger_policy_id = spacelift_policy.trigger_global.id
  push_policy_id    = spacelift_policy.push.id
  plan_policy_id    = spacelift_policy.plan.id
}

# Define the global trigger policy that allows us to trigger on various context-level updates
resource "spacelift_policy" "trigger_global" {
  type = "TRIGGER"
  name = "Global Trigger Policy"
  body = file("${path.module}/policies/trigger-global.rego")
}

# Define the dependency trigger policy that allows us to define custom triggers
resource "spacelift_policy" "trigger_dependency" {
  type = "TRIGGER"
  name = "Stack Dependency Trigger Policy"
  body = file("${path.module}/policies/trigger-dependencies.rego")
}

# Define the automatic retries trigger policy that allows automatically restarting the failed run
resource "spacelift_policy" "trigger_retries" {
  type = "TRIGGER"
  name = "Failed Run Automatic Retries Trigger Policy"
  body = file("${path.module}/policies/trigger-retries.rego")
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

data "spacelift_current_stack" "this" {
  count = var.external_execution ? 0 : 1
}

# Attach the Environment Trigger Policy to the current stack
resource "spacelift_policy_attachment" "trigger_global" {
  count = var.external_execution || var.trigger_global_enabled == false ? 0 : 1

  policy_id = spacelift_policy.trigger_global.id
  stack_id  = data.spacelift_current_stack.this[0].id
}

# Attach the Retries Trigger Policy to the current stack
resource "spacelift_policy_attachment" "trigger_retries" {
  count = var.external_execution || var.trigger_retries_enabled == false ? 0 : 1

  policy_id = spacelift_policy.trigger_retries.id
  stack_id  = data.spacelift_current_stack.this[0].id
}
