variable "stack_config_name" {
  type        = string
  description = "The name of the YAML configuration file used for this environment workspace (for the trigger prefix)."
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

variable "trigger_policy_id" {
  type        = string
  default     = null
  description = "ID for the global trigger policy."
}

variable "push_policy_id" {
  type        = string
  default     = null
  description = "ID for the component-level push policy."
}

variable "plan_policy_id" {
  type        = string
  default     = null
  description = "ID for the project-level plan policy."
}

variable "components" {
  type        = any
  default     = {}
  description = "A map of all components and related configurations that exist within the environment."
}

variable "imports" {
  type        = list(string)
  default     = []
  description = "A list of stack imports."
}

variable "components_path" {
  default     = "components"
  type        = string
  description = "The relative pathname where all components reside (used for trigger prefixes)."
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

variable "manage_state" {
  type        = bool
  description = "Global flag to enable/disable manage_state settings in all stacks."
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
  type        = string
  description = "Autodeploy global setting for Spacelift stacks. This setting can be overidden in stack-level configuration)"
  default     = null
}

variable "process_component_stack_deps" {
  type        = bool
  description = "Enable/disable processing stack dependencies for components"
  default     = false
}
