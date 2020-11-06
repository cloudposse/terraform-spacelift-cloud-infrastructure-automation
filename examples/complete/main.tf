module "example" {
  source = "../.."

  administrative    = true
  autodeploy        = true
  branch            = "master"
  description       = "Shared production infrastructure (networking, k8s)"
  repository        = "core-infra"
  terraform_version = "0.12.6"

  context = module.this.context
}
