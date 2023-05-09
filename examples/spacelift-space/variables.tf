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
