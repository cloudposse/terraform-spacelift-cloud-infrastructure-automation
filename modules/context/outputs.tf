output "context_id" {
  description = "The context ID of the created stack."
  value       = var.enabled ? spacelift_context.default[0].id : null
}
