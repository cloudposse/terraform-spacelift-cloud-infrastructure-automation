locals {
  enabled                  = module.this.enabled
  aws_role_enabled         = local.enabled && var.aws_role_enabled
  drift_detection_enabled  = local.enabled && var.drift_detection_enabled
  stack_dependency_enabled = local.enabled && var.spacelift_stack_dependency_enabled
  webhook_enabled          = local.enabled && var.webhook_enabled

  map_of_labels_array = {
    for label in var.labels : split(":", label)[0] => split(":", label)[1]... if length(split(":", label)) > 1 # the ellipsis creates a group of values
  }
  depends_on_labels = try(local.map_of_labels_array["depends-on"], [])
  non_depends_on_labels = [
    for label in var.labels : label if !startswith(label, "depends-on:")
  ]
  labels = var.spacelift_stack_dependency_enabled ? local.non_depends_on_labels : var.labels
}

resource "spacelift_stack" "this" {
  count = local.enabled ? 1 : 0

  space_id = var.space_id

  name                         = var.stack_name
  description                  = var.description
  administrative               = var.administrative
  autodeploy                   = var.autodeploy
  autoretry                    = var.autoretry
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

# spacelift_stack_destructor is a special resource which, when deleted, will delete all resources in the stack.
# var.stack_destructor_enabled should not toggle the creation or destruction of this resource, because toggling it from
# 'true' to 'false' with the intention of disabling the stack destructor functionality will result in all of the
# resources in the stack being deleted. Instead, this resource is always created, with var.stack_destructor_enabled
# toggling its 'deactivated' attribute, which allows for the stack destructor functionality to be disabled. See:
# https://github.com/spacelift-io/terraform-provider-spacelift/blob/master/spacelift/resource_stack_destructor.go
resource "spacelift_stack_destructor" "this" {
  count = local.enabled ? 1 : 0

  stack_id    = spacelift_stack.this[0].id
  deactivated = !var.stack_destructor_enabled

  depends_on = [
    spacelift_mounted_file.stack_config,
    spacelift_environment_variable.stack_name,
    spacelift_environment_variable.component_name,
    spacelift_environment_variable.component_env_vars,
    spacelift_aws_role.this
  ]
}

resource "spacelift_aws_role" "this" {
  count = local.aws_role_enabled ? 1 : 0

  stack_id                       = spacelift_stack.this[0].id
  role_arn                       = var.aws_role_arn
  external_id                    = var.aws_role_external_id
  generate_credentials_in_worker = var.aws_role_generate_credentials_in_worker
}

resource "spacelift_drift_detection" "this" {
  count = local.drift_detection_enabled ? 1 : 0

  stack_id  = spacelift_stack.this[0].id
  reconcile = var.drift_detection_reconcile
  schedule  = var.drift_detection_schedule
  timezone  = var.drift_detection_timezone
}

resource "spacelift_webhook" "this" {
  count = local.webhook_enabled ? 1 : 0

  stack_id = spacelift_stack.this[0].id
  endpoint = var.webhook_endpoint
  secret   = var.webhook_secret
}

resource "spacelift_run" "this" {
  count = local.enabled && var.spacelift_run_enabled ? 1 : 0

  stack_id   = spacelift_stack.this[0].id
  commit_sha = var.commit_sha

  depends_on = [
    spacelift_mounted_file.stack_config,
    spacelift_environment_variable.stack_name,
    spacelift_environment_variable.component_name,
    spacelift_policy_attachment.this
  ]
}
