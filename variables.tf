variable "config_file_path" {
  type        = string
  description = "Relative path to YAML config files"
  default     = null
}

variable "config_file_pattern" {
  type        = string
  description = "File pattern used to locate configuration files"
  default     = "*.yaml"
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
