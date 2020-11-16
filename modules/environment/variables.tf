variable "config_name" {
  type        = string
  description = "The name of the YAML configuration file used for this environment workspace (for the trigger prefix)."
}

variable "config_directory" {
  type        = string
  default     = "config"
  description = "The name of the configuration directory to use in the trigger prefix."
}

variable "global_context_id" {
  type        = string
  default     = null
  description = "Context ID for the 'global' context that contains globally defined environment variables"
}

variable "trigger_policy_id" {
  type        = string
  default     = null
  description = "ID for the global trigger policy."
}

variable "push_policy_id" {
  type        = string
  default     = null
  description = "ID for the project-level push policy."
}

variable "environment_values" {
  type        = any
  default     = {}
  description = "The global values applied to all workspaces within the environment."
}

variable "projects" {
  type        = any
  default     = {}
  description = "A map of all projects and related configurations that exist within the environment."
}

variable "projects_path" {
  default     = "projects"
  type        = string
  description = "The relative pathname where all projects reside (used for trigger prefixes)."
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
