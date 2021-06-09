output "config" {
  description = "A map of stack configurations"

  value = try({
    id                = spacelift_stack.default[0].id
    name              = spacelift_stack.default[0].name
    autodeploy        = spacelift_stack.default[0].autodeploy
    terraform_version = spacelift_stack.default[0].terraform_version
    worker_pool_id    = spacelift_stack.default[0].worker_pool_id
    repository        = spacelift_stack.default[0].repository
    branch            = spacelift_stack.default[0].branch
    webhook_id        = join("", spacelift_webhook.default.*.id)
  }, "disabled")
}
