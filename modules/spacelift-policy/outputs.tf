output "id" {
  description = "The ID of the created policy."
  value       = local.enabled ? spacelift_policy.this[0].id : null
}

output "policy" {
  description = "The created policy."
  value       = local.enabled ? spacelift_policy.this[0] : null
}
