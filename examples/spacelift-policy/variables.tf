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
