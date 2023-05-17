locals {
  component_env = { for k, v in var.component_env : k => v if var.enabled == true }

  # Create a map of the given context_attachments so we have the index (for priority)
  # and pretty names for the resource paths.
  context_attachments_map = {
    for idx, context_id in var.context_attachments :
    context_id => idx
  }

  labels = var.spacelift_stack_dependency_enabled ? local.non_depends_on_labels : var.labels
}

resource "spacelift_stack" "default" {
  count = var.enabled ? 1 : 0

  space_id = try(spacelift_space.default[0].id, var.space_id)

  name                         = var.stack_name
  description                  = var.description
  administrative               = var.administrative
  autodeploy                   = var.autodeploy
  repository                   = var.repository
  branch                       = var.branch
  project_root                 = var.component_root
  manage_state                 = var.manage_state
  labels                       = local.labels
  enable_local_preview         = var.local_preview_enabled
  terraform_smart_sanitization = var.terraform_smart_sanitization

  worker_pool_id      = var.worker_pool_id
  runner_image        = var.runner_image
  terraform_version   = var.terraform_version
  terraform_workspace = var.terraform_workspace

  after_apply    = var.after_apply
  after_destroy  = var.after_destroy
  after_init     = var.after_init
  after_perform  = var.after_perform
  after_plan     = var.after_plan
  before_apply   = var.before_apply
  before_destroy = var.before_destroy
  before_init    = var.before_init
  before_perform = var.before_perform
  before_plan    = var.before_plan

  protect_from_deletion = var.protect_from_deletion

  dynamic "azure_devops" {
    for_each = var.azure_devops != null ? [true] : []
    content {
      project = lookup(var.azure_devops, "project", null)
    }
  }

  dynamic "bitbucket_cloud" {
    for_each = var.bitbucket_cloud != null ? [true] : []
    content {
      namespace = lookup(var.bitbucket_cloud, "namespace", null)
    }
  }

  dynamic "bitbucket_datacenter" {
    for_each = var.bitbucket_datacenter != null ? [true] : []
    content {
      namespace = lookup(var.bitbucket_datacenter, "namespace", null)
    }
  }

  dynamic "cloudformation" {
    for_each = var.cloudformation != null ? [true] : []
    content {
      entry_template_file = lookup(var.cloudformation, "entry_template_file", null)
      region              = lookup(var.cloudformation, "region", null)
      stack_name          = lookup(var.cloudformation, "stack_name", null)
      template_bucket     = lookup(var.cloudformation, "template_bucket", null)
    }
  }

  dynamic "github_enterprise" {
    for_each = var.github_enterprise != null ? [true] : []
    content {
      namespace = lookup(var.github_enterprise, "namespace", null)
    }
  }

  dynamic "gitlab" {
    for_each = var.gitlab != null ? [true] : []
    content {
      namespace = lookup(var.gitlab, "namespace", null)
    }
  }

  dynamic "pulumi" {
    for_each = var.pulumi != null ? [true] : []
    content {
      login_url  = lookup(var.pulumi, "login_url", null)
      stack_name = lookup(var.pulumi, "stack_name", null)
    }
  }

  dynamic "showcase" {
    for_each = var.showcase != null ? [true] : []
    content {
      namespace = lookup(var.showcase, "namespace", null)
    }
  }
}

resource "spacelift_run" "default" {
  count = var.enabled && var.spacelift_run_enabled ? 1 : 0

  stack_id   = spacelift_stack.default[0].id
  commit_sha = var.commit_sha

  depends_on = [
    spacelift_mounted_file.stack_config[0],
    spacelift_environment_variable.stack_name[0],
    spacelift_environment_variable.component_name[0],
    spacelift_policy_attachment.default[0]
  ]
}

resource "spacelift_mounted_file" "stack_config" {
  count = var.enabled ? 1 : 0

  stack_id      = spacelift_stack.default[0].id
  relative_path = format("source/%s/spacelift.auto.tfvars.json", var.component_root)
  content       = base64encode(jsonencode(var.component_vars))
  write_only    = false
}

resource "spacelift_environment_variable" "stack_name" {
  count = var.enabled ? 1 : 0

  stack_id   = spacelift_stack.default[0].id
  name       = "ATMOS_STACK"
  value      = var.infrastructure_stack_name
  write_only = false
}

resource "spacelift_environment_variable" "component_name" {
  count = var.enabled ? 1 : 0

  stack_id   = spacelift_stack.default[0].id
  name       = "ATMOS_COMPONENT"
  value      = var.component_name
  write_only = false
}

resource "spacelift_environment_variable" "component_env_vars" {
  for_each = local.component_env

  stack_id   = spacelift_stack.default[0].id
  name       = each.key
  value      = each.value
  write_only = false
}

resource "spacelift_webhook" "default" {
  count = var.enabled && var.webhook_enabled ? 1 : 0

  stack_id = spacelift_stack.default[0].id
  endpoint = var.webhook_endpoint
  secret   = var.webhook_secret
}

resource "spacelift_policy_attachment" "default" {
  # It does not work with `for_each`
  # throws the error: The "for_each" value depends on resource attributes that cannot be determined until apply, so Terraform cannot predict how many instances will be created
  count = length(var.policy_ids)

  policy_id = var.policy_ids[count.index]
  stack_id  = spacelift_stack.default[0].id
}

resource "spacelift_drift_detection" "default" {
  count = var.enabled && var.drift_detection_enabled ? 1 : 0

  stack_id  = spacelift_stack.default[0].id
  reconcile = var.drift_detection_reconcile
  schedule  = var.drift_detection_schedule
}

resource "spacelift_aws_role" "default" {
  count = var.enabled && var.aws_role_enabled ? 1 : 0

  stack_id                       = spacelift_stack.default[0].id
  role_arn                       = var.aws_role_arn
  external_id                    = var.aws_role_external_id
  generate_credentials_in_worker = var.aws_role_generate_credentials_in_worker
}

# spacelift_stack_destructor is a special resource which, when deleted, will delete all resources in the stack.
# var.stack_destructor_enabled should not toggle the creation or destruction of this resource, because toggling it from
# 'true' to 'false' with the intention of disabling the stack destructor functionality will result in all of the resources
# in the stack being deleted. Instead, this resource is always created, with var.stack_destructor_enabled toggling its
# 'deactivated' attribute, which allows for the stack destructor functionality to be disabled.
# See: https://github.com/spacelift-io/terraform-provider-spacelift/blob/master/spacelift/resource_stack_destructor.go
resource "spacelift_stack_destructor" "default" {
  count = var.enabled ? 1 : 0

  stack_id    = spacelift_stack.default[0].id
  deactivated = ! var.stack_destructor_enabled

  depends_on = [
    spacelift_mounted_file.stack_config,
    spacelift_environment_variable.stack_name,
    spacelift_environment_variable.component_name,
    spacelift_environment_variable.component_env_vars,
    spacelift_policy_attachment.default,
    spacelift_aws_role.default
  ]
}

resource "spacelift_context_attachment" "attachment" {
  for_each = local.context_attachments_map

  context_id = each.key
  stack_id   = spacelift_stack.default[0].id
  priority   = each.value
}

resource "spacelift_space" "default" {
  count = var.dedicated_space_enabled ? 1 : 0

  name             = coalesce(var.space_name, var.component_name)
  parent_space_id  = var.parent_space_id
  inherit_entities = var.inherit_entities
  description      = var.description
  labels           = var.labels
}
