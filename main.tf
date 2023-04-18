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

resource "random_string" "random" {
  length  = 16
  special = true
}

locals {
  stack_context_variables_enabled = length(keys(var.stack_context_variables)) > 0

  # To prevent collitions with other arguments
  unique_identified = "extra_args_${random_string.random.result}"

  all_spacelift_stacks = {
    for k, v in module.spacelift_config.spacelift_stacks :
    # this merge was required because at the moment there isn't a way to create custom function in terraform
    # https://github.com/hashicorp/terraform/issues/28339
    k => try(merge(v, { "${unique_identified}" = {
      enabled                            = v.enabled
      dedicated_space_enabled            = try(v.settings.spacelift.dedicated_space_enabled, false)
      space_name                         = try(v.settings.spacelift.space_name, null)
      parent_space_id                    = try(v.settings.spacelift.parent_space_id, null)
      inherit_entities                   = try(v.settings.spacelift.inherit_entities, false)
      stack_name                         = try(v.settings.spacelift.ui_stack_name, try(v.settings.spacelift.stack_name, each.key))
      infrastructure_stack_name          = v.stack
      component_name                     = v.component
      component_vars                     = v.vars
      component_env                      = v.env
      terraform_workspace                = v.workspace
      terraform_smart_sanitization       = try(v.settings.spacelift.terraform_smart_sanitization, false)
      spacelift_stack_dependency_enabled = var.spacelift_stack_dependency_enabled

      labels = (
        try(v.settings.spacelift.administrative, null) != null ? v.settings.spacelift.administrative : var.administrative
        ) ? concat(
        local.labels,
        var.admin_labels,
        try(v.labels, [])
        ) : concat(
        local.labels,
        var.non_admin_labels,
        try(v.labels, [])
      )

      description           = try(v.settings.spacelift.description, null)
      context_attachments   = compact(concat([join("", spacelift_context.default.*.id)], coalesce(try(v.settings.spacelift.context_attachments, null), var.context_attachments)))
      autodeploy            = coalesce(try(v.settings.spacelift.autodeploy, null), var.autodeploy)
      branch                = coalesce(try(v.settings.spacelift.branch, null), var.branch)
      repository            = coalesce(try(v.settings.spacelift.repository, null), var.repository)
      commit_sha            = var.commit_sha != null ? var.commit_sha : try(v.settings.spacelift.commit_sha, null)
      spacelift_run_enabled = coalesce(try(v.settings.spacelift.spacelift_run_enabled, null), var.spacelift_run_enabled)
      terraform_version     = lookup(var.terraform_version_map, try(v.settings.spacelift.terraform_version, ""), var.terraform_version)
      component_root        = coalesce(try(v.settings.spacelift.component_root, null), format("%s/%s", var.components_path, coalesce(v.base_component, v.component)))
      local_preview_enabled = try(v.settings.spacelift.local_preview_enabled, null) != null ? v.settings.spacelift.local_preview_enabled : var.local_preview_enabled
      administrative        = try(v.settings.spacelift.administrative, null) != null ? v.settings.spacelift.administrative : var.administrative

      azure_devops         = try(v.settings.spacelift.azure_devops, null)
      bitbucket_cloud      = try(v.settings.spacelift.bitbucket_cloud, null)
      bitbucket_datacenter = try(v.settings.spacelift.bitbucket_datacenter, null)
      cloudformation       = try(v.settings.spacelift.cloudformation, null)
      github_enterprise    = try(v.settings.spacelift.github_enterprise, null)
      gitlab               = try(v.settings.spacelift.gitlab, null)
      pulumi               = try(v.settings.spacelift.pulumi, null)
      showcase             = try(v.settings.spacelift.showcase, null)

      manage_state = try(v.settings.spacelift.manage_state, var.manage_state)
      runner_image = try(v.settings.spacelift.runner_image, var.runner_image)

      webhook_enabled  = try(v.settings.spacelift.webhook_enabled, null) != null ? v.settings.spacelift.webhook_enabled : var.webhook_enabled
      webhook_endpoint = try(v.settings.spacelift.webhook_endpoint, null) != null ? v.settings.spacelift.webhook_endpoint : var.webhook_endpoint
      webhook_secret   = var.webhook_secret

      # Policies to attach to the stack (internally created + additional external provided by IDs + additional external created by this module from external Rego files)
      policy_ids                = local.stack_policies[k]
      drift_detection_enabled   = try(v.settings.spacelift.drift_detection_enabled, null) != null ? v.settings.spacelift.drift_detection_enabled : var.drift_detection_enabled
      drift_detection_reconcile = try(v.settings.spacelift.drift_detection_reconcile, null) != null ? v.settings.spacelift.drift_detection_reconcile : var.drift_detection_reconcile
      drift_detection_schedule  = try(v.settings.spacelift.drift_detection_schedule, null) != null ? v.settings.spacelift.drift_detection_schedule : var.drift_detection_schedule

      aws_role_enabled     = try(v.settings.spacelift.aws_role_enabled, null) != null ? v.settings.spacelift.aws_role_enabled : var.aws_role_enabled
      aws_role_arn         = try(v.settings.spacelift.aws_role_arn, null) != null ? v.settings.spacelift.aws_role_arn : var.aws_role_arn
      aws_role_external_id = try(v.settings.spacelift.aws_role_external_id, null) != null ? v.settings.spacelift.aws_role_external_id : var.aws_role_external_id

      aws_role_generate_credentials_in_worker = try(v.settings.spacelift.aws_role_generate_credentials_in_worker, null) != null ? (
        v.settings.spacelift.aws_role_generate_credentials_in_worker
      ) : var.aws_role_generate_credentials_in_worker

      stack_destructor_enabled = try(v.settings.spacelift.stack_destructor_enabled, null) != null ? v.settings.spacelift.stack_destructor_enabled : var.stack_destructor_enabled

      after_apply    = try(v.settings.spacelift.after_apply, null) != null ? v.settings.spacelift.after_apply : var.after_apply
      after_destroy  = try(v.settings.spacelift.after_destroy, null) != null ? v.settings.spacelift.after_destroy : var.after_destroy
      after_init     = try(v.settings.spacelift.after_init, null) != null ? v.settings.spacelift.after_init : var.after_init
      after_perform  = try(v.settings.spacelift.after_perform, null) != null ? v.settings.spacelift.after_perform : var.after_perform
      after_plan     = try(v.settings.spacelift.after_plan, null) != null ? v.settings.spacelift.after_plan : var.after_plan
      before_apply   = try(v.settings.spacelift.before_apply, null) != null ? v.settings.spacelift.before_apply : var.before_apply
      before_destroy = try(v.settings.spacelift.before_destroy, null) != null ? v.settings.spacelift.before_destroy : var.before_destroy
      before_init    = try(v.settings.spacelift.before_init, null) != null ? v.settings.spacelift.before_init : var.before_init
      before_perform = try(v.settings.spacelift.before_perform, null) != null ? v.settings.spacelift.before_perform : var.before_perform
      before_plan    = try(v.settings.spacelift.before_plan, null) != null ? v.settings.spacelift.before_plan : var.before_plan

      protect_from_deletion = try(v.settings.spacelift.protect_from_deletion, null) != null ? v.settings.spacelift.protect_from_deletion : var.protect_from_deletion

      # If `worker_pool_name` is specified for the stack in YAML config AND `var.worker_pool_name_id_map` contains `worker_pool_name` key,
      # lookup and use the worker pool ID from the map.
      # Otherwise, use `var.worker_pool_id`.
      worker_pool_id = try(var.worker_pool_name_id_map[v.settings.spacelift.worker_pool_name], var.worker_pool_id)

    } }), v)
    if
    (lookup(var.context_filters, "namespaces", null) == null || contains(lookup(var.context_filters, "namespaces", [lookup(v.vars, "namespace", "")]), lookup(v.vars, "namespace", ""))) &&
    (lookup(var.context_filters, "tenants", null) == null || contains(lookup(var.context_filters, "tenants", [lookup(v.vars, "tenant", "")]), lookup(v.vars, "tenant", ""))) &&
    (lookup(var.context_filters, "environments", null) == null || contains(lookup(var.context_filters, "environments", [lookup(v.vars, "environment", "")]), lookup(v.vars, "environment", ""))) &&
    (lookup(var.context_filters, "stages", null) == null || contains(lookup(var.context_filters, "stages", [lookup(v.vars, "stage", "")]), lookup(v.vars, "stage", "")))
  }

  # The root/admin stack has to create their own stack and space in addition to the children's stacks/spaces.
  # The characteristic of root/admin yaml-config-file is that var.tag_filters == var.tags, it is because it has
  # to be able to pick up its own yaml-config-file to create its own stack and space.
  root_stacks = {
    for k, v in local.all_spacelift_stacks :
    k => v if alltrue([
      sha1(jsonencode(lookup(v.vars, "tag_filters", {}))) != sha1(jsonencode(var.tag_filters)),
      sha1(jsonencode(lookup(v.vars, "tags", {}))) == sha1(jsonencode(var.tag_filters)),
    ])
  }
  root_stack_name = try(keys(local.root_stacks)[0], null)

  # The parent stacks and space is created by the root/admin stack or a previous parent's stack.
  # Notice that a previous child becomes into a parent for grandchildren.
  parent_stacks = {
    for k, v in local.all_spacelift_stacks :
    k => v if alltrue([
      sha1(jsonencode(lookup(v.vars, "tag_filters", {}))) == sha1(jsonencode(var.tag_filters)),
      sha1(jsonencode(lookup(v.vars, "tags", {}))) != sha1(jsonencode(var.tag_filters)),
    ])
  }
  parent_stack_name = try(keys(local.parent_stacks)[0], null)

  # if context_filters are provided, then filter for them, otherwise return the original stacks unfiltered
  spacelift_stacks = {
    for k, v in local.all_spacelift_stacks :
    k => v
    if
    (
      var.tag_filters == null || length(var.tag_filters) == 0 || lookup(v.vars, "tags", null) == null || contains([
        for i, j in var.tag_filters :
        lookup(lookup(v.vars, "tags", {}), i, null) == j
      ], true)
    ) &&
    !contains(keys(root_stack_name), k)
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
        ) if !contains(local.excluded_policies, i)
      ],
      [
        for i in try(v.settings.spacelift.policies_by_name_enabled, var.policies_by_name_enabled) : (
          spacelift_policy.custom[i].id
        ) if !contains(local.excluded_policies, i)
      ],
      [
        for i in try(v.settings.spacelift.policies_by_id_enabled, var.policies_by_id_enabled) : (
          i
        ) if !contains(local.excluded_policies, i)
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

data "spacelift_stacks" "filtered" {

  for_each = local.parent_stacks

  name {
    # Notice that this should be the same that was defined in the module.stacks.labels
    any_of = [try(each.value.settings.spacelift.ui_stack_name, try(each.value.settings.spacelift.stack_name, each.key))]
  }

  dynamic "labels" {
    for_each = toset(
      # Notice that this should be the same that was defined in the module.stacks.labels
      (
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
    )
    iterator = label

    content {
      any_of = [label.key]
    }
  }


  lifecycle {
    precondition {
      condition     = length(keys(local.parent_stacks)) <= 1
      error_message = <<EOF
It is not allowed to have multiple `space-yaml-files` that have the same `tag_filters` and `context_filters` in the same path (${var.stack_config_path_template}).
If multiple `space-yaml-files` have the same `tag_filters` and `context_filters`, stacks with matching `tag_filters` and `context_filters` will be moved
back and forth between these spaces. This may result in unexpected behavior, such as stacks ending up in unintended spaces or be constantly moving from one space to other.

To prevent above issue check the `space-yaml-files`: ${join(",", keys(local.parent_stacks))}
They have the same `tag_filters` and `context_filters`:
* tag_filters: {
    ${join(",\n", [for k, v in var.tag_filters : "${k}: ${v}"])}
  }
* context_filters: {
    ${join(",\n", [for k, v in var.context_filters : "${k}: ${v}"])}
  }
EOF
    }
  }
}

locals {
  current_space_id = try(data.spacelift_stacks.filtered[local.parent_stack_name].stacks[0].space_id, null)
}

# If there is a root/admin stack in this terraform apply, it should be created first because there isn't a previous parent that
# create it, basically this is the first node in the spacelift's space tree.
module "stack_root" {
  source = "./modules/stack"

  for_each = local.root_stacks

  space_id = coalesce(
    try(each.value.settings.spacelift.space_id, null),
    var.stacks_space_id,
    try(data.spacelift_current_space.administrative[0].id, null),
    local.current_space_id,
    "legacy"
  )

  enabled                            = each.value[local.unique_identified].enabled
  dedicated_space_enabled            = each.value[local.unique_identified].dedicated_space_enabled
  space_name                         = each.value[local.unique_identified].space_name
  parent_space_id                    = each.value[local.unique_identified].parent_space_id
  inherit_entities                   = each.value[local.unique_identified].inherit_entities
  stack_name                         = each.value[local.unique_identified].stack_name
  infrastructure_stack_name          = each.value[local.unique_identified].infrastructure_stack_name
  component_name                     = each.value[local.unique_identified].component_name
  component_vars                     = each.value[local.unique_identified].component_vars
  component_env                      = each.value[local.unique_identified].component_env
  terraform_workspace                = each.value[local.unique_identified].terraform_workspace
  terraform_smart_sanitization       = each.value[local.unique_identified].terraform_smart_sanitization
  spacelift_stack_dependency_enabled = each.value[local.unique_identified].spacelift_stack_dependency_enabled

  labels = each.value[local.unique_identified].spacelift_stack_dependency_enabled

  description           = each.value[local.unique_identified].description
  context_attachments   = each.value[local.unique_identified].context_attachments
  autodeploy            = each.value[local.unique_identified].autodeploy
  branch                = each.value[local.unique_identified].branch
  repository            = each.value[local.unique_identified].repository
  commit_sha            = each.value[local.unique_identified].commit_sha
  spacelift_run_enabled = each.value[local.unique_identified].spacelift_run_enabled
  terraform_version     = each.value[local.unique_identified].terraform_version
  component_root        = each.value[local.unique_identified].component_root
  local_preview_enabled = each.value[local.unique_identified].local_preview_enabled
  administrative        = each.value[local.unique_identified].administrative

  azure_devops         = each.value[local.unique_identified].azure_devops
  bitbucket_cloud      = each.value[local.unique_identified].bitbucket_cloud
  bitbucket_datacenter = each.value[local.unique_identified].bitbucket_datacenter
  cloudformation       = each.value[local.unique_identified].cloudformation
  github_enterprise    = each.value[local.unique_identified].github_enterprise
  gitlab               = each.value[local.unique_identified].gitlab
  pulumi               = each.value[local.unique_identified].pulumi
  showcase             = each.value[local.unique_identified].showcase

  manage_state = each.value[local.unique_identified].manage_state
  runner_image = each.value[local.unique_identified].runner_image

  webhook_enabled  = each.value[local.unique_identified].webhook_enabled
  webhook_endpoint = each.value[local.unique_identified].webhook_endpoint
  webhook_secret   = each.value[local.unique_identified].webhook_secret

  # Policies to attach to the stack (internally created + additional external provided by IDs + additional external created by this module from external Rego files)
  policy_ids                = each.value[local.unique_identified].policy_ids
  drift_detection_enabled   = each.value[local.unique_identified].drift_detection_enabled
  drift_detection_reconcile = each.value[local.unique_identified].drift_detection_reconcile
  drift_detection_schedule  = each.value[local.unique_identified].drift_detection_schedule

  aws_role_enabled     = each.value[local.unique_identified].aws_role_enabled
  aws_role_arn         = each.value[local.unique_identified].aws_role_arn
  aws_role_external_id = each.value[local.unique_identified].aws_role_external_id

  aws_role_generate_credentials_in_worker = each.value[local.unique_identified].aws_role_generate_credentials_in_worker

  stack_destructor_enabled = each.value[local.unique_identified].stack_destructor_enabled

  after_apply    = each.value[local.unique_identified].after_apply
  after_destroy  = each.value[local.unique_identified].after_destroy
  after_init     = each.value[local.unique_identified].after_init
  after_perform  = each.value[local.unique_identified].after_perform
  after_plan     = each.value[local.unique_identified].after_plan
  before_apply   = each.value[local.unique_identified].before_apply
  before_destroy = each.value[local.unique_identified].before_destroy
  before_init    = each.value[local.unique_identified].before_init
  before_perform = each.value[local.unique_identified].before_perform
  before_plan    = each.value[local.unique_identified].before_plan

  protect_from_deletion = each.value[local.unique_identified].protect_from_deletion

  # If `worker_pool_name` is specified for the stack in YAML config AND `var.worker_pool_name_id_map` contains `worker_pool_name` key,
  # lookup and use the worker pool ID from the map.
  # Otherwise, use `var.worker_pool_id`.
  worker_pool_id = each.value[local.unique_identified].worker_pool_id

  depends_on = [
    spacelift_policy.default,
    spacelift_policy.custom,
    spacelift_policy.trigger_administrative
  ]
}

module "stacks" {
  source = "./modules/stack"

  for_each = local.spacelift_stacks

  space_id = coalesce(
    try(module.module.stack_root, null),
    try(each.value.settings.spacelift.space_id, null),
    var.stacks_space_id,
    try(data.spacelift_current_space.administrative[0].id, null),
    local.current_space_id,
    "legacy"
  )

  enabled                            = each.value[local.unique_identified].enabled
  dedicated_space_enabled            = each.value[local.unique_identified].dedicated_space_enabled
  space_name                         = each.value[local.unique_identified].space_name
  parent_space_id                    = each.value[local.unique_identified].parent_space_id
  inherit_entities                   = each.value[local.unique_identified].inherit_entities
  stack_name                         = each.value[local.unique_identified].stack_name
  infrastructure_stack_name          = each.value[local.unique_identified].infrastructure_stack_name
  component_name                     = each.value[local.unique_identified].component_name
  component_vars                     = each.value[local.unique_identified].component_vars
  component_env                      = each.value[local.unique_identified].component_env
  terraform_workspace                = each.value[local.unique_identified].terraform_workspace
  terraform_smart_sanitization       = each.value[local.unique_identified].terraform_smart_sanitization
  spacelift_stack_dependency_enabled = each.value[local.unique_identified].spacelift_stack_dependency_enabled

  labels = each.value[local.unique_identified].spacelift_stack_dependency_enabled

  description           = each.value[local.unique_identified].description
  context_attachments   = each.value[local.unique_identified].context_attachments
  autodeploy            = each.value[local.unique_identified].autodeploy
  branch                = each.value[local.unique_identified].branch
  repository            = each.value[local.unique_identified].repository
  commit_sha            = each.value[local.unique_identified].commit_sha
  spacelift_run_enabled = each.value[local.unique_identified].spacelift_run_enabled
  terraform_version     = each.value[local.unique_identified].terraform_version
  component_root        = each.value[local.unique_identified].component_root
  local_preview_enabled = each.value[local.unique_identified].local_preview_enabled
  administrative        = each.value[local.unique_identified].administrative

  azure_devops         = each.value[local.unique_identified].azure_devops
  bitbucket_cloud      = each.value[local.unique_identified].bitbucket_cloud
  bitbucket_datacenter = each.value[local.unique_identified].bitbucket_datacenter
  cloudformation       = each.value[local.unique_identified].cloudformation
  github_enterprise    = each.value[local.unique_identified].github_enterprise
  gitlab               = each.value[local.unique_identified].gitlab
  pulumi               = each.value[local.unique_identified].pulumi
  showcase             = each.value[local.unique_identified].showcase

  manage_state = each.value[local.unique_identified].manage_state
  runner_image = each.value[local.unique_identified].runner_image

  webhook_enabled  = each.value[local.unique_identified].webhook_enabled
  webhook_endpoint = each.value[local.unique_identified].webhook_endpoint
  webhook_secret   = each.value[local.unique_identified].webhook_secret

  # Policies to attach to the stack (internally created + additional external provided by IDs + additional external created by this module from external Rego files)
  policy_ids                = each.value[local.unique_identified].policy_ids
  drift_detection_enabled   = each.value[local.unique_identified].drift_detection_enabled
  drift_detection_reconcile = each.value[local.unique_identified].drift_detection_reconcile
  drift_detection_schedule  = each.value[local.unique_identified].drift_detection_schedule

  aws_role_enabled     = each.value[local.unique_identified].aws_role_enabled
  aws_role_arn         = each.value[local.unique_identified].aws_role_arn
  aws_role_external_id = each.value[local.unique_identified].aws_role_external_id

  aws_role_generate_credentials_in_worker = each.value[local.unique_identified].aws_role_generate_credentials_in_worker

  stack_destructor_enabled = each.value[local.unique_identified].stack_destructor_enabled

  after_apply    = each.value[local.unique_identified].after_apply
  after_destroy  = each.value[local.unique_identified].after_destroy
  after_init     = each.value[local.unique_identified].after_init
  after_perform  = each.value[local.unique_identified].after_perform
  after_plan     = each.value[local.unique_identified].after_plan
  before_apply   = each.value[local.unique_identified].before_apply
  before_destroy = each.value[local.unique_identified].before_destroy
  before_init    = each.value[local.unique_identified].before_init
  before_perform = each.value[local.unique_identified].before_perform
  before_plan    = each.value[local.unique_identified].before_plan

  protect_from_deletion = each.value[local.unique_identified].protect_from_deletion

  # If `worker_pool_name` is specified for the stack in YAML config AND `var.worker_pool_name_id_map` contains `worker_pool_name` key,
  # lookup and use the worker pool ID from the map.
  # Otherwise, use `var.worker_pool_id`.
  worker_pool_id = each.value[local.unique_identified].worker_pool_id

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
