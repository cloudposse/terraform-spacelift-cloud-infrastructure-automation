data "spacelift_current_stack" "administrative" {
  count = var.external_execution ? 0 : 1
}

data "spacelift_stacks" "administrative" {
  count = var.external_execution ? 1 : 0

  name {
    any_of = [local.current_admin_stack_config.stack_name]
  }

  dynamic "labels" {
    for_each = toset(local.current_admin_stack_config.labels)
    iterator = label

    content {
      any_of = [label.key]
    }
  }
}

data "spacelift_current_space" "administrative" {
  count = var.external_execution ? 0 : 1
}

data "spacelift_contexts" "managed_space" {
  count = local.current_admin_stack_id != null ? 1 : 0

  labels {
    any_of = ["manager_admin_stack_id:${local.current_admin_stack_id}"]
  }
}

locals {
  current_admin_stack_config = [
    for k, v in local.all_spacelift_stacks :
    {
      key        = k
      value      = v
      labels     = v.labels
      stack_name = local.spacelift_stacks_extra_args[k].stack_name

      is_first_admin_stack = sha1(jsonencode(try(v.vars.tags, {}))) == sha1(jsonencode(var.tag_filters))
    }
    if sha1(jsonencode(try(v.vars.tag_filters, {}))) == sha1(jsonencode(var.tag_filters))
  ][0]

  current_admin_stack_id = try(
    data.spacelift_current_stack.administrative[0].id,
    try(data.spacelift_stacks.administrative[0].stacks[0].stack_id, null)
  )

  current_admin_stack = merge(local.current_admin_stack_config, {
    id = local.current_admin_stack_id

    space_id = try(
      data.spacelift_current_space.administrative[0].id,
      try(data.spacelift_stacks.administrative[0].stacks[0].space_id, null),
    )
    managed_space_id = try(data.spacelift_contexts.managed_space[0].contexts[0].space_id, "root")
  })
}
