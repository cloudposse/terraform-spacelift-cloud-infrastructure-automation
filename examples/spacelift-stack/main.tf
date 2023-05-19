provider "spacelift" {}

module "stack" {
  source = "../../modules/spacelift-stack"

  stack_name               = var.stack_name
  component_name           = var.component_name
  atmos_stack_name         = var.atmos_stack_name
  description              = var.description
  administrative           = var.administrative
  autodeploy               = var.autodeploy
  repository               = var.repository
  branch                   = var.branch
  component_root           = var.component_root
  manage_state             = var.manage_state
  labels                   = var.labels
  local_preview_enabled    = var.local_preview_enabled
  stack_destructor_enabled = var.stack_destructor_enabled
  terraform_version        = var.terraform_version
}

