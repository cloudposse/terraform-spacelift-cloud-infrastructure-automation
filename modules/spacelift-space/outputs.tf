output "space_id" {
  description = "The ID of the created space"
  value       = local.enabled ? spacelift_space.this[0].id : null
}

output "space" {
  description = "The created space"
  value       = local.enabled ? spacelift_space.this[0] : null
}
