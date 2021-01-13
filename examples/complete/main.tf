provider "spacelift" {}

module "example" {
  source = "../.."

  stack_config_path = var.stack_config_path
  branch            = var.branch
  repository        = var.repository
  terraform_version = "0.13.5"

  external_execution = true
}
