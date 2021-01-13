module "environment_context" {
  source = "../context"

  enabled = true

  context_name          = var.stack_config_name
  environment_variables = var.environment_values
}

module "components" {
  source = "../stack"

  for_each = {
    for k, v in var.components : "${var.stack_config_name}-${k}" => merge({ "component" : k }, v)
  }

  enabled               = try(each.value.workspace_enabled, true)
  stack_name            = "${var.stack_config_name}-${each.value.component}"
  environment_name      = var.stack_config_name
  autodeploy            = coalesce(try(each.value.autodeploy, null), var.autodeploy)
  component_root        = format("%s/%s", var.components_path, try(each.value.custom_component_folder, each.value.component))
  repository            = var.repository
  branch                = coalesce(try(each.value.branch, null), var.branch)
  manage_state          = var.manage_state
  environment_variables = { for k, v in each.value.vars : k => jsonencode(v) }
  terraform_version     = coalesce(try(each.value.terraform_version, null), var.terraform_version)
  worker_pool_id        = var.worker_pool_id
  runner_image          = try(var.runner_image, null)
  triggers              = coalesce(try(each.value.triggers, null), [])
  trigger_policy_id     = var.trigger_policy_id
  push_policy_id        = var.push_policy_id
  global_context_id     = var.global_context_id
  parent_context_id     = module.environment_context.context_id
}
