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
  terraform_version = var.terraform_version
}

resource "spacelift_mounted_file" "stack_config" {
  count = var.enabled ? 1 : 0

  stack_id      = spacelift_stack.default[0].id
  relative_path = format("source/%s/spacelift.auto.tfvars.json", var.component_root)
  content = base64encode(var.component_vars)

  write_only = false
}

resource "spacelift_policy_attachment" "push" {
  count = var.enabled ? 1 : 0

  policy_id = var.push_policy_id
  stack_id  = spacelift_stack.default[0].id
}
