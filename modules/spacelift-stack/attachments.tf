locals {
  # Create a map of the given context_attachments so we have the index (for priority) and frienly names for the resource
  # paths.
  context_attachments_map = {
    for index, context_id in var.context_attachments :
    context_id => index if local.enabled == true
  }

  policy_attachments_map = {
    for index, policy_id in var.policy_ids :
    policy_id => index if local.enabled == true
  }
}

resource "spacelift_context_attachment" "this" {
  for_each = local.context_attachments_map

  context_id = each.key
  stack_id   = spacelift_stack.this[0].id
  priority   = each.value
}

resource "spacelift_policy_attachment" "this" {
  for_each = local.policy_attachments_map

  policy_id = each.key
  stack_id  = spacelift_stack.this[0].id
}

resource "spacelift_mounted_file" "stack_config" {
  count = local.enabled ? 1 : 0

  stack_id      = spacelift_stack.this[0].id
  relative_path = format("source/%s/spacelift.auto.tfvars.json", var.component_root)
  content       = base64encode(jsonencode(var.component_vars))
  write_only    = false
}
