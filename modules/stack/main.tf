resource "spacelift_stack" "default" {
  count = var.enabled ? 1 : 0

  name           = var.stack_name
  administrative = false
  autodeploy     = var.autodeploy
  repository     = var.repository
  branch         = var.branch
  project_root   = var.component_root
  manage_state   = var.manage_state
  labels = [
    for trigger in var.triggers : "depends-on:${trigger}|state:FINISHED"
  ]

  worker_pool_id    = var.worker_pool_id
  runner_image      = var.runner_image
  before_init       = [ for command in var.before_init : format(command, var.environment_name) ]
  terraform_version = var.terraform_version
}

module "component_context" {
  source = "../context"

  enabled               = var.enabled
  context_name          = var.stack_name
  environment_variables = var.environment_variables
}

resource "spacelift_context_attachment" "global" {
  count = var.enabled ? 1 : 0

  context_id = var.global_context_id
  stack_id   = spacelift_stack.default[0].id
  priority   = 20
}

resource "spacelift_context_attachment" "parent" {
  count = var.enabled ? 1 : 0

  context_id = var.parent_context_id
  stack_id   = spacelift_stack.default[0].id
  priority   = 10
}

resource "spacelift_context_attachment" "component" {
  count = var.enabled ? 1 : 0

  context_id = module.component_context.context_id
  stack_id   = spacelift_stack.default[0].id
  priority   = 0
}

resource "spacelift_policy_attachment" "push" {
  count = var.enabled ? 1 : 0

  policy_id = var.push_policy_id
  stack_id  = spacelift_stack.default[0].id
}
