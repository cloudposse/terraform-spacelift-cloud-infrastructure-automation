variable "inline_policy_name" {
  type        = string
  description = "Name of the Spacelift policy defined inline within the Terraform configuration"
}

variable "inline_policy_type" {
  type        = string
  description = "Type of the inline Spacelift policy (e.g., 'PLAN', 'TRIGGER', 'GIT_PUSH')"
}

variable "inline_policy_body" {
  type        = string
  description = "Body of the inline Spacelift policy in Rego format"
}

variable "inline_policy_labels" {
  type        = set(string)
  description = "Set of labels to attach to the inline Spacelift policy"
  default     = []
}

variable "catalog_policy_name" {
  type        = string
  description = "Name of the Spacelift policy sourced from a policy catalog"
}

variable "catalog_policy_body_url" {
  type        = string
  description = "URL pointing to the Rego policy body in the catalog repository"
}

variable "catalog_policy_type" {
  type        = string
  description = "Type of the catalog Spacelift policy (e.g., 'PLAN', 'TRIGGER', 'GIT_PUSH')"
}

variable "catalog_policy_body_url_version" {
  type        = string
  description = "Version or branch of the catalog policy to use (e.g., 'master')"
}

variable "catalog_policy_labels" {
  type        = set(string)
  description = "Set of labels to attach to the catalog Spacelift policy"
  default     = []
}

variable "file_policy_name" {
  type        = string
  description = "Name of the Spacelift policy sourced from a local file"
}

variable "file_policy_type" {
  type        = string
  description = "Type of the file-based Spacelift policy (e.g., 'PLAN', 'TRIGGER', 'GIT_PUSH')"
}

variable "file_policy_body_path" {
  type        = string
  description = "File path to the Rego policy body for the file-based Spacelift policy"
}

variable "file_policy_labels" {
  type        = set(string)
  description = "Set of labels to attach to the file-based Spacelift policy"
  default     = []
}
