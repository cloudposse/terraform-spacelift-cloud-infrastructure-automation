# Create default policies (Rego defined in the catalog in this module)
resource "spacelift_policy" "default" {
  for_each = toset(var.policies_available)

  type = upper(split(".", each.key)[0])
  name = format("%s %s Policy", upper(split(".", each.key)[0]), title(replace(split(".", each.key)[1], "-", " ")))
  body = file(format("%s/%s/%s.rego", path.module, var.policies_path, each.key))

  space_id = var.attachment_space_id
}

# Convert infrastructure stacks from YAML configs into Spacelift stacks
module "spacelift_config" {
  source  = "cloudposse/stack-config/yaml//modules/spacelift"
  version = "0.22.3"

  stack_config_path_template = var.stack_config_path_template

  stack_deps_processing_enabled     = var.stack_deps_processing_enabled
  component_deps_processing_enabled = var.component_deps_processing_enabled
  imports_processing_enabled        = var.imports_processing_enabled

  context = module.this.context
}

locals {
  stack_context_variables_enabled = length(keys(var.stack_context_variables)) > 0

  # if context_filters are provided, then filter for them, otherwise return the original stacks unfiltered
  spacelift_stacks = {
    for k, v in module.spacelift_config.spacelift_stacks :
    k => v
    if
    (lookup(var.context_filters, "namespaces", null) == null || contains(lookup(var.context_filters, "namespaces", [lookup(v.vars, "namespace", "")]), lookup(v.vars, "namespace", ""))) &&
    (lookup(var.context_filters, "tenants", null) == null || contains(lookup(var.context_filters, "tenants", [lookup(v.vars, "tenant", "")]), lookup(v.vars, "tenant", ""))) &&
    (lookup(var.context_filters, "environments", null) == null || contains(lookup(var.context_filters, "environments", [lookup(v.vars, "environment", "")]), lookup(v.vars, "environment", ""))) &&
    (lookup(var.context_filters, "stages", null) == null || contains(lookup(var.context_filters, "stages", [lookup(v.vars, "stage", "")]), lookup(v.vars, "stage", ""))) &&
    (
      var.tag_filters == null || length(var.tag_filters) == 0 || lookup(v.vars, "tags", null) == null || contains([
        for i, j in var.tag_filters :
        lookup(lookup(v.vars, "tags", {}), i, null) == j
      ], true)
    )
  }

  # Find Rego policies defined in YAML config in all stacks
  distinct_policy_names = distinct(compact(flatten([
    for k, v in local.spacelift_stacks : try(v.settings.spacelift.policies_by_name_enabled, var.policies_by_name_enabled) if v.enabled
  ])))

  # Concatenate labels with infracost if it's enabled
  labels = var.infracost_enabled ? concat(var.labels, ["infracost"]) : var.labels
  # Note, it appears that spacelift stacks can create the trigger.dependency policy with
  # and without a suffix of -policy. Since it can exist twice, we need to exclude
  # both variants.
  excluded_policies = var.spacelift_stack_dependency_enabled ? ["trigger-dependencies", "trigger-dependencies-policy"] : []
  stack_policies = {
    for k, v in local.spacelift_stacks :
    k => concat(
      [
        for i in try(v.settings.spacelift.policies_enabled, var.policies_enabled) : (
          spacelift_policy.default[i].id
        ) if ! contains(local.excluded_policies, i)
      ],
      [
        for i in try(v.settings.spacelift.policies_by_name_enabled, var.policies_by_name_enabled) : (
          spacelift_policy.custom[i].id
        ) if ! contains(local.excluded_policies, i)
      ],
      [
        for i in try(v.settings.spacelift.policies_by_id_enabled, var.policies_by_id_enabled) : (
          i
        ) if ! contains(local.excluded_policies, i)
      ]
    )
  }

}

# Create custom policies (Rego defined externally in the caller code)
resource "spacelift_policy" "custom" {
  for_each = toset(local.distinct_policy_names)

  type = upper(split(".", each.key)[0])
  name = format("%s %s Policy", upper(split(".", each.key)[0]), title(replace(split(".", each.key)[1], "-", " ")))
  body = file(format("%s/%s.rego", var.policies_by_name_path, each.key))

  space_id = var.attachment_space_id
}

module "stacks" {
  source = "./modules/stack"

  for_each = local.spacelift_stacks

  space_id = coalesce(
    try(each.value.settings.spacelift.space_id, var.stacks_space_id),
    try(data.spacelift_current_space.administrative[0].id, "legacy"),
  )

  enabled                            = each.value.enabled
  dedicated_space_enabled            = try(each.value.settings.spacelift.dedicated_space_enabled, false)
  space_name                         = try(each.value.settings.spacelift.space_name, null)
  parent_space_id                    = try(each.value.settings.spacelift.parent_space_id, null)
  inherit_entities                   = try(each.value.settings.spacelift.inherit_entities, false)
  stack_name                         = try(each.value.settings.spacelift.ui_stack_name, try(each.value.settings.spacelift.stack_name, each.key))
  infrastructure_stack_name          = each.value.stack
  component_name                     = each.value.component
  component_vars                     = each.value.vars
  component_env                      = each.value.env
  terraform_workspace                = each.value.workspace
  terraform_smart_sanitization       = try(each.value.settings.spacelift.terraform_smart_sanitization, false)
  spacelift_stack_dependency_enabled = var.spacelift_stack_dependency_enabled

  labels = (
    try(each.value.settings.spacelift.administrative, null) != null ? each.value.settings.spacelift.administrative : var.administrative
    ) ? concat(
    local.labels,
    var.admin_labels,
    try(each.value.labels, [])
    ) : concat(
    local.labels,
    var.non_admin_labels,
    try(each.value.labels, [])
  )

  description           = try(each.value.settings.spacelift.description, null)
  context_attachments   = compact(concat([join("", spacelift_context.default.*.id)], coalesce(try(each.value.settings.spacelift.context_attachments, null), var.context_attachments)))
  autodeploy            = coalesce(try(each.value.settings.spacelift.autodeploy, null), var.autodeploy)
  branch                = coalesce(try(each.value.settings.spacelift.branch, null), var.branch)
  repository            = coalesce(try(each.value.settings.spacelift.repository, null), var.repository)
  commit_sha            = var.commit_sha != null ? var.commit_sha : try(each.value.settings.spacelift.commit_sha, null)
  spacelift_run_enabled = coalesce(try(each.value.settings.spacelift.spacelift_run_enabled, null), var.spacelift_run_enabled)
  terraform_version     = lookup(var.terraform_version_map, try(each.value.settings.spacelift.terraform_version, ""), var.terraform_version)
  component_root        = coalesce(try(each.value.settings.spacelift.component_root, null), format("%s/%s", var.components_path, coalesce(each.value.base_component, each.value.component)))
  local_preview_enabled = try(each.value.settings.spacelift.local_preview_enabled, null) != null ? each.value.settings.spacelift.local_preview_enabled : var.local_preview_enabled
  administrative        = try(each.value.settings.spacelift.administrative, null) != null ? each.value.settings.spacelift.administrative : var.administrative

  azure_devops         = try(each.value.settings.spacelift.azure_devops, null)
  bitbucket_cloud      = try(each.value.settings.spacelift.bitbucket_cloud, null)
  bitbucket_datacenter = try(each.value.settings.spacelift.bitbucket_datacenter, null)
  cloudformation       = try(each.value.settings.spacelift.cloudformation, null)
  github_enterprise    = try(each.value.settings.spacelift.github_enterprise, null)
  gitlab               = try(each.value.settings.spacelift.gitlab, null)
  pulumi               = try(each.value.settings.spacelift.pulumi, null)
  showcase             = try(each.value.settings.spacelift.showcase, null)

  manage_state = try(each.value.settings.spacelift.manage_state, var.manage_state)
  runner_image = try(each.value.settings.spacelift.runner_image, var.runner_image)

  webhook_enabled  = try(each.value.settings.spacelift.webhook_enabled, null) != null ? each.value.settings.spacelift.webhook_enabled : var.webhook_enabled
  webhook_endpoint = try(each.value.settings.spacelift.webhook_endpoint, null) != null ? each.value.settings.spacelift.webhook_endpoint : var.webhook_endpoint
  webhook_secret   = var.webhook_secret

  # Policies to attach to the stack (internally created + additional external provided by IDs + additional external created by this module from external Rego files)
  policy_ids                = local.stack_policies[each.key]
  drift_detection_enabled   = try(each.value.settings.spacelift.drift_detection_enabled, null) != null ? each.value.settings.spacelift.drift_detection_enabled : var.drift_detection_enabled
  drift_detection_reconcile = try(each.value.settings.spacelift.drift_detection_reconcile, null) != null ? each.value.settings.spacelift.drift_detection_reconcile : var.drift_detection_reconcile
  drift_detection_schedule  = try(each.value.settings.spacelift.drift_detection_schedule, null) != null ? each.value.settings.spacelift.drift_detection_schedule : var.drift_detection_schedule

  aws_role_enabled     = try(each.value.settings.spacelift.aws_role_enabled, null) != null ? each.value.settings.spacelift.aws_role_enabled : var.aws_role_enabled
  aws_role_arn         = try(each.value.settings.spacelift.aws_role_arn, null) != null ? each.value.settings.spacelift.aws_role_arn : var.aws_role_arn
  aws_role_external_id = try(each.value.settings.spacelift.aws_role_external_id, null) != null ? each.value.settings.spacelift.aws_role_external_id : var.aws_role_external_id

  aws_role_generate_credentials_in_worker = try(each.value.settings.spacelift.aws_role_generate_credentials_in_worker, null) != null ? (
    each.value.settings.spacelift.aws_role_generate_credentials_in_worker
  ) : var.aws_role_generate_credentials_in_worker

  stack_destructor_enabled = try(each.value.settings.spacelift.stack_destructor_enabled, null) != null ? each.value.settings.spacelift.stack_destructor_enabled : var.stack_destructor_enabled

  after_apply    = try(each.value.settings.spacelift.after_apply, null) != null ? each.value.settings.spacelift.after_apply : var.after_apply
  after_destroy  = try(each.value.settings.spacelift.after_destroy, null) != null ? each.value.settings.spacelift.after_destroy : var.after_destroy
  after_init     = try(each.value.settings.spacelift.after_init, null) != null ? each.value.settings.spacelift.after_init : var.after_init
  after_perform  = try(each.value.settings.spacelift.after_perform, null) != null ? each.value.settings.spacelift.after_perform : var.after_perform
  after_plan     = try(each.value.settings.spacelift.after_plan, null) != null ? each.value.settings.spacelift.after_plan : var.after_plan
  before_apply   = try(each.value.settings.spacelift.before_apply, null) != null ? each.value.settings.spacelift.before_apply : var.before_apply
  before_destroy = try(each.value.settings.spacelift.before_destroy, null) != null ? each.value.settings.spacelift.before_destroy : var.before_destroy
  before_init    = try(each.value.settings.spacelift.before_init, null) != null ? each.value.settings.spacelift.before_init : var.before_init
  before_perform = try(each.value.settings.spacelift.before_perform, null) != null ? each.value.settings.spacelift.before_perform : var.before_perform
  before_plan    = try(each.value.settings.spacelift.before_plan, null) != null ? each.value.settings.spacelift.before_plan : var.before_plan

  protect_from_deletion = try(each.value.settings.spacelift.protect_from_deletion, null) != null ? each.value.settings.spacelift.protect_from_deletion : var.protect_from_deletion

  # If `worker_pool_name` is specified for the stack in YAML config AND `var.worker_pool_name_id_map` contains `worker_pool_name` key,
  # lookup and use the worker pool ID from the map.
  # Otherwise, use `var.worker_pool_id`.
  worker_pool_id = try(var.worker_pool_name_id_map[each.value.settings.spacelift.worker_pool_name], var.worker_pool_id)

  depends_on = [
    spacelift_policy.default,
    spacelift_policy.custom,
    spacelift_policy.trigger_administrative
  ]
}

# `administrative` policies are always attached to the `administrative` stack
# `spacelift_current_stack` is the administrative stack that manages all other infrastructure stacks
data "spacelift_current_stack" "administrative" {
  count = var.external_execution ? 0 : 1
}

# global administrative trigger policy that allows us to trigger a stack right after it gets created
resource "spacelift_policy" "trigger_administrative" {
  count = var.external_execution || var.administrative_trigger_policy_enabled == false ? 0 : 1

  type = "TRIGGER"
  name = "Global Administrative Trigger Policy"
  body = file(format("%s/%s/trigger.administrative.rego", path.module, var.policies_path))

  space_id = var.attachment_space_id
}

# Attach the global trigger policy to the current administrative stack
resource "spacelift_policy_attachment" "trigger_administrative" {
  count = var.external_execution || var.administrative_trigger_policy_enabled == false ? 0 : 1

  policy_id = join("", spacelift_policy.trigger_administrative.*.id)
  stack_id  = data.spacelift_current_stack.administrative[0].id
}

# global administrative push policy that updates branch tracking in the admin stack
resource "spacelift_policy" "push_administrative" {
  count = var.external_execution || var.administrative_push_policy_enabled == false ? 0 : 1

  type = "GIT_PUSH"
  name = "Global Administrative Push Policy"
  body = file(format("%s/%s/git_push.administrative.rego", path.module, var.policies_path))

  space_id = var.attachment_space_id
}

# Attach the global git push policy to the current administrative stack
resource "spacelift_policy_attachment" "push_administrative" {
  count = var.external_execution || var.administrative_push_policy_enabled == false ? 0 : 1

  policy_id = join("", spacelift_policy.push_administrative.*.id)
  stack_id  = data.spacelift_current_stack.administrative[0].id
}


resource "spacelift_drift_detection" "drift_detection_administrative" {
  count = var.external_execution || var.administrative_stack_drift_detection_enabled == false ? 0 : 1

  stack_id  = data.spacelift_current_stack.administrative[0].id
  reconcile = var.administrative_stack_drift_detection_reconcile
  schedule  = var.administrative_stack_drift_detection_schedule
}

resource "spacelift_context" "default" {
  count = local.stack_context_variables_enabled ? 1 : 0

  description = var.stack_context_description
  name        = var.stack_context_name

  space_id = var.attachment_space_id
}

resource "spacelift_environment_variable" "default" {
  for_each   = local.stack_context_variables_enabled ? var.stack_context_variables : {}
  context_id = join("", spacelift_context.default.*.id)
  name       = each.key
  value      = each.value
  write_only = false
}

data "spacelift_current_space" "administrative" {
  count = var.external_execution ? 0 : 1
}
