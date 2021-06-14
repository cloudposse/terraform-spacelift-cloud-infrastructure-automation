variable "enabled" {
  description = "Controls creation of all resources in this module"
  default     = false
  type        = bool
}

variable "enable_local_preview" {
  description = "Indicates whether local preview runs can be triggered on this Stack"
  default     = false
  type        = bool
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

variable "trigger_policy_id" {
  type        = string
  default     = null
  description = "Context ID for the global trigger policy ID"
}

variable "push_policy_id" {
  type        = string
  default     = null
  description = "ID for the project-level push policy"
}

variable "plan_policy_id" {
  type        = string
  default     = null
  description = "ID for the project-level plan policy"
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
