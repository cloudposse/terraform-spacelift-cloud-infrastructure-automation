locals {
  // Use the provided config file path or default to the current dir
  stack_config_path = coalesce(var.stack_config_path, path.cwd)

  components  = module.yaml_config.map_configs.components.terraform
  config_vars = module.yaml_config.map_configs.vars
}

module "yaml_config" {
  source = "cloudposse/config/yaml"
  version     = "0.4.0"

  map_config_local_base_path = local.stack_config_path

  map_config_paths = [
    var.stack_config_pattern
  ]

  context = module.this.context
}

module "stacks" {
  source = "./modules/stack"

  for_each = local.components

  enabled               = try(each.value.workspace_enabled, true)
  stack_name            = "${local.config_vars.environment}-foo-${each.key}"
  autodeploy            = coalesce(try(each.value.autodeploy, null), var.autodeploy)
  component_root        = format("%s/%s", var.components_path, try(each.value.custom_component_folder, each.key))
  repository            = var.repository
  branch                = coalesce(try(each.value.branch, null), var.branch)
  manage_state          = var.manage_state
  environment_variables = { for k, v in merge(local.config_vars, try(each.value.vars, {})) : k => jsonencode(v) }
  terraform_version     = coalesce(try(each.value.terraform_version, null), var.terraform_version)
  worker_pool_id        = var.worker_pool_id
  runner_image          = try(var.runner_image, null)
  triggers              = coalesce(try(each.value.triggers, null), [])
  trigger_policy_id     = spacelift_policy.trigger_dependency.id
  push_policy_id        = spacelift_policy.push.id
}


# # Define the global trigger policy that allows us to trigger on various context-level updates
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

# # Define the global "git push" policy that causes executions on stacks when `<component_root>/*.tf` is modified
resource "spacelift_policy" "push" {
  type = "GIT_PUSH"

  name = "Component Push Policy"
  body = file("${path.module}/policies/push-stack.rego")
}

# Disabled for local testing
# data "spacelift_current_stack" "this" {
#   count = var.external_execution ? 0 : 1
# }

# # Attach the Environment Trigger Policy to the current stack
# resource "spacelift_policy_attachment" "trigger_global" {
#   count = var.external_execution ? 0 : 1

#   policy_id = spacelift_policy.trigger_global.id
#   stack_id  = data.spacelift_current_stack.this[0].id
# }
