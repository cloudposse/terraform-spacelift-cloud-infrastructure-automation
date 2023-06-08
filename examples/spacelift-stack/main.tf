provider "spacelift" {}

module "stack" {
  source = "../../modules/spacelift-stack"

  administrative           = var.administrative
  atmos_stack_name         = var.atmos_stack_name
  autodeploy               = var.autodeploy
  branch                   = var.branch
  component_env            = var.component_env
  component_name           = var.component_name
  component_root           = var.component_root
  component_vars           = var.component_vars
  description              = var.description
  labels                   = var.labels
  local_preview_enabled    = var.local_preview_enabled
  manage_state             = var.manage_state
  repository               = var.repository
  space_id                 = var.space_id
  stack_destructor_enabled = var.stack_destructor_enabled
  stack_name               = var.stack_name
  terraform_version        = var.terraform_version
}

