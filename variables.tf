variable "stacks" {
  type        = list(any)
  description = "A list of stack configs"
}

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

variable "stack_config_path" {
  type        = string
  description = "Relative path to YAML config files"
  default     = "./stacks"
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
  description = "The immutable ID (slug) of the worker pool"
  default     = null
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

variable "access_policy_id" {
  type        = string
  description = "ID of an existing Access policy to override the default"
  default     = null
}

variable "push_policy_id" {
  type        = string
  description = "ID of an existing Push policy to override the default"
  default     = null
}

variable "plan_policy_id" {
  type        = string
  description = "ID of an existing Plan policy to override the default"
  default     = null
}

variable "trigger_dependency_policy_id" {
  type        = string
  description = "ID of an existing Trigger dependency policy to override the default"
  default     = null
}

variable "trigger_retries_policy_id" {
  type        = string
  description = "ID of an existing Trigger retries policy to override the default"
  default     = null
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

variable "policies_config" {
  type = list(object({
    path = string
    policies = list(object({
      file        = string
      description = string
      type        = string
    }))
  }))
  description = "List of policy configurations"
  default     = []
}

variable "policies_enabled" {
  type        = list(string)
  description = "List of policies to attach to Spacelift stacks"
  default = [
    "trigger.retries",
    "git_push.global",
    "plan.global"
  ]
}

variable "policies_path" {
  type        = string
  description = "Path to the catalog of policies"
  default     = "./catalog/policies"
}
