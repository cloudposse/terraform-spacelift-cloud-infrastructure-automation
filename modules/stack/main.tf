locals {
  triggers = [for trigger in var.triggers : "depends-on:${trigger}|state:FINISHED"]

  component_stack_deps = [for component_stack_dep in var.component_stack_deps : "stack-deps:${component_stack_dep}"]

  imports = [for import in var.imports : "import:${import}"]

  stack_config_name_parts = split("-", var.stack_config_name)

  folders = concat(
    format("folder:%s", try(local.stack_config_name_parts[0], "")),
    format("folder:%s/%s", try(local.stack_config_name_parts[0], ""), try(local.stack_config_name_parts[1], "")),
    format("folder:component/%s", var.logical_component)
  )

  labels = concat(
    local.triggers,
    local.folders,
    local.imports,
    local.component_stack_deps
  )
}

resource "spacelift_stack" "default" {
  count = var.enabled ? 1 : 0

  name           = var.stack_name
  administrative = false
  autodeploy     = var.autodeploy
  repository     = var.repository
  branch         = var.branch
  project_root   = var.component_root
  manage_state   = var.manage_state
  labels         = local.labels

  worker_pool_id      = var.worker_pool_id
  runner_image        = var.runner_image
  terraform_version   = var.terraform_version
  terraform_workspace = var.terraform_workspace
}

resource "spacelift_mounted_file" "stack_config" {
  count = var.enabled ? 1 : 0

  stack_id      = spacelift_stack.default[0].id
  relative_path = format("source/%s/spacelift.auto.tfvars.json", var.component_root)
  content = base64encode(jsonencode({
    for k, v in var.component_vars : k => jsondecode(v)
  }))

  write_only = false
}

resource "spacelift_environment_variable" "stack_name" {
  count = var.enabled ? 1 : 0

  stack_id   = spacelift_stack.default[0].id
  name       = "ATMOS_STACK"
  value      = var.stack_config_name
  write_only = false
}

resource "spacelift_environment_variable" "component_name" {
  count = var.enabled ? 1 : 0

  stack_id   = spacelift_stack.default[0].id
  name       = "ATMOS_COMPONENT"
  value      = var.logical_component
  write_only = false
}

resource "spacelift_policy_attachment" "push" {
  count = var.enabled ? 1 : 0

  policy_id = var.push_policy_id
  stack_id  = spacelift_stack.default[0].id
}

resource "spacelift_policy_attachment" "plan" {
  count = var.enabled ? 1 : 0

  policy_id = var.plan_policy_id
  stack_id  = spacelift_stack.default[0].id
}
