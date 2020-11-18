provider "spacelift" {}

module "example" {
  source = "../.."

  config_file_path = var.config_file_path
  branch           = var.branch
  repository       = var.repository

  external_execution = true
}
