variable "enabled" {
  description = "Controls creation fo all resources in this module."
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

variable "worker_pool_id" {
  type        = string
  description = "The immutable ID (slug) of the worker pool"
  default     = null
}

variable "role_arn" {
  type        = string
  description = "The role_arn to use for Spacelift executions"
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

variable "stack_name" {
  type        = string
  description = "The name of the stack"
}

variable "component_vars" {
  type        = string
  default     = "{}"
  description = "All Terraform values to be applied to the stack via a mounted file, formatted in JSON."
}

variable "triggers" {
  type        = list(any)
  default     = []
  description = "A list of other stacks that will trigger an execution."
}

variable "trigger_policy_id" {
  type        = string
  default     = null
  description = "Context ID for the global trigger policy ID."
}

variable "push_policy_id" {
  type        = string
  default     = null
  description = "ID for the project-level push policy."
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
