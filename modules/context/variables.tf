variable "enabled" {
  description = "Controls creation of all resources in this module."
  default     = false
  type        = bool
}

variable "context_name" {
  type        = string
  description = "Name of the Spacelift context"
}

variable "environment_variables" {
  type        = map(any)
  description = "A map of environment variables to add to the context"
}
