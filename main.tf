# Create default policies (Rego defined in the catalog in this module)
resource "spacelift_policy" "default" {
  for_each = toset(var.policies_available)

  type = upper(split(".", each.key)[0])
  name = format("%s %s Policy", upper(split(".", each.key)[0]), title(replace(split(".", each.key)[1], "-", "")))
  body = file(format("%s/%s/%s.rego", path.module, var.policies_path, each.key))
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

locals {
  # Find Rego policies defined in YAML config in all stacks
  distinct_policy_names = distinct(compact(flatten([
    for k, v in module.yaml_stack_config.spacelift_stacks : try(v.settings.spacelift.policies_by_name_enabled, []) if v.enabled
  ])))
}

# Create custom policies (Rego defined externally in the caller code)
resource "spacelift_policy" "custom" {
  for_each = toset(local.distinct_policy_names)

  type = upper(split(".", each.key)[0])
  name = format("%s %s Policy", upper(split(".", each.key)[0]), title(replace(split(".", each.key)[1], "-", "")))
  body = file(format("%s/%s.rego", var.policies_by_name_path, each.key))
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

  # Policies to attach to the stack (internally created + additional external provided by IDs + additional external created by this module from external Rego files)
  policy_ids = concat(
    [for i in try(each.value.settings.spacelift.policies_enabled, var.policies_enabled) : spacelift_policy.default[i].id],
    [for i in try(each.value.settings.spacelift.policies_by_name_enabled, []) : spacelift_policy.custom[i].id],
    var.policies_by_id_enabled
  )

  drift_detection_enabled   = try(each.value.settings.spacelift.drift_detection_enabled, null) != null ? each.value.settings.spacelift.drift_detection_enabled : var.drift_detection_enabled
  drift_detection_reconcile = try(each.value.settings.spacelift.drift_detection_reconcile, null) != null ? each.value.settings.spacelift.drift_detection_reconcile : var.drift_detection_reconcile
  drift_detection_schedule  = try(each.value.settings.spacelift.drift_detection_schedule, null) != null ? each.value.settings.spacelift.drift_detection_schedule : var.drift_detection_schedule
}

# `administrative` policies are always attached to the `administrative` stack
# `spacelift_current_stack` is the administrative stack that manages all other infrastructure stacks
data "spacelift_current_stack" "administrative" {
  count = var.external_execution ? 0 : 1
}

# global administrative trigger policy that allows us to trigger a stack right after it gets created
resource "spacelift_policy" "trigger_administrative" {
  type = "TRIGGER"
  name = "Global Administrative Trigger Policy"
  body = file(format("%s/%s/trigger.administrative.rego", path.module, var.policies_path))
}

# Attach the global trigger policy to the current administrative stack
resource "spacelift_policy_attachment" "trigger_administrative" {
  count = var.external_execution || var.administrative_trigger_policy_enabled == false ? 0 : 1

  policy_id = spacelift_policy.trigger_administrative.id
  stack_id  = data.spacelift_current_stack.administrative[0].id
}

resource "spacelift_drift_detection" "drift_detection_administrative" {
  count = var.external_execution || var.administrative_stack_drift_detection_enabled == false ? 0 : 1

  stack_id  = data.spacelift_current_stack.administrative[0].id
  reconcile = var.administrative_stack_drift_detection_reconcile
  schedule  = var.administrative_stack_drift_detection_schedule
}
