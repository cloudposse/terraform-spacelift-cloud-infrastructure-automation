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
  description = "A list of context IDs to attach to this stack"
  default     = []
}

variable "protect_from_deletion" {
  type        = bool
  description = "Flag to enable/disable deletion protection."
  default     = false
}

variable "azure_devops" {
  type        = map(any)
  description = "Azure DevOps VCS settings"
  default     = null
}

variable "bitbucket_cloud" {
  type        = map(any)
  description = "Bitbucket Cloud VCS settings"
  default     = null
}

variable "bitbucket_datacenter" {
  type        = map(any)
  description = "Bitbucket Datacenter VCS settings"
  default     = null
}

variable "cloudformation" {
  type        = map(any)
  description = "CloudFormation-specific configuration. Presence means this Stack is a CloudFormation Stack."
  default     = null
}

variable "github_enterprise" {
  type        = map(any)
  description = "GitHub Enterprise (self-hosted) VCS settings"
  default     = null
}

variable "gitlab" {
  type        = map(any)
  description = "GitLab VCS settings"
  default     = null
}

variable "pulumi" {
  type        = map(any)
  description = "Pulumi-specific configuration. Presence means this Stack is a Pulumi Stack."
  default     = null
}

variable "showcase" {
  type        = map(any)
  description = "Showcase settings"
  default     = null
}

variable "description" {
  type        = string
  description = "Specify description of stack"
  default     = null
}

variable "dedicated_space_enabled" {
  type        = bool
  description = "If enabled, create a new space for the admin stack in Spacelift. All child stacks will also be members of the new space."
  default     = false
}

variable "parent_space_id" {
  type        = string
  description = "If creating a dedicated space for this stack, specify the ID of the parent space in Spacelift."
  default     = null
}

variable "inherit_entities" {
  type        = bool
  description = "If creating a dedicated space for this stack, specify whether or not to inherit entities."
  default     = false
}

variable "space_id" {
  type        = string
  description = "Place the stack in the specified space_id."
  default     = "legacy"
}

variable "space_name" {
  type        = string
  description = "If using a dedicated space, override the name of the space (instead of using `component_name`)."
  default     = null
}

variable "terraform_smart_sanitization" {
  type        = bool
  description = "Whether or not to enable [Smart Sanitization](https://docs.spacelift.io/vendors/terraform/resource-sanitization) which will only sanitize values marked as sensitive."
  default     = false
}

variable "spacelift_stack_dependency_enabled" {
  type        = bool
  description = "If enabled, the `spacelift_stack_dependency` Spacelift resource will be used to create dependencies between stacks instead of using the `depends-on` labels. The `depends-on` labels will be removed from the stacks and the trigger policies for dependencies will be detached"
  default     = false
}
