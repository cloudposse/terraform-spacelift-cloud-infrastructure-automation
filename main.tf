locals {
  // Use the provided config file path or default to the current dir
  config_file_path = coalesce(var.config_file_path, path.cwd)
  // Result ex: [gbl-audit.yaml, gbl-auto.yaml, gbl-dev.yaml, ...]
  config_filenames = fileset(local.config_file_path, var.config_file_pattern)
  // Result ex: [gbl-audit, gbl-auto, gbl-dev, ...]
  config_files = { for f in local.config_filenames : trimsuffix(basename(f), ".yaml") => yamldecode(file("${local.config_file_path}/${f}")) }
  // Result ex: { gbl-audit = { globals = { ... }, terraform = { project1 = { vars = ... }, project2 = { vars = ... } } } }
  projects = { for f in keys(local.config_files) : f => lookup(local.config_files[f], "projects", {}) if f != "globals" }
  // Result ex: { globals = { ... } }
  globals = { for f in keys(local.config_files) : f => local.config_files[f] if f == "globals" }
}

module "global_context" {
  source = "./modules/context"

  enabled = true

  context_name          = "global"
  environment_variables = local.globals.globals
}

module "spacelift_environment" {
  source = "./modules/environment"

  for_each = local.projects

  global_context_id  = module.global_context.context_id
  trigger_policy_id  = spacelift_policy.trigger_global.id
  push_policy_id     = spacelift_policy.push.id
  config_name        = each.key
  environment_values = each.value.globals
  projects           = local.projects[each.key].terraform
  projects_path      = var.components_path
  repository         = var.repository
  branch             = var.branch
}

# Define the global trigger policy that allows us to define custom triggers
resource "spacelift_policy" "trigger_global" {
  type = "TRIGGER"

  name = "Global Trigger Policy"
  body = file("${path.module}/policies/trigger-dependencies.rego")
}

# Define the environment trigger policy that causes stack executions when the parent environment config changes
resource "spacelift_policy" "trigger_env" {
  type = "TRIGGER"

  name = "Environment Trigger Policy"
  body = file("${path.module}/policies/trigger-environment.rego")
}

# Define the global "git push" policy that causes executions on stacks when `<project_root>/*.tf` is modified
resource "spacelift_policy" "push" {
  type = "GIT_PUSH"

  name = "Project-level Push Policy"
  body = file("${path.module}/policies/push-stack.rego")
}
