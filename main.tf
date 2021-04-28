locals {
  // Use the provided config file path or default to the current dir
  stack_config_path = coalesce(var.stack_config_path, path.cwd)
}

module "yaml_stack_config" {
  for_each = toset(var.stack_config_files)

  source  = "cloudposse/stack-config/yaml"
  version = "0.15.3"

  stack_config_local_path = local.stack_config_path
  stacks                  = [trimsuffix(each.key, ".yaml")]

  process_component_stack_deps = true

  context = module.this.context
}

module "spacelift_environment" {
  source = "./modules/environment"

  for_each = toset(var.stack_config_files)

  trigger_policy_id = join("", spacelift_policy.trigger_global.*.id)
  push_policy_id    = spacelift_policy.push.id
  plan_policy_id    = spacelift_policy.plan.id
  stack_config_name = trimsuffix(each.key, ".yaml")
  components        = try(module.yaml_stack_config[each.key].config.0.components.terraform, {})
  imports           = [for import in try(module.yaml_stack_config[each.key].config.0.imports, []) : format("%s/%s.yaml", local.stack_config_path, import)]
  components_path   = var.components_path
  stack_config_path = local.stack_config_path
  repository        = var.repository
  branch            = var.branch
  manage_state      = var.manage_state
  worker_pool_id    = var.worker_pool_id
  runner_image      = var.runner_image
  terraform_version = var.terraform_version
  autodeploy        = var.autodeploy

  terraform_version_map        = var.terraform_version_map
  process_component_stack_deps = var.process_component_stack_deps
}

# Define the global trigger policy that allows us to trigger on various context-level updates
resource "spacelift_policy" "trigger_global" {
  count = var.trigger_global_enabled ? 1 : 0

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
  count = var.trigger_retries_enabled ? 1 : 0

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
  count = !var.external_execution && var.trigger_global_enabled ? 1 : 0

  policy_id = join("", spacelift_policy.trigger_global.*.id)
  stack_id  = data.spacelift_current_stack.this[0].id
}

# Attach the Retries Trigger Policy to the current stack
resource "spacelift_policy_attachment" "trigger_global" {
  count = !var.external_execution && var.trigger_retries_enabled ? 1 : 0

  policy_id = join("", spacelift_policy.trigger_retries.*.id)
  stack_id  = data.spacelift_current_stack.this[0].id
}
