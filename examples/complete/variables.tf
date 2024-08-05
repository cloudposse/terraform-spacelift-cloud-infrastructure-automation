variable "space_name" {
  type        = string
  description = "Name of the Spacelift space where policies will be applied"
}

variable "description" {
  type        = string
  description = "Description of the Spacelift space"
  default     = null
}

variable "parent_space_id" {
  type        = string
  description = "ID of the parent Spacelift space. Use 'root' for top-level spaces"
  default     = "root"
}

variable "inherit_entities_from_parent" {
  type        = bool
  description = "Flag to indicate whether this space inherits read access to entities from the parent space"
  default     = false
}

variable "labels" {
  type        = set(string)
  description = "List of labels to add to the Spacelift space"
  default     = []
}

variable "inline_policy_name" {
  type        = string
  description = "Name of the inline Spacelift policy"
}

variable "inline_policy_type" {
  type        = string
  description = "Type of the inline Spacelift policy (e.g., 'PLAN', 'TRIGGER')"
}

variable "inline_policy_body" {
  type        = string
  description = "Body of the inline Spacelift policy in Rego format"
}

variable "inline_policy_labels" {
  type        = set(string)
  description = "List of labels to add to the inline Spacelift policy"
  default     = []
}

variable "catalog_policy_name" {
  type        = string
  description = "Name of the catalog Spacelift policy"
}

variable "catalog_policy_body_url" {
  type        = string
  description = "URL of the catalog Spacelift policy body in Rego format"
}

variable "catalog_policy_type" {
  type        = string
  description = "Type of the catalog Spacelift policy (e.g., 'PLAN', 'TRIGGER')"
}

variable "catalog_policy_body_url_version" {
  type        = string
  description = "Version or branch of the catalog policy to use (e.g., 'master')"
}

variable "catalog_policy_labels" {
  type        = set(string)
  description = "List of labels to add to the catalog Spacelift policy"
  default     = []
}

variable "file_policy_name" {
  type        = string
  description = "Name of the file-based Spacelift policy"
}

variable "file_policy_type" {
  type        = string
  description = "Type of the file-based Spacelift policy (e.g., 'PLAN', 'TRIGGER')"
}

variable "file_policy_body_path" {
  type        = string
  description = "File path to the Rego policy body for the file-based Spacelift policy"
}

variable "file_policy_labels" {
  type        = set(string)
  description = "List of labels to add to the file-based Spacelift policy"
  default     = []
}
