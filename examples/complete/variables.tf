variable "config_file_path" {
  type        = string
  description = "Relative path to YAML config files"
  default     = null
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
