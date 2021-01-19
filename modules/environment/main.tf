module "stacks" {
  source = "../stack"

  for_each = { for k, v in var.components : "${var.environment_values.environment}-${var.environment_values.stage}-${k}" => merge({ "component" : k }, v) }

  enabled               = try(each.value.workspace_enabled, false)
  stack_name            = each.key
  autodeploy            = coalesce(try(each.value.autodeploy, null), var.autodeploy)
  component_root        = format("%s/%s", var.components_path, try(each.value.custom_component_folder, each.value.component))
  repository            = var.repository
  branch                = coalesce(try(each.value.branch, null), var.branch)
  manage_state          = var.manage_state
  environment_variables = { for k, v in merge(var.environment_values, try(each.value.vars, {})) : k => jsonencode(v) }
  terraform_version     = coalesce(try(each.value.terraform_version, null), var.terraform_version)
  worker_pool_id        = var.worker_pool_id
  runner_image          = try(var.runner_image, null)
  triggers              = coalesce(try(each.value.triggers, null), [])
  trigger_policy_id     = var.trigger_policy_id
  push_policy_id        = var.push_policy_id
}
