variable "policy_name" {
  type        = string
  description = "The name of the policy to create. Should be unique across the spacelift account."
}

variable "body" {
  type        = string
  description = "The body of the policy to create. Mutually exclusive with `var.body_url`."
  default     = null
}

variable "body_url" {
  type        = string
  description = "The URL of file containing the body of policy to create. Mutually exclusive with `var.body`."
  default     = null
}

variable "body_url_version" {
  type        = string
  description = "The optional policy version injected using a %s in `var.body_url`. This can be pinned to a version tag or a branch."
  default     = "master"
}

variable "type" {
  type        = string
  description = "The type of the policy to create."

  validation {
    condition     = can(regex("^(ACCESS|APPROVAL|GIT_PUSH|INITIALIZATION|LOGIN|PLAN|TASK|TRIGGER|NOTIFICATION)$", var.type))
    error_message = "The type must be one of ACCESS, APPROVAL, GIT_PUSH, INITIALIZATION, LOGIN, PLAN, TASK, TRIGGER or NOTIFICATION"
  }
}

variable "labels" {
  type        = set(string)
  description = "List of labels to add to the policy."
  default     = []
}

variable "space_id" {
  type        = string
  description = "The `space_id` (slug) of the space the policy is in."
}
