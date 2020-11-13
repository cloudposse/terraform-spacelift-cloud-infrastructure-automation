module "environment_context" {
  source = "../context"

  enabled = true

  context_name          = "${var.config_name}-globals"
  environment_variables = var.environment_values
}

module "projects" {
  source = "../stack"

  for_each = var.projects

  enabled               = try(each.value.workspace_enabled, false)
  stack_name            = "${var.config_name}-${each.key}"
  environment_name      = var.config_name
  autodeploy            = try(each.value.autodeploy, true)
  project_root          = format("%s/%s", var.projects_path, try(each.value.custom_project_folder, each.key))
  repository            = var.repository
  branch                = var.branch
  manage_state          = var.manage_state
  environment_variables = each.value.vars
  terraform_version     = try(each.value.terraform_version, null)
  triggers              = try(each.value.triggers, [])
  trigger_policy_id     = var.trigger_policy_id
  push_policy_id        = var.push_policy_id
  global_context_id     = var.global_context_id
  parent_context_id     = module.environment_context.context_id
}
