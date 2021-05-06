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

variable "stack_config_name" {
  type        = string
  description = "The name of the stack configuration (Atmos stack name)"
}

variable "stack_config_path" {
  type        = string
  default     = "stacks"
  description = "Relative path to YAML config files"
}

variable "stack_config_folder_name" {
  type        = string
  description = "The name of the folder with YAML config files"
  default     = "stacks"
}

variable "component_name" {
  type        = string
  description = "The name of the concrete component (typically a directory name)"
}

variable "logical_component" {
  type        = string
  description = "The name of the component (may be an alternate instance of a concrete component)"
}

variable "component_vars" {
  type        = map(any)
  default     = {}
  description = "All Terraform values to be applied to the stack via a mounted file."
}

variable "component_stack_deps" {
  type        = list(string)
  default     = []
  description = "A list of component stack dependencies."
}

variable "imports" {
  type        = list(string)
  default     = []
  description = "A list of stack imports."
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

variable "plan_policy_id" {
  type        = string
  default     = null
  description = "ID for the project-level plan policy."
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

variable "process_component_stack_deps" {
  type        = bool
  description = "Enable/disable processing stack dependencies for components"
  default     = false
}
