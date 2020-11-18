provider "spacelift" {}

module "example" {
  source = "../.."

  stack_config_path = var.stack_config_path
  branch            = var.branch
  repository        = var.repository

  external_execution = true
}
