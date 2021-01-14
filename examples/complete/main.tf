provider "spacelift" {}

module "example" {
  source = "../.."

  stack_config_path = var.stack_config_path
  branch            = var.branch
  repository        = var.repository
  manage_state      = true
  terraform_version = var.terraform_version

  external_execution = true
}
