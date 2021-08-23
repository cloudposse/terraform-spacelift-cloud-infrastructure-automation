variable "enabled" {
  type        = bool
  description = "Controls creation of all resources in this module"
  default     = false
}

variable "local_preview_enabled" {
  type        = bool
  description = "Indicates whether local preview runs can be triggered on this Stack"
  default     = false
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

variable "terraform_version" {
  type        = string
  description = "Specify the version of Terraform to use for the stack"
  default     = null
}

variable "terraform_workspace" {
  type        = string
  description = "Specify the Terraform workspace to use for the stack"
  default     = null
}

variable "worker_pool_id" {
  type        = string
  description = "The immutable ID (slug) of the worker pool"
  default     = null
}

variable "runner_image" {
  type        = string
  description = "The full image name and tag of the Docker image to use in Spacelift"
  default     = null
}

variable "component_root" {
  type        = string
  description = "The path, relative to the root of the repository, where the component can be found"
}

variable "infrastructure_stack_name" {
  type        = string
  description = "The name of the infrastructure stack"
}

variable "stack_name" {
  type        = string
  description = "The name of the Spacelift stack"
}

variable "component_name" {
  type        = string
  description = "The name of the concrete component (typically a directory name)"
}

variable "component_vars" {
  type        = any
  default     = {}
  description = "All Terraform values to be applied to the stack via a mounted file"
}

variable "component_env" {
  type        = any
  default     = {}
  description = "Map of component ENV variables"
}

variable "autodeploy" {
  type        = bool
  description = "Controls the Spacelift 'autodeploy' option for a stack"
  default     = false
}

variable "manage_state" {
  type        = bool
  description = "Flag to enable/disable manage_state setting in stack"
  default     = true
}

variable "labels" {
  type        = list(string)
  description = "A list of labels for the stack"
  default     = []
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

variable "policy_ids" {
  type        = list(string)
  default     = []
  description = "List of Rego policy IDs to attach to this stack"
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
  description = "Flag to enable/disable the stack destructor to destroy the resources of the stack before deleting the stack itself"
  default     = false
}

variable "administrative" {
  type        = bool
  description = "Whether this stack can manage other stacks"
  default     = false
}
