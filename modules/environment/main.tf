module "stacks" {
  source = "../stack"

  for_each = {
    for k, v in var.components :
    format("%s-%s", var.stack_config_name, k) => merge({ "component_name" : k }, v)
  }

  enabled              = try(each.value.settings.spacelift.workspace_enabled, false)
  stack_name           = each.key
  stack_config_name    = var.stack_config_name
  logical_component    = each.value.component_name
  component_name       = coalesce(each.value.component, each.value.component_name)
  autodeploy           = coalesce(try(each.value.settings.spacelift.autodeploy, null), var.autodeploy)
  component_root       = format("%s/%s", var.components_path, coalesce(each.value.component, each.value.component_name))
  repository           = var.repository
  branch               = coalesce(try(each.value.settings.spacelift.branch, null), var.branch)
  manage_state         = var.manage_state
  component_vars       = { for k, v in try(each.value.vars, {}) : k => jsonencode(v) }
  component_stack_deps = try(each.value.stacks, [])
  imports              = var.imports
  terraform_version    = lookup(var.terraform_version_map, try(each.value.settings.spacelift.terraform_version, ""), try(each.value.settings.spacelift.terraform_version, var.terraform_version))
  terraform_workspace  = each.value.workspace
  worker_pool_id       = var.worker_pool_id
  runner_image         = try(var.runner_image, null)
  triggers             = coalesce(try(each.value.settings.spacelift.triggers, null), [])
  trigger_policy_id    = var.trigger_policy_id
  push_policy_id       = var.push_policy_id
  plan_policy_id       = var.plan_policy_id
}
