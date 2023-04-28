# CONTEXT:
## To better understand the functionality of this file, refer to the documentation at:
## https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs

####
## Provider without arguments and running inside Spacelift
####
## The `spacelift_current_stack` and `spacelift_current_space` data resources are designed to work within Spacelift 
## when the provider has been defined without arguments. For example:
##
##  provider "spacelift" {}
##
## If the provider is defined in this way and this code is executed inside of Spacelift, these data resources can retrieve the `current_admin_stack`'s configuration.
####

####
## Provider with arguments and running inside or outside of Spacelift
####
## However, if the provider is defined with arguments, for example:
##
##  provider "spacelift" {
##    api_key_endpoint = "https://your-account.app.spacelift.io"
##    api_key_id       = <SECRET>
##    api_key_secret   = <SECRET>
##  }
##
## using `spacelift_current_stack` and `spacelift_current_space` will result in an error similar to:
##
##  Error: unexpected token issuer api-key, is this a Spacelift run?
##
## This error would be through even if the code is getting executed inside of Spacelift.
## In this case, `spacelift_stacks` and `spacelift_contexts` data resources should be used instead to retrieve 
## information about `current_admin_stack`'s configuration.
####

# GET CURRENT STACK ID:
## Provider without arguments and running inside Spacelift
data "spacelift_current_stack" "administrative" {
  count = var.external_execution ? 0 : 1
}

## Provider with arguments and running inside or outside of Spacelift
data "spacelift_stacks" "administrative" {

  count = var.external_execution ? 1 : 0

  name {
    any_of = [local.current_admin_stack_config.stack_name]
  }

  administrative {
    equals = true
  }

  dynamic "labels" {
    for_each = toset(local.current_admin_stack_config.labels)
    iterator = label

    content {
      any_of = [label.key]
    }
  }

}

# GET CURRENT STACK SPACE ID:
## Provider without arguments and running inside Spacelift
data "spacelift_current_space" "administrative" {
  count = var.external_execution ? 0 : 1
}

## Provider with arguments and running inside or outside of Spacelift
data "spacelift_contexts" "managed_space" {
  labels {
    any_of = ["manager_admin_stack_id:${local.current_admin_stack_id}"]
  }
}

# OUTPUT:
locals {
  current_admin_stack_config = [
    for k, v in local.all_spacelift_stacks :
    {
      key        = k
      value      = v
      labels     = v.labels
      stack_name = local.spacelift_stacks_extra_args[k].stack_name

      # The first_admin_stack is responsible for creating its own stack and space. This is different from 
      # other admin stacks, which have their stacks and spaces created by 
      # the first_admin_stack's or previous_admin_stacks' runs.
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

    ##
    # In this paragraph, `space` refers to the ID in the `space_id` variable and
    # `managed_space` refers to the ID in the `managed_space_id` variable.
    # `current_admin_stack` resides in `space` while `non_admin_stacks` resides in `managed_space`.
    # Both `managed_space` and `non_admin_stacks` are managed (creation, update, and deletion) by `current_admin_stack`.
    # Typically, `space` must be the root space, otherwise `current_admin_stack` won't be able to manage
    # `managed_space` or `policies`.
    space_id = try(
      data.spacelift_current_space.administrative[0].id,
      try(data.spacelift_stacks.administrative[0].stacks[0].space_id, null),
    )
    managed_space_id = try(data.spacelift_contexts.managed_space.contexts[0].space_id, "root")
    ##
  })
}

