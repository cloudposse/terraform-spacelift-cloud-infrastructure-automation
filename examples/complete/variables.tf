variable "space_name" {
  type        = string
  description = "Name of the space"
}

variable "description" {
  type        = string
  description = "Description of the space"
  default     = null
}

variable "parent_space_id" {
  type        = string
  description = "ID of the parent space"
  default     = "root"
}

variable "inherit_entities_from_parent" {
  type        = bool
  description = "Flag to indicate whether this space inherits read access to entities from the parent space."
  default     = false
}

variable "labels" {
  type        = set(string)
  description = "List of labels to add to the space."
  default     = []
}

variable "inline_policy_name" {
  type = string
}

variable "inline_policy_type" {
  type = string
}

variable "inline_policy_body" {
  type = string
}

variable "inline_policy_labels" {
  type    = set(string)
  default = []
}

variable "catalog_policy_name" {
  type = string
}

variable "catalog_policy_body_url" {
  type = string
}

variable "catalog_policy_type" {
  type = string
}

# "master"
variable "catalog_policy_body_url_version" {
  type = string
}

variable "catalog_policy_labels" {
  type    = set(string)
  default = []
}

variable "file_policy_name" {
  type = string
}

variable "file_policy_type" {
  type = string
}

variable "file_policy_body_path" {
  type = string
}

variable "file_policy_labels" {
  type    = set(string)
  default = []
}
