output "config" {
  description = "A map of stack configurations"

  value = try({
    id                           = spacelift_stack.default[0].id
    name                         = spacelift_stack.default[0].name
    autodeploy                   = spacelift_stack.default[0].autodeploy
    terraform_version            = spacelift_stack.default[0].terraform_version
    terraform_smart_sanitization = spacelift_stack.default[0].terraform_smart_sanitization
    worker_pool_id               = spacelift_stack.default[0].worker_pool_id
    repository                   = spacelift_stack.default[0].repository
    branch                       = spacelift_stack.default[0].branch
    webhook_id                   = join("", spacelift_webhook.default.*.id)
    aws_role_id                  = join("", spacelift_aws_role.default.*.id)
    stack_destructor_id          = join("", spacelift_stack_destructor.default.*.id)
  }, "disabled")
}
