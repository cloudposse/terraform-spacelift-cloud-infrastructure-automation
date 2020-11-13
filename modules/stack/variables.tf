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

variable "project_root" {
  type        = string
  description = "The path, relative to the root of the repository, where the stack project can be found"
}

variable "stack_name" {
  type        = string
  description = "The name of the stack"
}

variable "environment_name" {
  type        = string
  description = "The name of the parent environment (e.g. 'gbl-root', 'ue2-example', etc.)"
}

variable "environment_variables" {
  type        = map
  default     = {}
  description = "The global values applied to all workspaces within the environment."
}

variable "triggers" {
  type        = list
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

variable "global_context_id" {
  type        = string
  default     = null
  description = "Context ID for the 'global' context that contains globally defined environment variables"
}

variable "parent_context_id" {
  type        = string
  description = "Spacelift context ID to attach to this stack"
}

variable "autodeploy" {
  type        = bool
  description = "Controls the Spacelift 'autodeploy' option for a stack"
}
