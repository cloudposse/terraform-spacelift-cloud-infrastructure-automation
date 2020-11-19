locals {
  // Use the provided config file path or default to the current dir
  stack_config_path = coalesce(var.stack_config_path, path.cwd)
  // Result ex: [gbl-audit.yaml, gbl-auto.yaml, gbl-dev.yaml, ...]
  config_filenames = fileset(local.stack_config_path, var.stack_config_pattern)
  // Result ex: [gbl-audit, gbl-auto, gbl-dev, ...]
  config_files = { for f in local.config_filenames : trimsuffix(basename(f), ".yaml") => yamldecode(file("${local.stack_config_path}/${f}")) }
  // Result ex: { gbl-audit = { globals = { ... }, terraform = { component1 = { vars = ... }, component2 = { vars = ... } } } }
  components = { for f in keys(local.config_files) : f => lookup(local.config_files[f], "components", {}) if f != "globals" }
  // Result ex: { globals = { ... } }
  globals = { for f in keys(local.config_files) : f => local.config_files[f] if f == "globals" }
}

module "global_context" {
  source = "./modules/context"

  enabled = true

  context_name          = "global"
  environment_variables = local.globals.globals
}

module "spacelift_environment" {
  source = "./modules/environment"

  for_each = local.components

  global_context_id  = module.global_context.context_id
  trigger_policy_id  = spacelift_policy.trigger_global.id
  push_policy_id     = spacelift_policy.push.id
  stack_config_name  = each.key
  environment_values = each.value.globals
  components         = local.components[each.key].terraform
  components_path    = var.components_path
  repository         = var.repository
  branch             = var.branch
}

# Define the global trigger policy that allows us to define custom triggers
resource "spacelift_policy" "trigger_global" {
  type = "TRIGGER"

  name = "Global Trigger Policy"
  body = file("${path.module}/policies/trigger-dependencies.rego")
}

# Define the environment trigger policy that causes stack executions when the parent environment config changes
resource "spacelift_policy" "trigger_env" {
  type = "TRIGGER"

  name = "Environment Trigger Policy"
  body = file("${path.module}/policies/trigger-environment.rego")
}

# Define the component config update trigger policy that causes stack executions when the component config changes
resource "spacelift_policy" "trigger_stack_config" {
  type = "TRIGGER"

  name = "Component Config Trigger Policy"
  body = file("${path.module}/policies/trigger-stack-config.rego")
}

# Define the global "git push" policy that causes executions on stacks when `<component_root>/*.tf` is modified
resource "spacelift_policy" "push" {
  type = "GIT_PUSH"

  name = "Component Push Policy"
  body = file("${path.module}/policies/push-stack.rego")
}


data "spacelift_current_stack" "this" {
  count = var.external_execution ? 0 : 1
}

# Attach the Environment Trigger Policy to the current stack
resource "spacelift_policy_attachment" "trigger_env" {
  count = var.external_execution ? 0 : 1

  policy_id = spacelift_policy.trigger_env.id
  stack_id  = data.spacelift_current_stack.this[0].id
}

# Attach the Component Config Trigger Policy to the current stack
resource "spacelift_policy_attachment" "trigger_stack_config" {
  count = var.external_execution ? 0 : 1

  policy_id = spacelift_policy.trigger_stack_config.id
  stack_id  = data.spacelift_current_stack.this[0].id
}