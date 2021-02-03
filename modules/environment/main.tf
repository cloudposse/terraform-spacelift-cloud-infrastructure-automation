module "vars" {
  source = "cloudposse/stack-config/yaml//modules/vars"
  version     = "0.6.0"

  config         = module.stack_config.config
  component      = "my-vpc"
}

module "stacks" {
  source = "../stack"

  for_each = {
    for k, v in var.components :
    format("%s-%s", var.stack_config_name, k) => merge({ "component_name" : k }, v)
  }

  enabled           = try(each.value.workspace_enabled, false)
  stack_name        = each.key
  autodeploy        = coalesce(try(each.value.autodeploy, null), var.autodeploy)
  component_root    = format("%s/%s", var.components_path, try(each.value.component, each.value.component_name))
  repository        = var.repository
  branch            = coalesce(try(each.value.branch, null), var.branch)
  manage_state      = var.manage_state
  terraform_version = coalesce(try(each.value.terraform_version, null), var.terraform_version)
  worker_pool_id    = var.worker_pool_id
  runner_image      = try(var.runner_image, null)
  triggers          = coalesce(try(each.value.triggers, null), [])
  trigger_policy_id = var.trigger_policy_id
  push_policy_id    = var.push_policy_id

  component_vars = {
    for k, v in merge(var.stack_vars, try(each.value.vars, {}), try(var.components[each.value["component"]]["vars"], {})) : 
    k => jsonencode(v)
  }
}
