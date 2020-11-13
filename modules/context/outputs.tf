output "context_id" {
  value = var.enabled ? spacelift_context.default[0].id : null
}