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

variable "terraform_version_map" {
  type        = map(string)
  description = "A map to determine which Terraform patch version to use for each minor version"
  default     = {}
}

variable "autodeploy" {
  type        = bool
  description = "Autodeploy global setting for Spacelift stacks. This setting can be overidden in stack-level configuration)"
  default     = false
}

variable "external_execution" {
  type        = bool
  description = "Set this to true if you're calling this module from outside of a Spacelift stack (e.g. the `complete` example)."
  default     = false
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
