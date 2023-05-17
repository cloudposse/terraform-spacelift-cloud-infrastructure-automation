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

variable "stack_deps_processing_enabled" {
  type        = bool
  description = "Boolean flag to enable/disable processing all stack dependencies in the provided stack"
  default     = false
}

variable "imports_processing_enabled" {
  type        = bool
  description = "Enable/disable processing stack imports"
  default     = false
}

variable "context_filters" {
  type = object({
    namespaces          = optional(list(string), [])
    environments        = optional(list(string), [])
    tenants             = optional(list(string), [])
    stages              = optional(list(string), [])
    tags                = optional(map(string), {})
    administrative      = optional(bool)
    root_administrative = optional(bool)
  })
  description = "Context filters to output stacks matching specific criteria."
}
