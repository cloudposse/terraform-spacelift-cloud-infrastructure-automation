variable "imports_processing_enabled" {
  type        = bool
  description = "Enable/disable processing stack imports"
  default     = false
}

variable "stack_deps_processing_enabled" {
  type        = bool
  description = "Boolean flag to enable/disable processing all stack dependencies in the provided stack"
  default     = false
}

variable "component_deps_processing_enabled" {
  type        = bool
  description = "Boolean flag to enable/disable processing stack config dependencies for the components in the provided stack"
  default     = true
}

variable "stack_config_path_template" {
  type        = string
  description = "Stack config path template"
  default     = "stacks/%s.yaml"
}

variable "repository" {
  type        = string
  description = "The name of your infrastructure repo"
}

variable "branch" {
  type        = string
  description = "Specify which branch to use within your infrastructure repo"
  default     = "main"
}

variable "commit_sha" {
  type        = string
  description = "The commit SHA for which to trigger a run. Requires `var.spacelift_run_enabled` to be set to `true`"
  default     = null
}

variable "spacelift_run_enabled" {
  type        = bool
  description = "Enable/disable creation of the `spacelift_run` resource"
  default     = false
}

variable "components_path" {
  type        = string
  description = "The relative pathname for where all components reside"
  default     = "components"
}

variable "manage_state" {
  type        = bool
  description = "Global flag to enable/disable manage_state settings for all project stacks"
  default     = true
}

variable "terraform_version" {
  type        = string
  description = "Specify the version of Terraform to use for the stack"
  default     = null
}

variable "terraform_version_map" {
  type        = map(string)
  description = "A map to determine which Terraform patch version to use for each minor version"
  default     = {}
}

variable "external_execution" {
  type        = bool
  description = "Set this to true if you're calling this module from outside of a Spacelift stack (e.g. the `complete` example)"
  default     = false
}

variable "worker_pool_id" {
  type        = string
  description = "The immutable ID (slug) of the default worker pool"
  default     = null
}

variable "worker_pool_name_id_map" {
  type        = map(string)
  description = "Map of worker pool names to worker pool IDs. If this map is not provided or a worker pool name is not specified for a stack in YAML config, `var.worker_pool_id` will be used to assign a worker pool to the stack"
  default     = {}
}

variable "runner_image" {
  type        = string
  description = "The full image name and tag of the Docker image to use in Spacelift"
  default     = null
}

variable "autodeploy" {
  type        = bool
  description = "Autodeploy global setting for Spacelift stacks. This setting can be overidden in stack-level configuration)"
  default     = false
}

variable "webhook_enabled" {
  type        = bool
  description = "Flag to enable/disable the webhook endpoint to which Spacelift sends the POST requests about run state changes"
  default     = false
}

variable "webhook_endpoint" {
  type        = string
  description = "Webhook endpoint to which Spacelift sends the POST requests about run state changes"
  default     = null
}

variable "webhook_secret" {
  type        = string
  description = "Webhook secret used to sign each POST request so you're able to verify that the requests come from Spacelift"
  default     = null
}

variable "local_preview_enabled" {
  type        = bool
  description = "Indicates whether local preview runs can be triggered on this Stack"
  default     = false
}

variable "administrative_trigger_policy_enabled" {
  type        = bool
  description = "Flag to enable/disable the global administrative trigger policy"
  default     = true
}

variable "administrative_push_policy_enabled" {
  type        = bool
  description = "Flag to enable/disable the global administrative push policy"
  default     = true
}

variable "policies_available" {
  type        = list(string)
  description = "List of available default policies to create in Spacelift (these policies will not be attached to Spacelift stacks by default, use `var.policies_enabled`)"
  default = [
    "access.default",
    "git_push.proposed-run",
    "git_push.tracked-run",
    "plan.default",
    "trigger.dependencies",
    "trigger.retries"
  ]
}

variable "policies_enabled" {
  type        = list(string)
  description = "List of default policies to attach to all Spacelift stacks"
  default = [
    "git_push.proposed-run",
    "git_push.tracked-run",
    "plan.default",
    "trigger.dependencies"
  ]
}

variable "policies_path" {
  type        = string
  description = "Path to the catalog of default policies"
  default     = "catalog/policies"
}

variable "policies_by_id_enabled" {
  type        = list(string)
  description = "List of existing policy IDs to attach to all Spacelift stacks. These policies must be created outside of this module"
  default     = []
}

variable "policies_by_name_enabled" {
  type        = list(string)
  description = "List of existing policy names to attach to all Spacelift stacks. These policies must be created outside of this module"
  default     = []
}

variable "policies_by_name_path" {
  type        = string
  description = "Path to the catalog of external Rego policies. The Rego files must exist in the caller's code at the path. The module will create Spacelift policies from the external Rego definitions"
  default     = ""
}

variable "administrative_stack_drift_detection_enabled" {
  type        = bool
  description = "Flag to enable/disable administrative stack drift detection"
  default     = true
}

variable "administrative_stack_drift_detection_reconcile" {
  type        = bool
  description = "Flag to enable/disable administrative stack drift automatic reconciliation. If drift is detected and `reconcile` is turned on, Spacelift will create a tracked run to correct the drift"
  default     = true
}

variable "administrative_stack_drift_detection_schedule" {
  type        = list(string)
  description = "List of cron expressions to schedule drift detection for the administrative stack"
  default     = ["0 4 * * *"]
}

variable "drift_detection_enabled" {
  type        = bool
  description = "Flag to enable/disable drift detection on the infrastructure stacks"
  default     = false
}

variable "drift_detection_reconcile" {
  type        = bool
  description = "Flag to enable/disable infrastructure stacks drift automatic reconciliation. If drift is detected and `reconcile` is turned on, Spacelift will create a tracked run to correct the drift"
  default     = false
}

variable "drift_detection_schedule" {
  type        = list(string)
  description = "List of cron expressions to schedule drift detection for the infrastructure stacks"
  default     = ["0 4 * * *"]
}

variable "aws_role_enabled" {
  type        = bool
  description = "Flag to enable/disable Spacelift to use AWS STS to assume the supplied IAM role and put its temporary credentials in the runtime environment"
  default     = false
}

variable "aws_role_arn" {
  type        = string
  description = "ARN of the AWS IAM role to assume and put its temporary credentials in the runtime environment"
  default     = null
}

variable "aws_role_external_id" {
  type        = string
  description = "Custom external ID (works only for private workers). See https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user_externalid.html for more details"
  default     = null
}

variable "aws_role_generate_credentials_in_worker" {
  type        = bool
  description = "Flag to enable/disable generating AWS credentials in the private worker after assuming the supplied IAM role"
  default     = true
}

variable "stack_destructor_enabled" {
  type        = bool
  description = "Flag to enable/disable the stack destructor to destroy the resources of a stack before deleting the stack itself"
  default     = false
}

variable "before_apply" {
  type        = list(string)
  description = "List of before-apply scripts"
  default     = []
}

variable "before_destroy" {
  type        = list(string)
  description = "List of before-destroy scripts"
  default     = []
}

variable "before_init" {
  type        = list(string)
  description = "List of before-init scripts"
  default     = []
}

variable "before_perform" {
  type        = list(string)
  description = "List of before-perform scripts"
  default     = []
}

variable "before_plan" {
  type        = list(string)
  description = "List of before-plan scripts"
  default     = []
}

variable "after_apply" {
  type        = list(string)
  description = "List of after-apply scripts"
  default     = []
}

variable "after_destroy" {
  type        = list(string)
  description = "List of after-destroy scripts"
  default     = []
}

variable "after_init" {
  type        = list(string)
  description = "List of after-init scripts"
  default     = []
}

variable "after_perform" {
  type        = list(string)
  description = "List of after-perform scripts"
  default     = []
}

variable "after_plan" {
  type        = list(string)
  description = "List of after-plan scripts"
  default     = []
}

variable "administrative" {
  type        = bool
  description = "Whether this stack can manage other stacks"
  default     = false
}

variable "context_attachments" {
  type        = list(string)
  description = "A list of context IDs to attach to all stacks administered by this module"
  default     = []
}

variable "context_filters" {
  type        = any
  description = "Context filters to create stacks for specific context information. Valid lists are for `namespaces`, `environments`, `tenants`, `stages` and a valid map is for `tags`."
  default     = {}
}

variable "tag_filters" {
  type        = map(string)
  description = "A map of tags that will filter stack creation by the matching `tags` set in a component `vars` configuration."
  default     = {}
}

variable "protect_from_deletion" {
  type        = bool
  description = "Flag to enable/disable deletion protection."
  default     = false
}

variable "infracost_enabled" {
  type        = bool
  description = "Flag to enable/disable infracost. If this is enabled, it will add infracost label to each stack. See [spacelift infracost](https://docs.spacelift.io/vendors/terraform/infracost) docs for more details."
  default     = false
}

variable "labels" {
  type        = list(string)
  description = "A list of labels for all stacks"
  default     = []
}

variable "admin_labels" {
  type        = list(string)
  description = "A list of labels for admin stacks"
  default     = []
}

variable "non_admin_labels" {
  type        = list(string)
  description = "A list of labels for non-admin stacks"
  default     = []
}

variable "stack_context_name" {
  type        = string
  description = "Name of global stack context"
  default     = "Stack context"
}

variable "stack_context_description" {
  type        = string
  description = "Description of global stack context"
  default     = "Stack context description"
}

variable "stack_context_variables" {
  type        = map(string)
  description = "Map of variables to create a global context attached to each stack"
  default     = {}
}

variable "attachment_space_id" {
  type        = string
  description = "Specify the space ID for attachments (e.g. policies, contexts, etc.)"
  default     = "legacy"
}

variable "stacks_space_id" {
  type        = string
  description = "Override the space ID for all stacks (unless the stack config has `dedicated_space` set to true). Otherwise, it will default to the admin stack's space."
  default     = null
}

variable "spacelift_stack_dependency_enabled" {
  type        = bool
  description = "If enabled, the `spacelift_stack_dependency` Spacelift resource will be used to create dependencies between stacks instead of using the `depends-on` labels. The `depends-on` labels will be removed from the stacks and the trigger policies for dependencies will be detached"
  default     = false
}
