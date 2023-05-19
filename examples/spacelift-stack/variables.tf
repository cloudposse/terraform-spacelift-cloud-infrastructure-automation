variable "administrative" {
  type        = bool
  description = "Whether this stack can manage other stacks"
  default     = false
}

variable "atmos_stack_name" {
  type        = string
  description = "The name of the atmos stack"
}

variable "autodeploy" {
  type        = bool
  description = "Controls the Spacelift 'autodeploy' option for a stack"
  default     = false
}

variable "branch" {
  type        = string
  description = "Specify which branch to use within your infrastructure repo"
  default     = "main"
}

variable "component_env" {
  type        = any
  default     = {}
  description = "Map of component ENV variables"
}

variable "component_name" {
  type        = string
  description = "The name of the concrete component (typically a directory name)"
}

variable "component_root" {
  type        = string
  description = "The path, relative to the root of the repository, where the component can be found"
}

variable "component_vars" {
  type        = any
  default     = {}
  description = "All Terraform values to be applied to the stack via a mounted file"
}

variable "description" {
  type        = string
  description = "Specify description of stack"
  default     = null
}

variable "labels" {
  type        = list(string)
  description = "A list of labels for the stack"
  default     = []
}

variable "local_preview_enabled" {
  type        = bool
  description = "Indicates whether local preview runs can be triggered on this Stack"
  default     = false
}

variable "manage_state" {
  type        = bool
  description = "Flag to enable/disable manage_state setting in stack"
  default     = true
}

variable "repository" {
  type        = string
  description = "The name of your infrastructure repo"
}

variable "space_id" {
  type        = string
  description = "Place the stack in the specified space_id."
  default     = "root"
}

variable "stack_destructor_enabled" {
  type        = bool
  description = "Flag to enable/disable the stack destructor to destroy the resources of the stack before deleting the stack itself"
  default     = false
}

variable "stack_name" {
  type        = string
  description = "The name of the Spacelift stack"
}

variable "terraform_version" {
  type        = string
  description = "Specify the version of Terraform to use for the stack"
  default     = null
}
