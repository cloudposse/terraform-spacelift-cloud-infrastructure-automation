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

variable "terraform_version" {
  type        = string
  description = "Specify the version of Terraform to use for the stack"
  default     = null
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
