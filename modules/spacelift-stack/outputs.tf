output "stack" {
  description = "The created stack"
  value       = local.enabled ? spacelift_stack.this[0] : null
  sensitive   = true
}

output "id" {
  description = "The stack id"
  value       = local.enabled ? spacelift_stack.this[0].id : null
}
