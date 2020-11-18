module "environment_context" {
  source = "../context"

  enabled = true

  context_name          = var.stack_config_name
  environment_variables = var.environment_values
}

module "components" {
  source = "../stack"

  for_each = var.components

  enabled               = try(each.value.workspace_enabled, false)
  stack_name            = "${var.stack_config_name}-${each.key}"
  environment_name      = var.stack_config_name
  autodeploy            = try(each.value.autodeploy, true)
  component_root        = format("%s/%s", var.components_path, try(each.value.custom_component_folder, each.key))
  repository            = var.repository
  branch                = var.branch
  manage_state          = var.manage_state
  environment_variables = each.value.vars
  terraform_version     = try(each.value.terraform_version, null)
  triggers              = coalesce(try(each.value.triggers, null), [])
  trigger_policy_id     = var.trigger_policy_id
  push_policy_id        = var.push_policy_id
  global_context_id     = var.global_context_id
  parent_context_id     = module.environment_context.context_id
}
