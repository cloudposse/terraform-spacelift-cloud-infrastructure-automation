variable "stack_config_path" {
  type        = string
  description = "Relative path to YAML config files"
  default     = "stacks"
}

variable "stack_config_files" {
  type        = list(any)
  description = "A list of stack config files"
  default     = []
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
  description = "Global flag to enable/disable manage_state settings for all project stacks."
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
  description = "Set this to true if you're calling this module from outside of a Spacelift stack (e.g. the `complete` example)."
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

variable "trigger_retries_enabled" {
  type        = bool
  description = "Flag to enable/disable the automatic retries trigger"
  default     = false
}

variable "trigger_global_enabled" {
  type        = bool
  description = "Flag to enable/disable the global trigger"
  default     = false
}

variable "process_component_stack_deps" {
  type        = bool
  description = "Enable/disable processing stack dependencies for components"
  default     = false
}
