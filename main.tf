# Create default policies
resource "spacelift_policy" "default" {
  for_each = toset(var.default_policies)

  type = upper(split(".", each.key)[0])
  name = format("%s %s Policy", upper(split(".", each.key)[0]), title(replace(split(".", each.key)[1], "-", "")))
  body = file(format("%s/%s/%s.rego", path.module, var.default_policies_path, each.key))
}

# Convert infrastructure stacks from YAML configs into Spacelift stacks
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

  policy_ids = [for i in try(each.value.settings.spacelift.default_policies_enabled, var.default_policies_enabled) : spacelift_policy.default[i].id]
}

# `administrative` policies are always attached to the `administrative` stack
# `spacelift_current_stack` is the administrative stack that manages all other infrastructure stacks
data "spacelift_current_stack" "this" {
  count = var.external_execution ? 0 : 1
}

# global administrative trigger policy that allows us to trigger a stack right after it gets created
resource "spacelift_policy" "trigger_administrative" {
  type = "TRIGGER"
  name = "Global Administrative Trigger Policy"
  body = file(format("%s/%s/trigger.administrative.rego", path.module, var.default_policies_path))
}

# Attach the global trigger policy to the current administrative stack
resource "spacelift_policy_attachment" "trigger_administrative" {
  count = var.external_execution || var.administrative_trigger_policy_enabled == false ? 0 : 1

  policy_id = spacelift_policy.trigger_administrative.id
  stack_id  = data.spacelift_current_stack.this[0].id
}
